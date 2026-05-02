# load plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf
eval "$(fzf --zsh)"

# zoxide
eval "$(zoxide init zsh)"

# alias
alias ls="eza --icons"
alias ll="eza -la --icons"
alias cat="bat"
alias vim="nvim"

# enhance history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# starship
eval "$(starship init zsh)"

# dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# shortcut for obsidian note
alias n='cd ~/Notes/00_Inbox && nvim'


