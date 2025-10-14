#!/bin/bash

# List of dotfiles directories to manage
DOTFILES=("zsh")

echo "🔹 Starting dotfiles installation..."

for dir in "${DOTFILES[@]}"; do
    echo "🔍 Processing directory: $dir"
    conflict=false

    # Use find to list only top-level files in the directory
    # Exclude .example files as they are templates only
    files_found=$(find "$dir" -maxdepth 1 -type f ! -name "*.example")

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
echo ""

# Set up local secrets file if it doesn't exist
if [ ! -f "$HOME/.zshrc.local" ]; then
    echo "🔐 Setting up local secrets file..."
    if [ -f "zsh/.zshrc.local.example" ]; then
        cp zsh/.zshrc.local.example "$HOME/.zshrc.local"
        echo "✅ Created ~/.zshrc.local from example template"
        echo "📝 Please edit ~/.zshrc.local to add your actual tokens:"
        echo "   nano ~/.zshrc.local"
        echo "   or"
        echo "   code ~/.zshrc.local"
    else
        echo "⚠️  Example file not found. Creating empty ~/.zshrc.local"
        touch "$HOME/.zshrc.local"
    fi
else
    echo "ℹ️  ~/.zshrc.local already exists, skipping..."
fi

echo ""
echo "🚀 Next step: Reload your shell"
echo "   source ~/.zshrc"
