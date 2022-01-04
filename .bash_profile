if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

path_prepend $HOME/Library/Python/3.9/bin
path_prepend /usr/local/opt/binutils/bin
path_prepend /usr/local/sbin

. /usr/local/opt/asdf/libexec/asdf.sh
. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

# To set JAVA_HOME
. ~/.asdf/plugins/java/set-java-home.bash
