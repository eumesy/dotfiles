;; default を触るべきではなかった感
;; 触りはじめてしまった以上仕方ない
(setq-default mode-line-format
              '(
                "("
                (line-number-mode "%l:")
                (column-number-mode "%c")
                ")"
                mode-line-mule-info
                mode-line-modified
                mode-line-frame-identification
                mode-line-buffer-identification
                " "
                global-mode-string
                " "
                mode-name
                mode-line-process
                minor-mode-alist
                "%n"
                " "
                (which-func-mode ("" which-func-format "--"))
                (-3 . "%p")
                "-%-"
                ))
(setq column-number-mode t)
(setq line-number-mode t)

;; smart-mode-line
;; https://github.com/Malabarba/smart-mode-line/
(require 'smart-mode-line)
;;; これがないと表示がはみでる
(setq sml/extra-filler -10)
;;; ファイル名 max-width
(setq sml/name-width 38)
;;; everything after the minor-modes will be right-indented
(setq sml/mode-width 'full)
;;; 表示しない mode. 手前に空白スペース要?
(setq sml/hidden-modes
      '(
        " Helm"
        ))
;;; 'Loading a theme can run Lisp code.  Really load? (y or n)' と確認を取らない
(setq sml/no-confirm-load-theme t)
(sml/setup)
(setq sml/theme 'respectfull)

(autoload 'display-time "time" "Display time on Mode-line" t)
;; -> global-mode-string
;;; format:
;;; - month day dayname
;;; - 24-hours minutes
(setq display-time-string-forms
      '((format "%s/%s(%s)%s:%s"
                month day dayname
                24-hours minutes
                )))
(display-time)
