(require 'auto-complete-config)
(global-auto-complete-mode 1)
(ac-config-default)
(setq ac-auto-start 2)
(setq ac-use-menu-map t)
(define-key ac-menu-map (kbd "C-n") 'ac-next)
(define-key ac-menu-map (kbd "C-p") 'ac-previous)
(ac-set-trigger-key "TAB")

;; Enable auto-complete mode other than default enable modes
;; https://github.com/syohex/dot_files/blob/master/emacs/init_loader/08_auto-complete.el
(dolist (mode '(git-commit-mode
                latex-mode
                LaTeX-mode
                markdown-mode
                org-mode))
  (add-to-list 'ac-modes mode))
