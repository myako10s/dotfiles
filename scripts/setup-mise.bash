#!/usr/bin/env bash
# shellcheck shell=bash
set -e
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

export PATH="$HOME/.local/bin:$PATH"

# install mise
if ! command -v mise &>/dev/null; then
    echo "installing mise..."
    mkdir -p "$HOME/.local/bin"
    curl https://mise.run | sh
else
    echo "mise is already installed"
fi

# verify installation
if ! command -v mise &>/dev/null; then
    echo "mise installation failed" >&2
    exit 1
fi

# completion
mkdir -p "$XDG_DATA_HOME/zsh/site-functions"
mise completion zsh > "$XDG_DATA_HOME/zsh/site-functions/_mise"

# install tools
[ -f "$XDG_CONFIG_HOME/mise/config.toml" ] && mise install
