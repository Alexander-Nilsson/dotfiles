# dotfiles

My Arch Linux dotfiles. Terminal-first, keyboard-driven setup.

## Install
```bash
git clone https://github.com/Alexander-Nilsson/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .
```

Requires [GNU Stow](https://www.gnu.org/software/stow/).

## What's included

| File/Folder | Purpose |
|---|---|
| `.zshrc` | Zsh config — zinit, fzf, zoxide, starship, abbr |
| `.config/nvim` | Neovim |
| `.config/starship.toml` | Starship prompt |
| `.bashrc` | Bash fallback config |
| `.condarc` | Conda config |
| `etc/` | Misc system configs |

## Shell tools

`zinit` · `zoxide` · `eza` · `fzf` · `starship` · `bat` · `ripgrep` · `thefuck`

## Security

Commits are automatically scanned for secrets by [Gitleaks](https://github.com/gitleaks/gitleaks) on every push.
