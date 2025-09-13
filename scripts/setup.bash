#!/usr/bin/env bash
set -eu
[[ "${DEBUG:-}" == "1" ]] && set -x && export DEBUG=1

# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

# /bin/bash "$SCRIPTS/setup-apt.bash"
/bin/bash "$SCRIPTS/setup-homebrew.bash"
# /bin/bash "$SCRIPTS/setup-links.bash"
# /bin/bash "$SCRIPTS/setup-mac.bash"
