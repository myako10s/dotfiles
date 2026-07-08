#!/usr/bin/env bash
# shellcheck shell=bash
set -e
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

[ "$(uname)" != "Darwin" ] && exit
[ -n "$SKIP_HOMEBREW" ] && exit

if type brew >/dev/null; then
    echo "Homebrew is already installed."
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Updating Homebrew..."
brew update

if [[ "$DEBUG" == "1" ]]; then
    # Reduce GitHub Actions minutes consumption
    echo "Skipping Homebrew apps installation in debug mode."
else
    echo "Installing Homebrew apps..."
    brew bundle install --file "${DOTFILES}/config/homebrew/Brewfile" --no-upgrade
fi

if brew list | grep -q "google-chrome"; then
    brew pin --cask google-chrome
    echo "Pinned Google Chrome to prevent updates by Homebrew."
fi
true
