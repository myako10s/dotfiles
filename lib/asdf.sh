#!/bin/bash

run_asdf() {
  if has "asdf"; then
    echo "$(tput setaf 2)Already installed asdf ✔︎$(tput sgr0)"
  else
    echo "Installing asdf..."
    brew install asdf
    echo -e "\n. $(brew --prefix asdf)/asdf.sh" >> ~/.bash_profile
    echo -e "\n. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash" >> ~/.bash_profile
  fi

  if has "asdf"; then
    if [ -e ${HOME}/.tool-versions ]; then
    echo "Installing asdf packages..."
      asdf install
      [[ $? ]] && echo "$(tput setaf 2)Install packages complete. ✔︎$(tput sgr0)"
    else
      echo "You need install packages manualy."
    fi

  fi
}
