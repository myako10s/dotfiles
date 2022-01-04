#!/bin/bash

if ! has "path_remove"; then
  path_remove ()  { [ -z "$1" ] && return 1; export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }
fi

if ! has "path_append"; then
  path_append ()  { [ -z "$1" ] && return 1; path_remove $1; export PATH="$PATH:$1"; }
fi

if ! has "path_prepend"; then
  path_prepend () { [ -z "$1" ] && return 1; path_remove $1; export PATH="$1:$PATH"; }
fi

