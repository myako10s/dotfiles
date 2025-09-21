
## alias
alias ls="ls -F --color=auto" # for GNU ls
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias wget='wget --hsts-file="$XDG_STATE_HOME/wget-hsts"'
alias python="python3"
alias pip="pip3"
alias g="git"
alias k="kubectl"

case "$OSTYPE" in
    linux*)
        if (( ${+commands[win32yank.exe]} )); then
            alias pp='win32yank.exe -i'
            alias p='win32yank.exe -o'
        elif (( ${+commands[xsel]} )); then
            alias pp='xsel -bi'
            alias p='xsel -b'
        fi
    ;;
    darwin*)
        path=(
            "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"(N-/)
            "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"(N-/)
            "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"(N-/)
            "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"(N-/)
            "$HOMEBREW_PREFIX/opt/libpq/bin"(N-/)
            "$path[@]"
        )
        alias y='pbcopy'
        alias p='pbpaste'
    ;;
esac

## completion style
zstyle ':completion:*:commands' rehash 1
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:cd:*' ignore-parents parent pwd

## google-cloud-sdk
# source $HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
# source $HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc

## set DOCKER_HOST if lima is running
[ -f "$HOME/.docker-host-env" ] && source "$HOME/.docker-host-env"

## kiro
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

## less
export LESSHISTFILE='-'

## Node.js
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_history"

## npm
export NPM_CONFIG_DIR="$XDG_CONFIG_HOME/npm"
export NPM_DATA_DIR="$XDG_DATA_HOME/npm"
export NPM_CACHE_DIR="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_USERCONFIG="$NPM_CONFIG_DIR/npmrc"

## Python
# export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

## pylint
export PYLINTHOME="$XDG_CACHE_HOME/pylint"

## SQLite3
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"

## MySQL
export MYSQL_HISTFILE="$XDG_STATE_HOME/mysql_history"

## PostgreSQL
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"

## FZF
export FZF_DEFAULT_OPTS='--reverse --border --ansi --bind="ctrl-d:print-query,ctrl-p:replace-query"'
export FZF_DEFAULT_COMMAND='fd --hidden --color=always'


## dotfiles management
# run all setup scripts
dotfiles::setup() {
    /bin/bash "$DOTFILES/scripts/setup.bash" "$@"
}
# link dotfiles
dotfiles::link() {
    /bin/bash "$DOTFILES/scripts/setup-links.bash" "$@"
}
# update package list
dotfiles::update() {
    if command -v apt-mark &>/dev/null; then
        # Ubuntu / Debian
        apt-mark showmanual > "$DOTFILES/config/apt/packages.txt"
        echo "Saved package list to $DOTFILES/config/apt/packages.txt"
    elif command -v brew &>/dev/null; then
        # macOS
        brew bundle dump --force --global
        echo "Saved Brewfile to $DOTFILES/config/homebrew/Brewfile"
    else
        echo "No supported package manager found"
        return 1
    fi
}

## local
if [[ -f "$ZDOTDIR/local.zsh" ]]; then
    source "$ZDOTDIR/local.zsh"
fi

sheldon::load lazy
