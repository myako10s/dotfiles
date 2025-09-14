#!/usr/bin/env bash
# shellcheck shell=bash
set -e
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

if [[ ! -d "$HOME/.ssh" ]]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

# if [[ ! -d "$HOME/.gnupg" ]]; then
#     mkdir -p "$HOME/.gnupg"
#     chmod 700 "$HOME/.gnupg"
# fi

mkdir -p \
    "$XDG_CONFIG_HOME" \
    "$XDG_STATE_HOME" \
    "$XDG_DATA_HOME/vim"

ln -snfv "$DOTFILES/config/"* "$XDG_CONFIG_HOME"
ln -snfv "$XDG_CONFIG_HOME/zsh/.zshenv" "$HOME/.zshenv"
ln -snfv "$XDG_CONFIG_HOME/zsh/.zshrc" "$HOME/.zshrc"
ln -snfv "$XDG_CONFIG_HOME/editorconfig/.editorconfig" "$HOME/.editorconfig"
mkdir -p "$HOME/.minikube/config"
ln -snfv "$XDG_CONFIG_HOME/minikube/config.json" "$HOME/.minikube/config/config.json"
