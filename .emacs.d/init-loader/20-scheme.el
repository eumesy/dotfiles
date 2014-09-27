;;   jakld
(setq scheme-program-name "java -Xss1m -jar /Users/sho/Dropbox/java/Scheme/jakld.jar")

;;   Gauche
;; 対話モード
;; (setq scheme-program-name "gosh -i")
;; (setq process-coding-system-alist
;;       (cons '("gosh" utf-8 . utf-8) process-coding-system-alist))

;; schemeモードとrun-schemeモードにcmuscheme.elを使用
;;(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
;;(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process." t)
;;直前/直後の括弧に対応する括弧を光らせます。
