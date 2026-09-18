#!/usr/bin/env bash

set -euo pipefail

echo "Applying macOS defaults..."

# Disable press-and-hold so key repeat works in editors and terminals.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Speed up key repeat.
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

# Tab through every control in dialogs, not just text fields. Sonoma and later
# take 2 here; the older value 3 no longer turns this on.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

# Autocorrect and smart punctuation corrupt pasted code, commands, and CLI flags.
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Save to disk instead of iCloud by default.
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Finder: show all filename extensions and hidden files.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: sort by Kind, and keep folders above files.
defaults write com.apple.finder FXArrangeGroupViewBy -string "Kind"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: list view, with the path and status bars visible.
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: search the current folder instead of the whole Mac, and drop the
# warning when an extension changes.
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder: open new windows in the dev directory rather than Recents.
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/Developer/"

# Keep .DS_Store off network shares and USB volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Dock: autohide, with no delay before it appears. The slide animation is
# left at the system default -- removing it entirely feels abrupt.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0

# Dock: no recent applications section.
defaults write com.apple.dock show-recents -bool false

# Screenshots: no drop shadow, so a window capture is cropped tight.
defaults write com.apple.screencapture disable-shadow -bool true

killall Finder || true
killall Dock || true
killall SystemUIServer || true

echo "macOS defaults applied. Some changes may require logout/restart."
