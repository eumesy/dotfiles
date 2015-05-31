;; AUCTeX
(use-package LaTeX-mode
  :commands LaTeX-mode
  :mode (
         ("\\.tex\\'" . LaTeX-mode)
         ("\\.sty\\'" . LaTeX-mode)
         )
  :config
  (bind-keys :map LaTeX-mode-map
             ("M-RET" . 'latex-insert-item)
             )
  :init
  (add-hook 'LaTeX-mode-hook 'outline-minor-mode t)
  )
)
