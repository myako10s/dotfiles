#!/bin/bash

set -e
OS="$(uname -s)"
DOT_DIRECTORY="${HOME}/dotfiles"
DOT_TARBALL="https://github.com/myako10s/dotfiles/tarball/main"
REMOTE_URL="https://github.com/myako10s/dotfiles.git"

has() {
  type "$1" > /dev/null 2>&1
}

usage() {
  name=`basename $0`
  cat <<EOF
Usage:
  $name [arguments] [command]
Commands:
  deploy        deploy dotfiles
  install       install apps
  update        update Brewfile
Arguments:
  -f $(tput setaf 1)** warning **$(tput sgr0) Overwrite dotfiles.
  -h Print help (this message)
EOF
  exit 1
}

while getopts "fh" opt; do
  case ${opt} in
    f)
      OVERWRITE=true
      ;;
    h)
      usage
      ;;
  esac
done
shift $((OPTIND - 1))

# If missing, download and extract the dotfiles repository
if [ ! -d ${DOT_DIRECTORY} ]; then
  echo "Downloading dotfiles..."
  mkdir ${DOT_DIRECTORY}

  if has "git"; then
    git clone --recursive "${REMOTE_URL}" "${DOT_DIRECTORY}"
  else
    curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOT_TARBALL}
    tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOT_DIRECTORY}
    rm -f ${HOME}/dotfiles.tar.gz
  fi

  echo $(tput setaf 2)Download dotfiles complete!. ✔︎$(tput sgr0)
fi

cd ${DOT_DIRECTORY}
source ./lib/helper.sh
source ./lib/brew.sh
source ./lib/asdf.sh
source ./lib/osx.sh

install() {
  # ignore shell execution error temporarily
  set +e

  case ${OSTYPE} in
    darwin*)
      run_osx
      run_brew
      ;;
    *)
      echo $(tput setaf 1)Working only OSX$(tput sgr0)
      exit 1
      ;;
  esac

  run_asdf

  echo "$(tput setaf 2)Install complete!. ✔︎$(tput sgr0)"
  echo "You can restart login-shell: exec \$SHELL -l"
}

update() {
  brew bundle dump -f
  echo "$(tput setaf 2)Update Brewfile complete!. ✔︎$(tput sgr0)"
}

link_files() {
  for f in .??*
  do
    # If you have ignore files, add file/directory name here
    [[ ${f} = ".git" ]] && continue
    [[ ${f} = ".gitignore" ]] && continue

    # Force remove file/directory if it's already there
    [ -n "${OVERWRITE}" -a -e ${HOME}/${f} ] && rm -f ${HOME}/${f}
    if [ ! -e ${HOME}/${f} ]; then

      ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
    fi
  done

  # Other files that do not start with .??*,
  # add file/directory name here with "src dest" format
  otherfiles=(
    "git .config/git" # git
    "minikube/config/config.json .minikube/config/config.json"
    "karabiner .config/karabiner"
  )

  for src_dest_pair in "${otherfiles[@]}"
  do
    src_dest=(${src_dest_pair})
    src=${src_dest[0]}
    dest=${src_dest[1]}
    [ -n "${OVERWRITE}" -a -e ${HOME}/${dest} ] && rm -f ${HOME}/${dest}
    if [ ! -e ${HOME}/${dest} ]; then
      mkdir -p $(dirname ${HOME}/${dest})
      ln -snfv ${DOT_DIRECTORY}/${src} ${HOME}/${dest}
    fi
  done

  echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)
}

command=$1
[ $# -gt 0 ] && shift

case $command in
  deploy)
    link_files
    ;;
  install)
    install
    ;;
  update)
    update
    ;;
  *)
    usage
    ;;
esac

exit 0
