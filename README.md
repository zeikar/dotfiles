# 🛠️ My macOS Dotfiles

[![macOS](https://img.shields.io/badge/macOS-000000?style=flat&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GNU Stow](https://img.shields.io/badge/managed%20with-GNU%20Stow-brightgreen.svg)](https://www.gnu.org/software/stow/)

> 🚀 Minimal and clean dotfiles for macOS, managed with GNU Stow.

## ✨ Features

- 🔧 Managed with GNU Stow for clean symlink-based configuration
- 🔐 Secure secrets management with `.zshrc.local` (local only)
- 🚀 Quick setup on new machines
- 📦 Includes: `zsh` configuration

---

## 📋 Prerequisites

### Required
```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# GNU Stow
brew install stow
```

### Recommended
```bash
# Zsh plugins
brew install zsh-autosuggestions zsh-syntax-highlighting

# Python package manager
brew install uv

# Ruby
brew install ruby
```

## 🚀 Quick Start

```bash
# 1. Install dotfiles
./install.sh

# 2. Add your secrets (optional)
nano ~/.zshrc.local  # or code ~/.zshrc.local

# 3. Reload shell
source ~/.zshrc
```

The install script automatically creates `~/.zshrc.local` for your secrets (API keys, tokens, etc.).

### Example `~/.zshrc.local`
```bash
export GITHUB_TOKEN="your_token_here"
export OPENAI_API_KEY="your_key_here"
```

---

## 🔐 Secrets Management

Sensitive data goes in `~/.zshrc.local` (automatically created, lives in your home directory):

```
dotfiles/zsh/.zshrc              → Public config (tracked in git)
dotfiles/zsh/.zshrc.local.example → Template (tracked in git)
~/.zshrc.local                    → Your secrets (local only, NOT in repo)
```

The `.zshrc` file automatically loads `~/.zshrc.local` if it exists.

---

## 📂 Structure

```
dotfiles/
├── zsh/
│   ├── .zshrc                   # Main zsh configuration
│   └── .zshrc.local.example     # Template for secrets
├── install.sh                   # Installation script
└── README.md
```

---

## 🤝 Contributing

Feel free to fork this repo and customize it for your own setup! If you have suggestions or improvements:

1. Fork the repo
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

---

## ⭐ Show your support

Give a ⭐️ if this project helped you!
