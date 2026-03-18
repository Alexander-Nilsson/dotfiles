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
  builtin z "$@" && ls -a
}

function cd() {
  builtin cd "$@" && ls -a
}

alias ls='eza -a --color=auto'
alias vim='nvim'
alias c='clear'
alias grep='rg --color=auto'
alias j='z'
alias ji='z -i'

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim 

# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

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
alias apt-get='sudo apt-get'
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
alias in_vim='nvim $(fzf -m --preview="bat --color=always {}")'

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
