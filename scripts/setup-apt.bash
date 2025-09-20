#!/usr/bin/env bash
# shellcheck shell=bash
set -e
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

command -v apt-get >/dev/null || exit 0
[ -n "$SKIP_APT" ] && exit

sudo /bin/sh "$DOTFILES/config/apt/install.sh"
