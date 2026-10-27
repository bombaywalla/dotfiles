;;; Emacs config  -*- lexical-binding: t -*-
;;; Until emacs-app updates their libgccjit
(require 'comp)
(setq native-comp-driver-options (cons "-mmacosx-version-min=11" native-comp-driver-options))
;;; Alternative work-around (setenv "MACOSX_DEPLOYMENT_TARGET" "27.0")
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

;;; Functions for running lazytest tests

;; NOTE: This function will run the test when point is anywhere inside a test.
;; BUT, cider--extract-test-var-at-point does not work with Lazytest tests.
;; TODO: Fix this.
;; (defun lazy-tests-run-var ()
;;   (interactive)
;;   (let* ((current-ns (cider-current-ns))
;;          (var (cider--extract-test-var-at-point))
;;          (var-ns (first var))
;;          (var-name (second var)))
;;     (cider-interactive-eval (format "(lazytest.repl/run-test-var #'%s/%s)" var-ns var-name)
;;                             nil
;;                             nil
;;                             `(("ns" ,current-ns)))))


(defun lazy-tests-run-var ()
  (interactive)
  (let* ((current-ns (cider-current-ns))
         (var (cider-last-sexp)))
    (cider-interactive-eval (format "(lazytest.repl/run-test-var #'%s)" var)
                            nil
                            nil
                            `("ns" ,current-ns))))

(defun lazy-tests-run-ns ()
  (interactive)
  (let* ((current-ns (cider-current-ns)))
    (cider-interactive-eval (format "(lazytest.repl/run-tests '%s)" current-ns)
                            nil
                            nil
                            `("ns" ,current-ns))))

(defun lazy-tests-run-all ()
  (interactive)
  (let* ((current-ns (cider-current-ns)))
    (cider-interactive-eval "(lazytest.repl/run-all-tests)"
                            nil
                            nil
                            `("ns" ,current-ns))))

;;; General settings

;; (setq debug-on-error t)
;; (toggle-debug-on-error)

;;; use-package

;;; DO NOT USE :ensure, since this causes the latest to be installed always, which might conflict.
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
          "GOOGLE_API_KEY"
          "GEMINI_API_KEY"
          "DEEPSEEK_API_KEY"
          "OPENAI_API_KEY"
          "OMLX_API_KEY"
          "GITLAB_HOST"
          "GITLAB_TOKEN"
          "OLLAMA_API_BASE"
          "OPENAI_API_URL"
          "ANTHROPIC_API_URL"
          "ECA_CONFIG"
          "XDG_CONFIG_HOME"
          "PATH"
          "MANPATH"
          "DOTNET_ROOT"))
  ;; For macOS and Linux GUI environments
  ;; TODO: Does this also work for "emacs -nw"?
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; For gitignore mode
(use-package git-modes
  :ensure t)

(use-package cider
  :bind (("C-c C-t C-t" . lazy-tests-run-var )
         ("C-c C-t C-n" . lazy-tests-run-ns ))
  )

(use-package company
  :ensure t
  :config
  (global-company-mode t))

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
  ;; (setq eca-custom-command '("/Users/dorab/Projects/eca/eca" "server"))
  ;; (setq eca-extra-args '("--log-level" "debug"))
  :commands (eca eca-restart)
  )

(use-package adoc-mode
  :defer t)

;; hooks

; supposedly to have cider use the LSP completion at point.
; (add-hook 'cider-mode-hook (lambda () (remove-hook 'completion-at-point-functions #'cider-complete-at-point))))


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
(setq org-duration-format 'h:mm)

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
 '(cider-enable-nrepl-jvmti-agent t)
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
     ("melpa-stable" . "https://stable.melpa.org/packages/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-pinned-packages '((nil . "") (cider . "melpa")))
 '(package-selected-packages
   '(adoc-mode auctex cider clojure-mode company conda dot-env eca
               exec-path-from-shell git-modes go-mode lsp-mode magit
               markdown-mode org sql-indent terraform-mode yaml-mode
               yasnippet))
 '(safe-local-variable-values
   '((cider-default-cljs-repl . custom)
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

;;; Settings for this machine only.  Not in the dotfiles repository.
(load (expand-file-name "local.el" user-emacs-directory) t)
