#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

DOTFILES=("zsh" "claude")
BACKUP_ROOT="$HOME/.dotfiles-backups/$(date +%Y%m%d-%H%M%S)"

LOCAL_TEMPLATES=(
    "zsh/.zshrc.local.example:$HOME/.zshrc.local"
)

resolve_path() {
    perl -MCwd=abs_path -e 'my $path = shift; my $resolved = abs_path($path); print $resolved if defined $resolved;' "$1"
}

ensure_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "❌ Required command not found: $1" >&2
        exit 1
    fi
}

backup_and_remove() {
    local target="$1"
    local relative_path="$2"
    local backup_target="$BACKUP_ROOT/$relative_path"

    mkdir -p "$(dirname "$backup_target")"
    echo "💾 Backing up $target -> $backup_target"
    mv "$target" "$backup_target"
}

ensure_command stow

echo "🔹 Starting dotfiles installation..."
echo ""

for dir in "${DOTFILES[@]}"; do
    echo "🔍 Processing package: $dir"

    files_found=()
    while IFS= read -r file; do
        files_found+=("$file")
    done < <(find "$dir" -type f ! -name "*.example" | sort)
    conflicts=()

    for file in "${files_found[@]}"; do
        relative_path="${file#"$dir"/}"
        target="$HOME/$relative_path"

        if [[ -L "$target" ]]; then
            target_resolved="$(resolve_path "$target" || true)"
            source_resolved="$(resolve_path "$file" || true)"

            if [[ -n "$target_resolved" && -n "$source_resolved" && "$target_resolved" == "$source_resolved" ]]; then
                continue
            fi
        fi

        if [[ -e "$target" || -L "$target" ]]; then
            conflicts+=("$relative_path")
        fi
    done

    if (( ${#conflicts[@]} > 0 )); then
        echo "⚠️  Existing files would conflict:"
        for relative_path in "${conflicts[@]}"; do
            echo "   - $HOME/$relative_path"
        done

        read -r -p "Back up and replace files for package '$dir'? (y/N): " confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            for relative_path in "${conflicts[@]}"; do
                target="$HOME/$relative_path"
                backup_and_remove "$target" "$relative_path"
            done
        else
            echo "🚫 Skipping package '$dir'."
            echo ""
            continue
        fi
    else
        echo "✅ No conflicts detected."
    fi

    echo "🔗 Running: stow --restow --target=\"$HOME\" \"$dir\""
    stow --restow --target="$HOME" "$dir"
    echo ""
done

for mapping in "${LOCAL_TEMPLATES[@]}"; do
    template="${mapping%%:*}"
    target="${mapping#*:}"

    if [[ -f "$target" ]]; then
        echo "ℹ️  $target already exists, skipping template copy."
        continue
    fi

    if [[ -f "$template" ]]; then
        cp "$template" "$target"
        echo "✅ Created $target from $template"
    else
        touch "$target"
        echo "⚠️  Template $template not found; created empty $target"
    fi
done

echo ""
echo "🎉 Dotfiles installation complete!"
echo "🚀 Next step: Reload your shell with 'source ~/.zshrc'"
