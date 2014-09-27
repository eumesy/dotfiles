;; インデントにタブ文字を利用しない
(setq-default indent-tabs-mode nil)

(global-set-key (kbd "C-h") 'delete-backward-char)
;; http://akisute3.hatenablog.com/entry/20120318/1332059326
;; (keyboard-translate ?\C-h ?\C-?)

;;-------------------------------------------------
;; move cursol
;;-------------------------------------------------
(global-set-key (kbd "C-M-h") (lambda () (interactive) (move-to-window-line 0)))
(global-set-key (kbd "C-M-m") (lambda () (interactive) (move-to-window-line nil)))
(global-set-key (kbd "C-M-l") (lambda () (interactive) (move-to-window-line -1)))

;;-------------------------------------------------
;; select
;;-------------------------------------------------
;; 矩形選択
(cua-mode t)
(setq cua-enable-cua-keys nil)
(global-set-key (kbd "C-RET") 'cua-set-rectangle-mark)

;;-------------------------------------------------
;; copy / kill
;;-------------------------------------------------
;; M-d
(defun kill-word-at-point ()
  (interactive)
  (let ((char (char-to-string (char-after (point)))))
    (cond
     ((string= " " char) (delete-horizontal-space))
     ((string-match "[\t\n -@\[-`{-~]" char) (kill-word 1))
     (t (forward-char) (backward-word) (kill-word 1)))))
(global-set-key "\M-d" 'kill-word-at-point)

;; C-w
(defun kill-region-or-backward-kill-word (beg end)
  (interactive (list (point) (mark t)))
  (if (and (interactive-p) transient-mark-mode (not mark-active))
      (backward-kill-word 1)
    (kill-region beg end)))
(global-set-key (kbd "C-w") 'kill-region-or-backward-kill-word)
;; via. http://qiita.com/t_shuuhei/items/7e51af7cd5eb21d6cc84
;; minibuffer
(define-key minibuffer-local-completion-map (kbd "C-w") 'backward-kill-word)
;; via. http://dev.ariel-networks.com/wp/documents/aritcles/emacs/part16

;; M-w
(defun kill-ring-save-or-kill-current-buffer (beg end)
  (interactive (list (point) (mark t)))
  (if (and (interactive-p) transient-mark-mode (not mark-active))
      (kill-buffer (current-buffer))
    (kill-ring-save beg end)))
(global-set-key (kbd "M-w") 'kill-ring-save-or-kill-current-buffer)

;; C-k
(setq kill-whole-line t) ;; 行頭にいる場合、C-kで行全体(改行含む)を削除

;; M-k, M-K
;; http://akisute3.hatenablog.com/entry/20120412/1334237294
(defun copy-whole-line (&optional arg)
  "Copy current line."
  (interactive "p")
  (or arg (setq arg 1))
  (if (and (> arg 0) (eobp) (save-excursion (forward-visible-line 0) (eobp)))
      (signal 'end-of-buffer nil))
  (if (and (< arg 0) (bobp) (save-excursion (end-of-visible-line) (bobp)))
      (signal 'beginning-of-buffer nil))
  (unless (eq last-command 'copy-region-as-kill)
    (kill-new "")
    (setq last-command 'copy-region-as-kill))
  (cond ((zerop arg)
         (save-excursion
           (copy-region-as-kill (point) (progn (forward-visible-line 0) (point)))
           (copy-region-as-kill (point) (progn (end-of-visible-line) (point)))))
        ((< arg 0)
         (save-excursion
           (copy-region-as-kill (point) (progn (end-of-visible-line) (point)))
           (copy-region-as-kill (point)
                                (progn (forward-visible-line (1+ arg))
                                       (unless (bobp) (backward-char))
                                       (point)))))
        (t
         (save-excursion
           (copy-region-as-kill (point) (progn (forward-visible-line 0) (point)))
           (copy-region-as-kill (point)
                                (progn (forward-visible-line arg) (point))))))
  (message (substring (car kill-ring-yank-pointer) 0 -1)))
(global-set-key (kbd "M-K") 'copy-whole-line)
(global-set-key (kbd "M-k") 'kill-whole-line)
