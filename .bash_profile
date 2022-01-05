if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

HOMEBREW_PREFIX="$(brew --prefix)"

path_prepend ${HOME}/Library/Python/3.9/bin
path_prepend ${HOMEBREW_PREFIX}/opt/binutils/bin
path_prepend /usr/local/sbin

# bash completion by bash-completion fomurae
[[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# git completion
. ${HOMEBREW_PREFIX}/etc/bash_completion.d/git-completion.bash

# asdf
. ${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh
. ${HOMEBREW_PREFIX}/opt/asdf/etc/bash_completion.d/asdf.bash

# TODO: poetry completion setting
#  bash completion now NOT working on bash 3.x.
#  if fix issue, re-exec bellow and delete this TODO note:
#  poetry completions bash > $(brew --prefix)/etc/bash_completion.d/poetry.bash-completion

# To set JAVA_HOME
#  this is cause slows down the execution of 'cd'...
#. ~/.asdf/plugins/java/set-java-home.bash

unset HOMEBREW_PREFIX

