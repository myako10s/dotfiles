## path
typeset -U path PATH
typeset -U fpath FPATH
path=(
  "$HOME/.local/bin"(N-/)
  "$GOPATH/bin"(N-/)
  "$path[@]"
)
fpath=(
  $fpath[@]
)

## history
export HISTFILE="$XDG_STATE_HOME/zsh_history"
HISTSIZE=100000
SAVEHIST=100000
#setopt share_history
setopt append_history
setopt inc_append_history_time
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_expand

## other settings
setopt autopushd
setopt pushdminus
setopt pushdsilent
setopt pushdignoredups
setopt nobeep
setopt nolistbeep
setopt correct

## source
source() {
    local input="$1"
    local cache="$input.zwc"
    if [[ ! -f "$cache" || "$input" -nt "$cache" ]]; then
        zcompile "$input"
    fi
    \builtin source "$@"
}


## sheldon
sheldon::load() {
    local profile="$1"
    local plugins_file="$SHELDON_CONFIG_DIR/plugins.toml"
    local cache_file="$XDG_CACHE_HOME/sheldon/$profile.zsh"
    if [[ ! -f "$cache_file" || "$plugins_file" -nt "$cache_file" ]]; then
        mkdir -p "$XDG_CACHE_HOME/sheldon"
        sheldon --profile="$profile" source >"$cache_file"
        zcompile "$cache_file"
    fi
    \builtin source "$cache_file"
}

sheldon::update() {
    sheldon --profile="eager" lock --update
    sheldon --profile="lazy" lock --update
}

sheldon::load eager
