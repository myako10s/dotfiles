#!/usr/bin/env bash
# shellcheck shell=bash

set -euo pipefail

if command -v git >/dev/null 2>&1; then
    echo "git is already installed."
    exit 0
fi

echo "git not found. Installing..."

# OS check
OS="$(uname -s)"
case "$OS" in
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
            echo "Installing git via apt..."
            sudo apt update
            sudo apt install -y git
        # Fedora/CentOS/RHEL
        elif [ -f /etc/redhat-release ]; then
            echo "Installing git via dnf..."
            sudo dnf install -y git || sudo yum install -y git
        else
            echo "Unsupported Linux distribution. Please install git manually."
            exit 1
        fi
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Verify installation
if ! command -v git >/dev/null 2>&1; then
    echo "git installation failed. Please install manually."
    exit 1
fi

echo "git installed successfully."
