# Read by interactive shells.  Shared through the dotfiles repository;
# put machine-specific or private lines in ~/.zshrc.local.

alias lf='ls -FC'
[[ -f ~/Projects/bbg/bb.edn ]] && alias bbg='bb --config ~/Projects/bbg/bb.edn'

export GPG_TTY=$(tty)

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
