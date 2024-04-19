#!/bin/bash

run_osx() {
  echo -n "Change screencapture location..."
  defaults write com.apple.screencapture location ~/Downloads
  if [ $? -ne 0 ]; then
    killall SystemUIServer
    echo "$(tput setaf 1) failed ✔︎$(tput sgr0)"
  else
    echo "$(tput setaf 2) ✔︎$(tput sgr0)"
  fi
}
