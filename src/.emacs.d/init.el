;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Periodically run (list-packages) to update.
;; (package-install-selected-packages) to do initial install.
;; Currently selected packages are in the var package-selected-packages

(defun dorab-after-init-hook ()
  ;; do stuff after package initialization
  (exec-path-from-shell-initialize)
  )
(add-hook 'after-init-hook 'dorab-after-init-hook)

;; for Infobright
(defun sql-mysqlib ()
  (interactive)
  (let ((sql-mysql-program "mysql") ;; or mysql-ib if infobright installed
	(sql-port 3307))
    (call-interactively 'sql-mysql)))
;; for MySQL
(setq sql-port 3306)
(setq sql-mysql-program "mysql")

(put 'narrow-to-region 'disabled nil)

;; Not sure I now want this in all text mode buffers.
; (add-hook 'text-mode-hook (lambda () (auto-fill-mode 1)))

(add-hook 'java-mode-hook (lambda ()
			    (setq c-basic-offset 2)
			    (setq c-inline-open 2)))

;; particularly helpful for ggplot formatting
(add-hook 'ess-mode-hook (lambda ()
			   (setq ess-first-continued-statement-offset 2)
			   (setq ess-continued-statement-offset 0)))

;; Remove after I send in the patch for git.el
(load "~/.emacs.d/git.el")

;;;;;;;;;;;;;;;;
;; use regexp versions
(global-set-key "\C-s" 'isearch-forward-regexp)
(global-set-key "\C-r" 'isearch-backward-regexp)
(global-set-key "\M-%" 'query-replace-regexp)

(global-set-key "\C-\\" 'compile)

;;;;;;;; org mode stuff
(require 'org-crypt)
(org-crypt-use-before-save-magic)	;encrypt on save
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
(setq org-crypt-key nil)		;use symmetric encryption

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ido-mode t nil (ido))
 '(inhibit-startup-screen t)
 '(line-move-visual nil)
 '(menu-bar-mode nil)
 '(org-log-done (quote time))
 '(package-archives
   (quote
    (("melpa-stable" . "http://stable.melpa.org/packages/")
     ("gnu" . "http://elpa.gnu.org/packages/")
     ("org" . "http://orgmode.org/elpa/"))))
 '(package-pinned-packages (quote ((org . "org"))))
 '(package-selected-packages
   (quote
    (markdown-mode
     terraform-mode
     yaml-mode
     org
     exec-path-from-shell
     cider)))
 '(scroll-bar-mode nil)
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
