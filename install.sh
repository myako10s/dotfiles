#!/usr/bin/env bash
# shellcheck shell=bash

[[ "${DEBUG:-}" == "1" ]] && export DEBUG=1

INSTALL_DIR="${INSTALL_DIR:-$HOME/.dotfiles.git}"

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating dotfiles..."
    git -C "$INSTALL_DIR" pull
else
    echo "Installing dotfiles..."
    git clone https://github.com/myako10s/dotfiles.git "$INSTALL_DIR"
fi

/bin/bash "$INSTALL_DIR/scripts/setup.bash"
