ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Early core functions (critical fix)
autoload -Uz is-at-least colors add-zsh-hook compinit
colors

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ── Plugins ────────────────────────────────────────────────────────────────
zinit wait lucid light-mode for \
    zsh-users/zsh-completions \
    Aloxaf/fzf-tab \
    olets/zsh-abbr \
    zsh-users/zsh-history-substring-search

zinit wait lucid light-mode for \
    zsh-users/zsh-autosuggestions

# ── OMZ Snippets ───────────────────────────────────────────────────────────
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux

# ── Fast syntax highlighting + deferred compinit (last in plugins) ──────────
zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting  # dummy to trigger the hook

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicates first
setopt HIST_REDUCE_BLANKS

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -a --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -a --color=always $realpath'

# -------------------------------------------------------
# Aliases
# -------------------------------------------------------

# Define a function that wraps the built-in cd command
# and then lists the directory contents (including hidden files).
function z() {
    __zoxide_z "$@" && eza -a --color=always --icons
}

function cd() {
  builtin cd "$@" && eza -a --color=always --icons
}

alias ls='eza -a --color=always --icons'
alias vim='nvim'
alias c='clear'
alias grep='rg --color=auto'
alias j='z'
alias ji='z -i'

alias anki='anki-wrapper'

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim 

# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS="$(vivid generate one-dark)"

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias vi='nvim'

# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Search command line history
alias h="history | grep "

# Search files in the current folder
alias f="find . | grep "

# invim alias
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
alias invim='nvim $(fzf -m --preview="bat --color=always {}")'

# Open files by extension
alias -s {conf,json,jsonc,css,sh,md,txt,lua}=nvim
alias -s {mp4,mkv,webm,mp3,flac,wav}=mpv
alias -s {png,jpg,jpeg,webp,gif}=kitty +kitten icat

# abbr for writing out git commit + cursor position  
export ABBR_SET_EXPANSION_CURSOR=1
export ABBR_AUTOLOAD=1

export PATH="$HOME/.local/bin:$PATH"
# export PATH=/opt/miniconda3/bin:$PATH
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

# Shell integrations
eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval $(thefuck --alias)
eval "$(zoxide init zsh)"

# Auto-start logging with script into ~/Documents/logs
if [ -z "$SCRIPT_LOGGER" ]; then
    export SCRIPT_LOGGER=1
    logfile="$HOME/Documents/logs/$(date +%F).log"
    mkdir -p "$HOME/Documents/logs"
    exec script -q -a "$logfile"
fi

export PATH="$HOME/.npm-global/bin:$PATH"
