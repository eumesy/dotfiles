;; verilog mode
;;; http://linuxcom.info/verilog-mode.html
;;; Load verilog-mode only when needed
;; (autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
;; Any files that end in .v should be in verilog mode
;; (setq auto-mode-alist (cons '("\\.v\\'" . verilog-mode) auto-mode-alist))
;; (setq auto-mode-alist (cons '("\\.vt\\'" . verilog-mode) auto-mode-alist))
;;; Any files in verilog mode shuold have their keywords colorized
;; (add-hook 'verilog-mode-hook '(lambda () (font-look-mode 1)))
;; (add-to-list 'ac-modes 'verilog-mode)

