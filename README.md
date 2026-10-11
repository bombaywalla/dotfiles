# dotfiles

Configuration files for Dorab's primary machine.  Other machines take a
subset.

## Contents

The repository holds the primary machine's configuration.  It never
holds a password, a token or a private key.

| File in `src/` | Configures |
| --- | --- |
| `.emacs.d/init.el` | Emacs |
| `.tmux.conf` | tmux |
| `.clojure/deps.edn` | Clojure CLI aliases |
| `.config/git/ignore` | Files that git ignores everywhere |
| `.config/git/shared` | git settings every machine uses |
| `.config/git/config` | git on this machine: identity, signing, email; includes `shared` |
| `.config/git/config-syntereen` | git identity for Syntereen and client repositories |

A file in `src/` sits at the same path as it does in the home directory.

## Requirements

- macOS, with `make`.

## Usage

The files are copies, not links.  `make diff` shows where a home
directory has drifted from the repository.

| Target | Action |
| --- | --- |
| `make` or `make help` | Print the targets. |
| `make diff` | Show how each home file differs from the repository.  Changes nothing. |
| `make collect` | Copy the home files into `src/`, then print `git status`.  Review with `git diff`, then commit or discard. |
| `make install` | Copy `src/` into the home directory.  It stops if a home file differs from the repository. |
| `make install FORCE=1` | Copy `src/` into the home directory, and overwrite home files that differ. |

`DEST` sets a different home directory, for example `make install
DEST=/tmp/test`.

To keep the repository current, edit the files where they live in the
home directory.  From time to time, run `make collect`, review the
changes, and commit them.

To set up a new machine, run `make install`.

## Adding a file

1. Copy the file into `src/`, at the same path as in the home directory.
2. Add that path to `FILES` in the `Makefile`.
3. Decide whether the M5's accounts also need the file.  The M5 gets
   only the files listed in `dotfiles_files`, in the `dotfiles` role of
   the `mac-config` repository.  If the M5 needs it, add it there.

## License

This repository is in the public domain under CC0 1.0 Universal.  See
[LICENSE](LICENSE).
