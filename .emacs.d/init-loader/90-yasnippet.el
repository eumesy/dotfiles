(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"
        ;; "~/.emacs.d/elpa/yasnippet-20131021.928/snippets"
        ))
(yas-global-mode 1)

(require 'helm-c-yasnippet)
(global-set-key (kbd "C-M-;") 'helm-c-yas-complete)
