#!/usr/bin/env bash
# shellcheck shell=bash
[[ "${DEBUG:-}" == "1" ]] && set -x && export DEBUG=1

export SCRIPTS DOTFILES
SCRIPTS="$(cd "$(dirname "$0")" || exit 1; pwd)"
DOTFILES="$(cd "$(dirname "$0")/.." || exit 1; pwd)"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
