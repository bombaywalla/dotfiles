# Copy dotfiles between this repository and a home directory.
#
# The files are copies, not links.  Drift is found with `make diff`.
#
#   make diff            Show how the home files differ from the repository.
#   make collect         Copy the home files into the repository.  Then use
#                        `git diff` to review, and commit or discard.
#   make install         Copy the repository files into the home directory.
#                        Stops if a home file differs; FORCE=1 overwrites it.
#   make diff-shared     Like diff, for the shared files only.
#   make install-shared  Like install, for the shared files only.  Use this
#                        on a machine other than the primary one.
#
# DEST sets the home directory, for example `make install DEST=/tmp/t`.

DEST ?= $(HOME)
SRC  := src

# Paths relative to $(SRC) and $(DEST).  Add a file to SHARED or PRIMARY.

# Files any machine can take.  They hold no identity.
SHARED := \
	.zshenv \
	.zprofile \
	.zshrc \
	.emacs.d/init.el \
	.tmux.conf \
	.clojure/deps.edn \
	.config/git/ignore \
	.config/git/shared

# Files for the primary machine: the shared files and its identity.
PRIMARY := \
	$(SHARED) \
	.config/git/config \
	.config/git/config-syntereen

FILES := $(PRIMARY)

.PHONY: help diff collect install diff-shared install-shared

help:
	@sed -n 's/^#   //p' $(MAKEFILE_LIST)

diff:
	@for f in $(FILES); do \
	  if [ ! -e "$(DEST)/$$f" ]; then \
	    echo "only in repository: $$f"; \
	  elif ! cmp -s "$(SRC)/$$f" "$(DEST)/$$f"; then \
	    diff -u "$(SRC)/$$f" "$(DEST)/$$f"; \
	  fi; \
	done; true

collect:
	@for f in $(FILES); do \
	  if [ -e "$(DEST)/$$f" ]; then \
	    mkdir -p "$$(dirname "$(SRC)/$$f")" && \
	    cp -p "$(DEST)/$$f" "$(SRC)/$$f" || exit 1; \
	  else \
	    echo "not in $(DEST): $$f"; \
	  fi; \
	done
	@git status --short -- $(SRC)

install:
	@status=0; \
	for f in $(FILES); do \
	  if [ -e "$(DEST)/$$f" ] && ! cmp -s "$(SRC)/$$f" "$(DEST)/$$f" \
	     && [ "$(FORCE)" != 1 ]; then \
	    echo "differs, not copied: $$f (see make diff; FORCE=1 overwrites)"; \
	    status=1; \
	  elif ! cmp -s "$(SRC)/$$f" "$(DEST)/$$f" 2>/dev/null; then \
	    mkdir -p "$$(dirname "$(DEST)/$$f")" && \
	    cp -p "$(SRC)/$$f" "$(DEST)/$$f" && echo "copied: $$f" || exit 1; \
	  fi; \
	done; \
	exit $$status

diff-shared:
	@$(MAKE) --no-print-directory diff FILES='$(SHARED)'

install-shared:
	@$(MAKE) --no-print-directory install FILES='$(SHARED)'
