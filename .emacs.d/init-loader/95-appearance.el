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

;;; hlinum
;; 現在行の行番号をハイライト
;; git-gutter との相性がよくない
;; (require 'hlinum)
;; (hlinum-activate)
;; (custom-set-faces
;;  '(linum-highlight-face ((t (:foreground "black"
;;                              :background "red")))))

;;; highlight current line number
;; 現在行の行番号をハイライト
;; http://stackoverflow.com/questions/10591334/colorize-current-line-number
;; (require 'hl-line)
;; (defface my-linum-hl
;;   `((t :inherit linum :background ,(face-background 'hl-line nil t)))
;;   "Face for the current line number."
;;   :group 'linum)
;; (defvar my-linum-format-string "%3d")
;; (add-hook 'linum-before-numbering-hook 'my-linum-get-format-string)
;; (defun my-linum-get-format-string ()
;;   (let* ((width (1+ (length (number-to-string
;;                              (count-lines (point-min) (point-max))))))
;;          (format (concat "%" (number-to-string width) "d")))
;;     (setq my-linum-format-string format)))
;; (defvar my-linum-current-line-number 0)
;; (setq linum-format 'my-linum-format)
;; (defun my-linum-format (line-number)
;;   (propertize (format my-linum-format-string line-number) 'face
;;               (if (eq line-number my-linum-current-line-number)
;;                   'my-linum-hl
;;                 'linum)))
;; (defadvice linum-update (around my-linum-update)
;;   (let ((my-linum-current-line-number (line-number-at-pos)))
;;     ad-do-it))
;; (ad-activate 'linum-update)

;;; linum
;; (custom-set-variables
;;  '(global-linum-mode t))
;; (global-set-key (kbd "<f6>") 'linum-mode)
;; (setq linum-format "%4d ")
;; 軽量化
;; http://d.hatena.ne.jp/daimatz/20120215/1329248780
;; (setq linum-delay t)
;; (defadvice linum-schedule (around my-linum-schedule () activate)
;;   (run-with-idle-timer 0.2 nil #'linum-update-current))

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

;;; git-gutter
(global-git-gutter-mode t)
(custom-set-variables
;; '(git-gutter:window-width 1)
;; '(git-gutter:unchanged-sign " ")
 '(git-gutter:modified-sign "=")
 '(git-gutter:added-sign "+")
 '(git-gutter:deleted-sign "-")
)
;; (set-face-background 'git-gutter:unchanged "#101010")
;; (set-face-background 'git-gutter:modified "#101010")
;; (set-face-background 'git-gutter:added "#101010")
;; (set-face-background 'git-gutter:deleted "#101010")

;; (git-gutter:linum-setup)

;; theme (Emacs 24-)
;; http://d.hatena.ne.jp/aoe-tk/20130210/1360506829
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'molokai-gruber-darker t)
;; (load-theme 'dark-laptop t)

;; theme, 最後に読み込むのが良さそう
