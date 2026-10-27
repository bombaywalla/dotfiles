# Read by every zsh: login or not, interactive or not, including scripts
# and `ssh host <command>`.  Keep it small and fast.  Shared through the
# dotfiles repository; put machine-specific or private lines in
# ~/.zshenv.local.

# Keep PATH free of duplicates.  The attribute applies to every later
# change to path, in this file and in the files zsh reads after it.
typeset -U path

# Homebrew first.  macOS's /etc/paths.d puts it last.  In a login shell,
# /etc/zprofile reorders PATH again, so ~/.zprofile repeats this.
[[ -d /opt/homebrew/bin ]] && path=(/opt/homebrew/bin /opt/homebrew/sbin $path)

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
