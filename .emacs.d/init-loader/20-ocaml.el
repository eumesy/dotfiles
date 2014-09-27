;; OCaml
;;; Tuareg-mode
;;; via. http://tuareg.forge.ocamlcore.org/ -> Released Files
(setq load-path (append '("~/.emacs.d/elisp/tuareg-2.0.6") load-path))
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)
;; (setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(setq auto-mode-alist
      (append '(("\\.ml[ily]?$" . tuareg-mode)
                ("\\.topml$" . tuareg-mode))
              auto-mode-alist))
(modify-coding-system-alist 'file "\\.ml\\w?" 'euc-jp-unix)
