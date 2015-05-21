(global-set-key (kbd "C-h") 'delete-backward-char)
;; http://akisute3.hatenablog.com/entry/20120318/1332059326
;; (keyboard-translate ?\C-h ?\C-?)

;;-------------------------------------------------
;; move cursol
;;-------------------------------------------------
;; (bind-key "C-M-h" (lambda () (interactive) (move-to-window-line 0  )))
;; (bind-key "C-M-m" (lambda () (interactive) (move-to-window-line nil)))
;; (bind-key "C-M-l" (lambda () (interactive) (move-to-window-line -1 )))
;; これで bind-key が微妙に死んでる…

;;-------------------------------------------------
;; mark(select) / copy / kill
;;-------------------------------------------------
;; 矩形選択
(cua-mode t)
(setq cua-enable-cua-keys nil)
(global-set-key (kbd "C-RET") 'cua-set-rectangle-mark)

;; M-@, M-SPC
;; http://miyazakikenji.wordpress.com/2013/06/12/emacs-%E3%81%A7%E5%8D%98%E8%AA%9E%E5%89%8A%E9%99%A4%E3%81%A8%E9%81%B8%E6%8A%9E-2/
(defun mark-word-at-point ()
  (interactive)
  (let ((char (char-to-string (char-after (point)))))
    (cond
     ((string= " " char) (delete-horizontal-space))
     ((string-match "[\t\n -@\[-`{-~]" char) (mark-word ))
     (t (forward-char) (backward-word) (mark-word 1)))))
(global-set-key (kbd "M-@") 'mark-word-at-point)
(global-set-key (kbd "M-SPC") 'mark-word-at-point)

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

;;-------------------------------------------------
;; indent
;;-------------------------------------------------
;; インデントにタブ文字を利用しない
(setq-default indent-tabs-mode nil)

;; via. http://superuser.com/questions/794579/emacs-move-cursor-back-after-mark-whole-buffer-indent-region
(defun indent-whole-buffer ()
  "Indent the whole buffer."
  (interactive)
  ;; (mark-whole-buffer)
  ;; (indent-region (region-beginning) (region-end))
  (indent-region (point-min) (point-max))
  )
(global-set-key (kbd "C-M-S-\\") 'indent-whole-buffer)
