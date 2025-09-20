#!/usr/bin/env bash
# shellcheck shell=bash

[[ "${DEBUG:-}" == "1" ]] && export DEBUG=1

INSTALL_DIR="${INSTALL_DIR:-$HOME/.dotfiles.git}"

ensure_git

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating dotfiles..."
    git -C "$INSTALL_DIR" pull
else
    echo "Installing dotfiles..."
    git clone https://github.com/myako10s/dotfiles.git "$INSTALL_DIR"
fi

/usr/bin/env bash "$INSTALL_DIR/scripts/setup.bash"

# Ensure git is installed
ensure_git() {
    if command -v git >/dev/null 2>&1; then
        return 0
    fi

    echo "git not found. Installing..."
    case "$(uname -s)" in
        Darwin)
            # macOS
            if ! xcode-select -p >/dev/null 2>&1; then
                echo "Installing Xcode Command Line Tools..."
                xcode-select --install || {
                    echo "Please install Xcode Command Line Tools manually."
                    exit 1
                }
            else
                echo "Xcode Command Line Tools already installed."
            fi
            ;;
        Linux)
            # Ubuntu/Debian
            if [ -f /etc/debian_version ]; then
                sudo apt-get update
                sudo apt-get install -y git
            else
                echo "Unsupported Linux distribution. Please install git manually."
                exit 1
            fi
            ;;
        *)
            echo "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
}
