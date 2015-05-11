;; AUCTeX
(use-package LaTeX-mode
  :commands LaTeX-mode
  :mode (
         ("\\.tex\\'" . LaTeX-mode)
         ("\\.sty\\'" . LaTeX-mode)
         )
  :init
  (bind-key "M-RET" 'latex-insert-item)
  (add-hook 'LaTeX-mode-hook 'outline-minor-mode t)
  )
