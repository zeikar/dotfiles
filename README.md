# 🛠️ My macOS Dotfiles

**Personal macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).**  
Easily configurable and portable across different macOS machines. 🍏

---

## 📌 Features

- 🔧 **Managed with GNU Stow** – Simple and organized dotfiles management
- 🖥️ **macOS Compatible** – Specifically set up for macOS environments
- 🚀 **Easy Setup & Installation** – Quickly configure a new Mac with a few commands
- 🌟 **Includes configurations for**:
  - `zsh` (`.zshrc`)
  - More to be added!

---

## Prerequisites

Before installing these dotfiles, make sure you have the following installed on your macOS:

- **[Homebrew](https://brew.sh/)**: Package manager for macOS

Install with:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

- **[Oh My Zsh](https://ohmyz.sh/)**: Zsh configuration manager

Install with:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Other Recommended Tools

- **Zsh Plugins**:

Install with:

```bash
brew install zsh-autosuggestions zsh-syntax-highlighting
```

- **[uv](https://docs.astral.sh/uv)**: Python package and project manager

Install with:

```bash
brew install uv
```

## ⚡ Installation

### 0️⃣ Install GNU Stow (if not already installed)

```bash
brew install stow
```

### 1️⃣ Stow your dotfiles

```bash
./install.sh
```

### 2️⃣ Update your shell

```bash
source ~/.zshrc
```
