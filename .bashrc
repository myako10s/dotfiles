alias ll='ls -l'
alias quit='exit'
alias brew="env PATH=${PATH/\/Users\/makoto\/\.asdf\/shims:/} brew"

path_append ()  { [ -z "$1" ] && return 1; path_remove $1; export PATH="$PATH:$1"; }
path_prepend () { [ -z "$1" ] && return 1; path_remove $1; export PATH="$1:$PATH"; }
path_remove ()  { [ -z "$1" ] && return 1; export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }

