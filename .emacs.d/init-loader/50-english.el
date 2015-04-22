;; aspell
;;; ispellをaspellに置き換え
(setq-default ispell-program-name "aspell")
;;; 日本語まじりでも使えるようにする
(eval-after-load "ispell"
  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))
;;; FlySpell: http://www.emacswiki.org/emacs/FlySpell
;;;; flyspell in other modes: http://www.emacswiki.org/emacs/FlySpell#toc1
(dolist (hook '(latex-mode-hook text-mode-hook org-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

;; google translate
;; http://qiita.com/catatsuy/items/ae9875706769d4f02317
(global-set-key "\C-ct" 'google-translate-at-point)
(global-set-key "\C-xT" 'google-translate-query-translate)
;; 翻訳のデフォルト値を設定 (無効化は C-u を付与 e.g. C-u C-x t)
(custom-set-variables
 '(google-translate-default-source-language "en")
 '(google-translate-default-target-language "ja"))
