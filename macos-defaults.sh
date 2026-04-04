#!/usr/bin/env bash

set -euo pipefail

echo "Applying macOS defaults..."

# Disable press-and-hold so key repeat works in editors and terminals.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Speed up key repeat.
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

# Save to disk instead of iCloud by default.
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Finder: show all filename extensions and hidden files.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true

# Dock: autohide and remove the delay.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0

killall Finder || true
killall Dock || true

echo "macOS defaults applied. Some changes may require logout/restart."
