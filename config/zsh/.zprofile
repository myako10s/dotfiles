if [ -d /opt/homebrew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if command -v mise >/dev/null; then
  eval "$(mise activate --shims)"
fi
