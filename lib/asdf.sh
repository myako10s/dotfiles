#!/bin/bash

run_asdf() {
  if has "asdf"; then
    echo "$(tput setaf 2)Already installed asdf ✔︎$(tput sgr0)"
  else
    echo "Installing asdf..."
    brew install asdf
    if ! grep -q "$(brew --prefix asdf)/libexec/asdf.sh" ~/.bash_profile; then
      echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.bash_profile
      echo -e "\n. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash" >> ~/.bash_profile
    fi
  fi

  if has "asdf"; then
    if [ -e ${HOME}/.tool-versions ]; then
      echo "Installing asdf packages..."

      # avoid macos-ld-symbols-not-found-for-architecture-x86_64-1245 issue
      path_remove $(brew --prefix binutils)/bin

      asdf install
      [[ $? ]] && echo "$(tput setaf 2)Install packages complete. ✔︎$(tput sgr0)"

      # restore binutils path
      [ -e $(brew --prefix binutils)/bin ] && path_prepend $(brew --prefix binutils)/bin
    else
      echo "You need install packages manualy."
    fi

  fi
}
