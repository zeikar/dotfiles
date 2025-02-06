#!/bin/bash

# List of dotfiles directories to manage
DOTFILES=("zsh")

echo "🔹 Starting dotfiles installation..."

for dir in "${DOTFILES[@]}"; do
    echo "🔍 Processing directory: $dir"
    conflict=false

    # Use find to list only top-level files in the directory
    files_found=$(find "$dir" -maxdepth 1 -type f)

    # Check if any file in this directory already exists in HOME
    for file in $files_found; do
        target="$HOME/$(basename "$file")"
        if [ -e "$target" ]; then
            echo "❗ $target already exists."
            conflict=true
            break
        fi
    done

    if $conflict; then
        read -r -p "Overwrite existing files in directory '$dir'? (y/N): " confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            # Remove conflicting files one by one
            for file in $files_found; do
                target="$HOME/$(basename "$file")"
                if [ -e "$target" ]; then
                    echo "🗑 Removing $target"
                    rm "$target"
                fi
            done
            echo "🔗 Running: stow --target=\"$HOME\" \"$dir\""
            stow --target="$HOME" "$dir"
        else
            echo "🚫 Skipping directory '$dir'."
        fi
    else
        echo "✅ No existing files in directory '$dir'. Applying..."
        echo "🔗 Running: stow --target=\"$HOME\" \"$dir\""
        stow --target="$HOME" "$dir"
    fi
done

echo "🎉 Dotfiles installation complete!"
