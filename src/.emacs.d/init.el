;; Added by Package.el.  This must come before configurations of
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

;; Periodically run (list-packages) to update packages.

;; Currently selected packages are in the var package-selected-packages


(put 'narrow-to-region 'disabled nil)

(add-to-list 'auto-mode-alist (cons "\\.adoc\\'" 'adoc-mode))

(add-hook 'after-init-hook 'exec-path-from-shell-initialize)

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cider-clojure-cli-global-options "-A:dev:test")
 '(cider-invert-insert-eval-p t)
 '(cider-repl-use-content-types t)
 '(cider-switch-to-repl-on-insert nil)
 '(ido-mode t nil (ido))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(line-move-visual nil)
 '(menu-bar-mode nil)
 '(package-archives
   '(("melpa-stable" . "http://stable.melpa.org/packages/")
     ("gnu" . "http://elpa.gnu.org/packages/")
     ("org" . "http://orgmode.org/elpa/")))
 '(package-pinned-packages '((org . "org") (cider . "melpa-stable")))
 '(package-selected-packages
   '(adoc-mode cider exec-path-from-shell lsp-mode magit markdown-mode org sql-indent terraform-mode yaml-mode))
 '(safe-local-variable-values
   '((cider-shadow-cljs-global-options . "-A:dev")
     (cider-shadow-global-options . "-A:dev:java9")
     (cider-preferred-build-tool . shadow-cljs)
     (cider-shadow-default-options . ":app")
     (cider-default-cljs-repl . shadow)
     (cider-shadow-global-options . "-A:dev")
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
