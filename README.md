# My macOS Dotfiles

Minimal macOS dotfiles managed with GNU Stow.

## What is tracked

- `zsh/` for shell configuration
- `Brewfile` for package reproducibility
- `macos-defaults.sh` for common macOS preferences

Machine-specific secrets stay outside the repo:

- `~/.zshrc.local`

## Prerequisites

Required:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install stow
```

Optional but recommended:

```bash
brew bundle --file Brewfile

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

The shell config is defensive now, so missing optional tools will not break shell startup.

## Install

```bash
./install.sh
source ~/.zshrc
```

What `install.sh` does:

- stows tracked packages into `$HOME`
- detects recursive conflicts before linking
- backs up replaced files to `~/.dotfiles-backups/<timestamp>/`
- creates `~/.zshrc.local` when missing

## Restore packages

Install packages from the tracked Homebrew bundle:

```bash
brew bundle --file Brewfile
```

## Apply macOS preferences

Review the script first, then run it manually if you want those defaults:

```bash
chmod +x macos-defaults.sh
./macos-defaults.sh
```

## Local-only files

Example `~/.zshrc.local`:

```bash
export GITHUB_TOKEN="your_token_here"
export OPENAI_API_KEY="your_key_here"
```

## Structure

```text
dotfiles/
├── Brewfile
├── install.sh
├── macos-defaults.sh
├── zsh/
│   ├── .zshrc
│   └── .zshrc.local.example
└── README.md
```
