;; plist
;; http://kouzuka.blogspot.jp/2011/02/emacs-plist.html
(add-to-list 'auto-mode-alist '("\\.plist\\'" . visit-bplist))
(add-to-list 'auto-mode-alist '("\\.nib\\'" . visit-bplist))
(add-to-list 'magic-mode-alist '("\\`bplist" . visit-bplist))
(add-to-list 'auto-coding-regexp-alist '("\\`bplist" . utf-8))
(defvar plist-converted-binary nil
  "Buffer local variable indicating if file came from binary-plist.")
(make-variable-buffer-local 'plist-converted-binary)
(defun visit-bplist ()
  (let (bplist)
    (when (string-match "\\`bplist" (buffer-string))
      (setq bplist t)
      (save-excursion
        (let (buffer-read-only)
          (message "Reading in binary plist")
          (erase-buffer)
          (let ((process-coding-system-alist '(("plutil" . utf-8))))
            (call-process "plutil" nil t nil
                          "-convert" "xml1" "-o" "-" (buffer-file-name))))))
    (xml-mode)
    (when bplist
      (set-buffer-modified-p nil)
      (setq buffer-undo-list nil)
      (setq plist-converted-binary t))))
(defadvice save-buffer (after convert-plist (&optional args))
  (when plist-converted-binary
    (shell-command
     (format "/usr/bin/plutil -convert binary1 %s"
             (shell-quote-argument (buffer-file-name))) nil nil)
    (message "Wrote bplist %s" (buffer-file-name))))
(ad-activate 'save-buffer)
