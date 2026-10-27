# Read by login shells, after /etc/zprofile.  Shared through the
# dotfiles repository; put machine-specific or private lines in
# ~/.zprofile.local.  Each line checks that its target exists, so the
# file works on any machine.

# /etc/zprofile runs path_helper, which puts the system directories
# before Homebrew.  Put Homebrew first again, with its other settings.
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Earlier lines end up later in PATH.  The resulting order is
# ~/.local/bin, libpq, Homebrew Python, Homebrew.
# Unversioned python and pip from Homebrew Python.
[[ -d /opt/homebrew/opt/python/libexec/bin ]] && path=(/opt/homebrew/opt/python/libexec/bin $path)
# psql, without the full PostgreSQL server.
[[ -d /opt/homebrew/opt/libpq/bin ]] && path=(/opt/homebrew/opt/libpq/bin $path)
# Per-user tools, for example from bbin, uv tool or pipx.
[[ -d ~/.local/bin ]] && path=(~/.local/bin $path)

# Homebrew's dotnet is not in Microsoft's location.  Programs that
# dotnet build makes, and dotnet global tools, need this to find it.
[[ -d /opt/homebrew/opt/dotnet/libexec ]] && export DOTNET_ROOT=/opt/homebrew/opt/dotnet/libexec

[[ -f ~/.zprofile.local ]] && source ~/.zprofile.local
