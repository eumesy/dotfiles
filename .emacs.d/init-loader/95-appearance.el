;; http://d.hatena.ne.jp/meganii/20101106/1289056658
;; ウィンドウ設定(色)
;; for carbon-emacs
;; (if window-system (progn
;;   (set-background-color "Black")
;;   (set-bforeground-color "grey70")
;;   (set-cursor-color "Gray")
;; ))
;; Cocoa Emacs
;; font
;; (set-face-attribute 'default nil :family "Ricty" :height 180)
;; (set-fontset-font "fontset-default" 'ascii '("Ricty" . "iso10646-*"))
;; (set-fontset-font "fontset-default" 'japanese-jisx0208 '("Ricty" . "iso10646-*"))
;;(if window-system
;;    (setq default-frame-alist
;;          (append (list
;;                   '(width . 120)
;;                   '(height . 40)
;;                   '(background-color . "black")
;;                   )
;;                  default-frame-alist)))
;; 半透明
;;(if window-system
;;    (progn
;;      (set-frame-parameter nil 'alpha 90)))

;;; emacs -nw で起動した時にメニューバーを消す
(if window-system (menu-bar-mode 1) (menu-bar-mode -1))

;; rainbow-mode
;; #rrggbb などを色づけ
(add-hook 'emacs-lisp-mode-hook 'rainbow-mode)

;; 全角スペース タブ trailing-spacesを目立たせる
;; www.amazon.co.jp/dp/4791712595
(when (require 'whitespace nil t)
  ;; space-markとtab-mark、それからspacesとtrailingを対象とする
  (setq whitespace-style '(space-mark tab-mark face spaces trailing))
  (setq whitespace-display-mappings
        '(
          ;; (space-mark   ?\     [?\u00B7]     [?.]) ; space - centered dot
          (space-mark   ?\xA0  [?\u00A4]     [?_]) ; hard space - currency
          (space-mark   ?\x8A0 [?\x8A4]      [?_]) ; hard space - currency
          (space-mark   ?\x920 [?\x924]      [?_]) ; hard space - currency
          (space-mark   ?\xE20 [?\xE24]      [?_]) ; hard space - currency
          (space-mark   ?\xF20 [?\xF24]      [?_]) ; hard space - currency
          (space-mark ?\u3000 [?\u25a1] [?_ ?_]) ; full-width-space - square
          ;; NEWLINE is displayed using the face `whitespace-newline'
          ;; (newline-mark ?\n    [?$ ?\n])  ; eol - dollar sign
          ;; (newline-mark ?\n    [?\u21B5 ?\n] [?$ ?\n]); eol - downwards arrow
          ;; (newline-mark ?\n    [?\u00B6 ?\n] [?$ ?\n]); eol - pilcrow
          ;; (newline-mark ?\n    [?\x8AF ?\n]  [?$ ?\n]); eol - overscore
          ;; (newline-mark ?\n    [?\x8AC ?\n]  [?$ ?\n]); eol - negation
          ;; (newline-mark ?\n    [?\x8B0 ?\n]  [?$ ?\n]); eol - grade
          ;;
          ;; WARNING: the mapping below has a problem.
          ;; When a TAB occupies exactly one column, it will display the
          ;; character ?\xBB at that column followed by a TAB which goes to
          ;; the next TAB column.
          ;; If this is a problem for you, please, comment the line below.
          (tab-mark     ?\t    [?\u00BB ?\t] [?\\ ?\t]) ; tab - left quote mark
          ))
  ;; whitespace-spaceの定義を全角スペースにし、色をつけて目立たせる
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (set-face-foreground 'whitespace-space "cyan")
  (set-face-background 'whitespace-space 'nil)
  ;; whitespace-trailingを色つきアンダーラインで目立たせる
  (set-face-underline  'whitespace-trailing t)
  (set-face-foreground 'whitespace-trailing "cyan")
  (set-face-background 'whitespace-trailing 'nil)
  (global-whitespace-mode 1)
  )

;; 対応するカッコを強調表示
(show-paren-mode)

;; 現在行をハイライト
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "#100010"))
    (((class color)
      (background light))
     (:background "SeaGreen" :))
    (t
     ()))
  "Used face hl-line.")
(setq hl-line-face 'hlline-face)
(global-hl-line-mode)

;;; linum
;; (global-set-key (kbd "<f6>") 'linum-mode)
;; (setq linum-format "%4d ")
;; 軽量化
;; http://d.hatena.ne.jp/daimatz/20120215/1329248780
;; (setq linum-delay t)
;; (defadvice linum-schedule (around my-linum-schedule () activate)
;;   (run-with-idle-timer 0.2 nil #'linum-update-current))

;; theme (Emacs 24-)
;; http://d.hatena.ne.jp/aoe-tk/20130210/1360506829
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'molokai-gruber-darker t)
;; (load-theme 'dark-laptop t)

;; theme, 最後に読み込むのが良さそう
