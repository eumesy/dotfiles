;; dired
;; RET 標準の dired-find-file では dired バッファが複数作られるので
;; dired-find-alternate-file を代わりに使う
(put 'dired-find-alternate-file 'disabled nil)
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
(define-key dired-mode-map (kbd "a") 'dired-find-file)

(transient-mark-mode t)

(global-set-key (kbd "C-o") 'find-file)     ;; default: C-x C-f
(global-set-key (kbd "M-s") 'save-buffer)   ;; default: C-x C-s
(global-set-key (kbd "M-t") 'other-window)  ;; default: C-x o
(global-set-key (kbd "M-g") 'goto-line)     ;; default: M-g g
