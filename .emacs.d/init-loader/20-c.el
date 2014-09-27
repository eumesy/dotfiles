;; C mode
;; (setq auto-mode-alist (cons '("\\.tc\\'" . c-mode) auto-mode-alist))

;; http://at-aka.blogspot.com/2006/12/emacs-c.html
(add-hook
 'c-mode-common-hook
 '(lambda ()
    ;; センテンスの終了である ';' を入力したら、自動改行+インデント
    ;; (c-toggle-auto-hungry-state 1)
    ;; RET キーで自動改行+インデント
    (define-key c-mode-base-map "\C-m" 'newline-and-indent)
    ;; インデント幅
    (setq c-basic-offset 2)
    ;; タブ幅
    ;; (setq tab-width 4)
    ))

;;; gccsence
;; (require 'gccsense)
