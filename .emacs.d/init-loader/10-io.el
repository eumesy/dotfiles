;;-------------------------------------------------
;; keyboard
;;-------------------------------------------------
;; C-x @ S (0x18 0x40 0x53) event-apply-shift-modifier
;; C-x @ a (0x18 0x40 0x61) event-apply-alt-modifier
;; C-x @ c (0x18 0x40 0x63) event-apply-control-modifier
;; C-x @ h (0x18 0x40 0x68) event-apply-hyper-modifier
;; C-x @ m (0x18 0x40 0x6d) event-apply-meta-modifier
;; C-x @ s (0x18 0x40 0x73) event-apply-super-modifier
;; C-x @ C (0x18 0x40 0x43) event-apply-control-shift-modifier
(defun event-apply-control-shift-modifier (ignore-prompt)
  "\\Add the Control+Shift modifier to the following event.
For example, type \\[event-apply-control-shift-modifier] SPC to enter Control-Shift-SPC."
  (vector (event-apply-modifier
           (event-apply-modifier (read-event) 'shift 25 "S-")
           'control 26 "C-")))
(define-key function-key-map (kbd "C-x @ C") 'event-apply-control-shift-modifier)
;; C-x @ M (0x18 0x40 0x4d) event-apply-control-meta-modifier
(defun event-apply-meta-control-modifier (ignore-prompt)
  (vector (event-apply-modifier
           (event-apply-modifier (read-event) 'control 26 "C-")
           'meta 27 "M-")))
(define-key function-key-map (kbd "C-x @ M") 'event-apply-meta-control-modifier)

;; terminal sends escape sequence
;; modifier key + arrow key

;; Command <-> Option
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;;-------------------------------------------------
;; mouse
;;-------------------------------------------------
;; (xterm-mouse-mode -1)
;; tとするとマウス選択によるmacのクリップボードへのコピーがうまくいかない

;;-------------------------------------------------
;; clipboard
;;-------------------------------------------------
;; pbcopy
;; OS X の clipboard と同期
(require 'pbcopy)
(turn-on-pbcopy)
