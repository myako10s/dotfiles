## path
typeset -U path PATH
path=(
  $(brew --prefix libpq)/bin(N-/)
  ~/go/bin(N-/)
  ~/.bin(N-/)
  $path
)

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

. $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
. $(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc

## alias
alias ls="ls -FG"
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
# alias brew="PATH=${PATH/${HOME}\/\.asdf\/shims:/} brew"
alias python="python3"
alias pip="pip3"
alias g="git"
alias k="kubectl"

## completion
fpath=(
  $(brew --prefix)/share/zsh-completions(N-/)
  $(brew --prefix)/share/zsh/site-functions(N-/)
  $fpath
)
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
autoload -Uz compinit && compinit
zstyle ':completion:*:commands' rehash 1
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:cd:*' ignore-parents parent pwd

## history
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
setopt hist_no_store
setopt hist_expand

## prompt
autoload -Uz colors && colors
autoload -Uz promptinit && promptinit
zstyle :prompt:pure:path color 027
prompt pure

## other settings
setopt autopushd
setopt pushdminus
setopt pushdsilent
setopt pushdignoredups
setopt nobeep
setopt nolistbeep
setopt correct

## set DOCKER_HOST if lima is running
[ -f "$HOME/.docker-host-env" ] && source "$HOME/.docker-host-env"

## terraform autocomplete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

## azure-cli autocomplete
autoload bashcompinit && bashcompinit
source $(brew --prefix)/etc/bash_completion.d/az

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/ms/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
