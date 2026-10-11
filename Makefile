# Copy dotfiles between this repository and a home directory.
#
# The files are copies, not links.  Drift is found with `make diff`.
#
#   make diff      Show how the home files differ from the repository.
#   make collect   Copy the home files into the repository.  Then use
#                  `git diff` to review, and commit or discard.
#   make install   Copy the repository files into the home directory.
#                  Stops if a home file differs; FORCE=1 overwrites it.
#
# DEST sets the home directory, for example `make install DEST=/tmp/t`.

DEST ?= $(HOME)
SRC  := src

# Paths relative to $(SRC) and $(DEST).  Add a file here to manage it.
FILES := \
	.emacs.d/init.el \
	.tmux.conf \
	.clojure/deps.edn \
	.config/git/ignore \
	.config/git/shared \
	.config/git/config \
	.config/git/config-syntereen

.PHONY: help diff collect install

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
