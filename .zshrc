# ─────────────────────────────────────────────────────────────
# ZINIT SETUP
# ─────────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -d $ZINIT_HOME/.git ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ─────────────────────────────────────────────────────────────
# CORE (must be early)
# ─────────────────────────────────────────────────────────────
autoload -Uz colors
colors

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt appendhistory sharehistory incappendhistory
setopt hist_ignore_space hist_ignore_all_dups hist_save_no_dups
setopt hist_find_no_dups HIST_EXPIRE_DUPS_FIRST HIST_REDUCE_BLANKS

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ─────────────────────────────────────────────────────────────
# PLUGINS (carefully ordered)
# ─────────────────────────────────────────────────────────────

# Completions first
zinit light zsh-users/zsh-completions

# fzf-tab MUST come after zsh-completions
zinit light Aloxaf/fzf-tab

# Other instant plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light olets/zsh-abbr

# Syntax highlighting (load late)
zinit wait lucid for \
    zdharma-continuum/fast-syntax-highlighting

# OMZ snippets (lazy)
zinit wait lucid for \
    OMZL::git.zsh \
    OMZP::git \
    OMZP::sudo \
    OMZP::archlinux

# ─────────────────────────────────────────────────────────────
# COMPLETION SETUP + fzf-tab configuration
# ─────────────────────────────────────────────────────────────

# Ensure compinit is available
autoload -Uz compinit

zinit wait lucid for \
    atinit'
        # Initialize completion system (cached for speed)
        compinit -C

        # Core completion styles
        zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
        zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
        zstyle ":completion:*" menu no

        # fzf-tab preview settings
        zstyle ":fzf-tab:complete:*" fzf-preview "eza -a --color=always \$realpath"
        zstyle ":fzf-tab:complete:cd:*" fzf-preview "eza -a --color=always \$realpath"
        zstyle ":fzf-tab:complete:__zoxide_z:*" fzf-preview "eza -a --color=always \$realpath"
    ' \
    Aloxaf/fzf-tab

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

# ─────────────────────────────────────────────────────────────
# ALIASES
# ─────────────────────────────────────────────────────────────
alias vim='nvim'
alias vi='nvim'
alias c='clear'
alias grep='rg --color=auto'

alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias h="history | grep"
alias f="find . | grep"

# FZF file open
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'

# ─────────────────────────────────────────────────────────────
# SUFFIX ALIASES
# ─────────────────────────────────────────────────────────────
alias -s {conf,json,jsonc,css,sh,md,txt,lua}=nvim
alias -s {mp4,mkv,webm,mp3,flac,wav}=mpv
alias -s {png,jpg,jpeg,webp,gif}=kitty\ +kitten\ icat
alias -s pdf=zathura

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
export ABBR_SET_EXPANSION_CURSOR=1 # ── Enable zsh-abbr cursor placement

# ─────────────────────────────────────────────────────────────
# TOOLS (load late)
# ─────────────────────────────────────────────────────────────
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(thefuck --alias)"

export PATH=$PATH:/home/alexander/.spicetify
export PATH=$PATH:~/.spicetify
export QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu"
