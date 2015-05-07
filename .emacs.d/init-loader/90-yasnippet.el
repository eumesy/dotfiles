(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"
        ;; "~/.emacs.d/elpa/yasnippet-20131021.928/snippets"
        ))

(yas-global-mode 1)

;; keybind
;; ref. http://stackoverflow.com/questions/14066526/unset-tab-binding-for-yasnippet
;; remove
(define-key yas-minor-mode-map [(tab)]       nil)
(define-key yas-minor-mode-map (kbd "TAB")   nil)
(define-key yas-minor-mode-map (kbd "<tab>") nil)
;; define
(define-key yas-minor-mode-map (kbd "C-M-i") 'yas-expand)

(require 'helm-c-yasnippet)
(global-set-key (kbd "C-M-;") 'helm-c-yas-complete)
