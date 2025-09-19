#!/usr/bin/env bash
# shellcheck shell=bash
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

[ "$(uname)" != "Darwin" ] && exit

touch "$HOME/.hushlogin"

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keyboard
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 35
defaults write com.apple.dock magnification -bool false

# Mission Control
defaults write com.apple.dock wvous-br-corner -int 1 # Bottom right -> No Action
defaults write com.apple.dock wvous-br-modifier -int 0

# Disable .DS_Store on network disks
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Screen capture
defaults write com.apple.screencapture location ~/Downloads
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture show-thumbnail -bool true

killall Dock
killall Finder
killall SystemUIServer
