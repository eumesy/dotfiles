;; tabbar.el
;; (require 'tabbar)
(tabbar-mode 1)
(global-set-key (kbd "C-t") 'tabbar-forward)
(global-set-key (kbd "C-S-t") 'tabbar-backward)
(defun my-tabbar-buffer-list ()
  (delq nil
        (mapcar #'(lambda (b)
                    (cond
                     ((eq (current-buffer) b) b) ; Always include the current buffer.
                     ((buffer-file-name b) b)
                     ((char-equal ?\  (aref (buffer-name b) 0)) nil)
                     ((equal "*scratch*" (buffer-name b)) b)
                     ((equal "*ocaml-toplevel*" (buffer-name b)) b)
                     ((char-equal ?* (aref (buffer-name b) 0)) nil) ; それ以外の * で始まるバッファは表示しない
                     ((char-equal ?\  (aref (buffer-name b) 0)) nil)
                     ((buffer-live-p b) b)))
                (buffer-list))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)
;; グループ化しない
(setq tabbar-buffer-groups-function nil)
;; tab-distance
(setq tabbar-separator '(1.5))
;; kill buttons
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))
(set-face-attribute 'tabbar-default nil    :background "black" :foreground "gray72" :height 1.0)
(set-face-attribute 'tabbar-unselected nil :background "black" :foreground "grey72" :box t)
(set-face-attribute 'tabbar-selected nil   :background "black" :foreground "red" :box t)
(set-face-attribute 'tabbar-button nil     :box nil)
(set-face-attribute 'tabbar-separator nil  :height 1.2)
