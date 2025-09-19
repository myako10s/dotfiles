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
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Trackpad
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.0

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 35
defaults write com.apple.dock magnification -bool false

# Mission Control
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0
{
  local PLIST="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"
  /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:32:enabled 0" "$PLIST"
  /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:33:enabled 0" "$PLIST"
  /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:79:enabled 0" "$PLIST"
  /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:81:enabled 0" "$PLIST"
}

# Disable .DS_Store on network disks
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Screen capture
defaults write com.apple.screencapture location ~/Downloads
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture show-thumbnail -bool true

killall Dock
killall Finder
killall SystemUIServer

# Enable Touch ID for sudo
FILE="/etc/pam.d/sudo_local"
if [ ! -e "$FILE" ]; then
    echo "Creating $FILE ..."
    sudo tee "$FILE" > /dev/null <<'EOF'
# sudo_local: local config file which survives system update and is included for sudo
# uncomment following line to enable Touch ID for sudo
auth       sufficient     pam_tid.so
EOF
    echo "$FILE created successfully."
else
    echo "$FILE already exists. Skipping."
fi

# Install Rosetta 2
if ! /usr/bin/pgrep oahd >/dev/null 2>&1; then
  echo "Installing Rosetta 2..."
  sudo softwareupdate --install-rosetta --agree-to-license
fi
