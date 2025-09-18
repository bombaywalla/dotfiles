;; Added by Package.el.
;; This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; On initial install, do the following:
;; Note that the initial startup will complain about exec-path-from-shell-initialize
;; Ignore that.
;; M-x package-refresh-contents
;; M-x package-install-selected-packages
;; For some reason, the list of packages will not include org, so have to install manually.
;; M-x list-packages
;; Then re-search for "available *org" in the pacakge list buffer
;; Install the org package manually ("i", then "x", then "y").
;; Then restart emacs.
;; NOTE: lsp-mode benefits from LSP_USE_PLISTS env var set when compiling.

;; Periodically run (list-packages) to update packages.

;; Currently selected packages are in the var package-selected-packages

;; Load environment variables from a .env-style file
(defun load-env-file (file)
  "Read a .env file and set environment variables."
  (interactive "fEnv file: ")
  (when (file-exists-p file)
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (while (not (eobp))
        (let ((line (buffer-substring-no-properties
                     (line-beginning-position)
                     (line-end-position))))
          (when (string-match "^\\([^=]+\\)=\\(.*\\)$" line)
            (setenv (match-string 1 line) (match-string 2 line))))
        (forward-line 1)))))

;; TODO: use the dot-env package for parsing.  Copy the dot-env to the env.
;; Load .env
(load-env-file (expand-file-name "~/.env"))


;; (setq debug-on-error t)
;; (toggle-debug-on-error)

;;; use-package
;;; :init - run before loading package
;;; :config - run after loading package
;;; :bind - key bindings
;;; :commands - manual autoloads for interactive functions
;;; :autoloads - manual autoloads for non-interactive functions
;;; :defer t - load package lazily on autoloads
;;; :after foo - run this after foo is run
;;; :ensure t - make sure this pacakge is installed
;;; :disabled - do not load this package


(use-package emacs
  :init
  (put 'narrow-to-region 'disabled nil))

(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-variables
        '("ANTHROPIC_API_KEY"
          "GEMINI_API_KEY"
          "DEEPSEEK_API_KEY"
          "OPENAI_API_KEY"
          "OLLAMA_API_BASE"
          "OPENAI_API_URL"
          "ANTHROPIC_API_URL"
          "ECA_CONFIG"
          "XDG_CONFIG_HOME"
          "PATH"
          "MANPATH"))
  ;; For macOS and Linux GUI environments
  ;; TODO: Does this also work for "emacs -nw"?
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package company
  :ensure t
  :config
  (global-company-mode t))

(use-package aidermacs
  :disabled
  :bind (("C-c a" . aidermacs-transient-menu)))

(use-package gptel
  :disabled
  :commands (gptel gptel-send)
  :bind (("C-c <return>" . gptel-send))
  :config
  (defvar gptel--gemini
    (gptel-make-gemini "Gemini"
      :key #'gptel-api-key-from-auth-source
      :stream t))
  (setq-default gptel-model 'gemini-2.5-flash-preview-05-20
                gptel-backend gptel--gemini))

;; other gptel backends
(use-package gptel
  :disabled
  :after gptel
  :config
  (add-hook 'gptel-post-response-functions 'gptel-end-of-response)
  (defvar gptel--anthropic
    (gptel-make-anthropic "Claude"
      :key #'gptel-api-key-from-auth-source
      :stream t))
  (defvar gptel--anthropic-reasoning
    (gptel-make-anthropic "Claude-reasoning"
      :key #'gptel-api-key-from-auth-source
      :stream t
      ;; :models '(claude-sonnet-4-20250514 claude-3-7-sonnet-20250219)
      :request-params '(:thinking (:type "enabled" :budget_tokens 1024)
                                  :max_tokens 2048))))


(use-package mcp
  :disabled
  :after gptel
  :config
  (require 'gptel-integrations)
  )

;; Only for lsp-mode.  See if we can remove it.  See lsp-enable-snippet.
;; Also remove from selected-packages.
(use-package yasnippet
  )

(use-package lsp-mode
  :defer t
  :after (yasnippet)
  :init
  (setq lsp-keymap-prefix "C-c l")
  (setq read-process-output-max (* 1024 1024))
  :hook (clojure-mode . lsp-deferred)
  :commands (lsp lsp-deferred))

(use-package eca
  :defer t
  ;; :init
  ;; (setq eca-custom-command '("/Users/dorab/Projects/eca/eca" "server")) ; for testing
  :commands (eca eca-restart)
  )

(use-package adoc-mode
  :defer t)

;; hooks

; (add-hook 'after-init-hook 'exec-path-from-shell-initialize)

(add-hook 'text-mode-hook (lambda () (auto-fill-mode 1)))

(add-hook 'java-mode-hook (lambda ()
			    (setq c-basic-offset 2)
			    (setq c-inline-open 2)))


;; particularly helpful for ggplot formatting
(add-hook 'ess-mode-hook (lambda ()
			   (setq ess-first-continued-statement-offset 2)
			   (setq ess-continued-statement-offset 0)))

;;;;;;;;;;;;;;;;
;; use regexp versions
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\M-%" 'query-replace-regexp)

(global-set-key "\C-\\" 'compile)

;;;;;;;; org mode stuff
(require 'ob-clojure)
(require 'org-crypt)
(org-crypt-use-before-save-magic)	;encrypt on save
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
(setq org-crypt-key nil)		;use symmetric encryption

;; Fix indentation of some common macros
;;  (define-clojure-indent
;;    (for-all 1)
;;    (defroutes 'defun)
;;    (GET 2)
;;    (POST 2)
;;    (PUT 2)
;;    (DELETE 2)
;;    (HEAD 2)
;;    (ANY 2)
;;    (context 2)
;;    (reporting 1))

;;; Experimental clerk stuff
(defun clerk-show ()
  (interactive)
  (when-let
      ((filename
        (buffer-file-name)))
    (save-buffer)
    (cider-interactive-eval
     (concat "(nextjournal.clerk/show! \"" filename "\")"))))

;; (define-key clojure-mode-map (kbd "<M-return>") 'clerk-show)
;; (keymap-global-set "M-<return>" 'clerk-show)

;;; Experimental portal stuff
(defun portal.api/open ()
  (interactive)
  (cider-nrepl-sync-request:eval
   "(require 'portal.api) (portal.api/tap) (portal.api/open)"))

(defun portal.api/clear ()
  (interactive)
  (cider-nrepl-sync-request:eval "(portal.api/clear)"))

(defun portal.api/close ()
  (interactive)
  (cider-nrepl-sync-request:eval "(portal.api/close)"))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aidermacs-architect-model "deepseek/deepseek-reasoner")
 '(aidermacs-default-model "gemini/gemini-2.5-flash-preview-04-17")
 '(aidermacs-editor-model "aider-default-model")
 '(aidermacs-weak-model nil)
 '(cider-clojure-cli-aliases ":dev:test:portal")
 '(cider-invert-insert-eval-p t)
 '(cider-preferred-build-tool 'clojure-cli)
 '(cider-repl-use-content-types t)
 '(cider-switch-to-repl-on-insert nil)
 '(clojure-toplevel-inside-comment-form t)
 '(gc-cons-threshold 100000000)
 '(ido-mode t nil (ido))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(line-move-visual nil)
 '(menu-bar-mode nil)
 '(org-babel-clojure-backend 'cider)
 '(package-archive-priorities '(("gnu" . 20) ("nongnu" . 15) ("melpa" . 5)))
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("nongnu" . "https://elpa.nongnu.org/nongnu/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-pinned-packages '((nil . "") (cider . "melpa")))
 '(package-selected-packages
   '(adoc-mode aidermacs auctex cider clojure-mode company conda dot-env
               eca exec-path-from-shell go-mode gptel lsp-mode magit
               markdown-mode mcp org sql-indent terraform-mode
               yaml-mode yasnippet))
 '(safe-local-variable-values
   '((setq mcp-hub-servers
           `
           (("clj-proj" :command "/bin/sh" :args
             ,(concat "cd /Users/dorab/Projects/docq && "
                      "/opt/homebrew/bin/clojure -X:clojure-mcp"))))
     (eval progn
           (make-variable-buffer-local
            'cider-jack-in-nrepl-middlewares)
           (add-to-list 'cider-jack-in-nrepl-middlewares
                        "shadow.cljs.devtools.server.nrepl/middleware"))
     (cider-default-cljs-repl . custom)
     (cider-preferred-build-tool . clojure-cli)
     (cider-clojure-cli-aliases . "-M:dev")
     (cider-shadow-cljs-default-options . "app")
     (cider-shadow-cljs-global-options . "-A:dev")
     (cider-preferred-build-tool . shadow-cljs)
     (cider-default-cljs-repl . shadow)
     (cider-clojure-cli-global-options . "-A:dev:java9")))
 '(scroll-bar-mode nil)
 '(sql-mode-hook '(sqlind-minor-mode))
 '(tool-bar-mode nil)
 '(transient-mark-mode nil)
 '(vc-handled-backends nil)
 '(visible-bell t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
