# ─────────────────────────────────────────────────────────────
# ZINIT SETUP
# ─────────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -d $ZINIT_HOME/.git ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ─────────────────────────────────────────────────────────────
# CORE (must be early)
# ─────────────────────────────────────────────────────────────
autoload -Uz compinit colors
compinit -C   # cached → fast startup
colors

# History (early = important)
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt appendhistory sharehistory incappendhistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups
setopt hist_find_no_dups HIST_EXPIRE_DUPS_FIRST HIST_REDUCE_BLANKS

# Keybindings (early for responsiveness)
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ─────────────────────────────────────────────────────────────
# PLUGINS (load order matters)
# ─────────────────────────────────────────────────────────────

# Instant (affects typing)
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search

# Completions + UI (can be lazy)
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit light olets/zsh-abbr

# Syntax highlighting (lazy but safe now)
zinit wait lucid for \
    zdharma-continuum/fast-syntax-highlighting

# OMZ snippets (lazy)
zinit wait lucid for \
    OMZL::git.zsh \
    OMZP::git \
    OMZP::sudo \
    OMZP::archlinux

# ─────────────────────────────────────────────────────────────
# COMPLETION STYLING
# ─────────────────────────────────────────────────────────────
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:*' fzf-preview 'eza -a --color=always $realpath'

# ─────────────────────────────────────────────────────────────
# NAVIGATION (zoxide + eza)
# ─────────────────────────────────────────────────────────────
function z() {
    __zoxide_z "$@" && eza -a --color=always --icons
}

function cd() {
    builtin cd "$@" && eza -a --color=always --icons
}

alias ls='eza -a --color=always --icons'
alias j='z'
alias ji='z -i'

alias anki='anki-wrapper'

alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'

# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Search command line history
alias h="history | grep "

# Search files in the current folder
alias f="find . | grep "

# FZF file open
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'

# ─────────────────────────────────────────────────────────────
# SUFFIX ALIASES
# ─────────────────────────────────────────────────────────────
alias -s {conf,json,jsonc,css,sh,md,txt,lua}=nvim
alias -s {mp4,mkv,webm,mp3,flac,wav}=mpv
alias -s {png,jpg,jpeg,webp,gif}=kitty\ +kitten\ icat

# ─────────────────────────────────────────────────────────────
# ENV
# ─────────────────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim
export CLICOLOR=1
export LS_COLORS="$(vivid generate one-dark)"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

# ─────────────────────────────────────────────────────────────
# TOOLS (load late)
# ─────────────────────────────────────────────────────────────
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(thefuck --alias)"

# ─────────────────────────────────────────────────────────────
# OPTIONAL: SESSION LOGGING
# ─────────────────────────────────────────────────────────────
if [[ -z "$SCRIPT_LOGGER" ]]; then
    export SCRIPT_LOGGER=1
    logfile="$HOME/Documents/logs/$(date +%F).log"
    mkdir -p "$HOME/Documents/logs"
    exec script -q -a "$logfile"
fi
