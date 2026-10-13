# dotfiles

Configuration files for Dorab's primary machine.  Other machines take
the shared subset.

## Contents

The repository holds the primary machine's configuration.  It never
holds a password, a token or a private key.

| File in `src/` | Configures | Shared |
| --- | --- | --- |
| `.emacs.d/init.el` | Emacs | Yes |
| `.tmux.conf` | tmux | Yes |
| `.clojure/deps.edn` | Clojure CLI aliases | Yes |
| `.config/git/ignore` | Files that git ignores everywhere | Yes |
| `.config/git/shared` | git settings every machine uses | Yes |
| `.config/git/config` | git on the primary machine: identity, signing, email; includes `shared` | No |
| `.config/git/config-syntereen` | git identity for Syntereen and client repositories | No |

A file in `src/` sits at the same path as it does in the home directory.

Shared files hold no identity, so any machine can take them.  The
`Makefile` lists them in `SHARED`.  `PRIMARY` lists the shared files
and the primary machine's own files.

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
| `make diff-shared` | Like `make diff`, for the shared files only. |
| `make install-shared` | Like `make install`, for the shared files only.  `FORCE=1` works the same way. |

`DEST` sets a different home directory, for example `make install
DEST=/tmp/test`.

To keep the repository current, edit the files where they live in the
home directory.  From time to time, run `make collect`, review the
changes, and commit them.

To set up the primary machine, run `make install`.  On any other
machine or account, run `make install-shared`.  The Ansible role for
the M5 does this in each account.

## Adding a file

1. Copy the file into `src/`, at the same path as in the home directory.
2. Add that path to the `Makefile`.  If the file holds no identity and
   other machines need it, add it to `SHARED`.  Otherwise add it to
   `PRIMARY`.  Shared files reach every M5 account on the next run.

## License

This repository is in the public domain under CC0 1.0 Universal.  See
[LICENSE](LICENSE).
