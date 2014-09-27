;;; file名の補完で大文字小文字を区別しない
(setq completion-ignore-case t)

;; popwin
(when (require 'popwin nil t)
  (setq display-buffer-function 'popwin:display-buffer)
  (setq popwin:popup-window-position 'bottom)
  )

;; バッファを閉じるときの「クライアント保持してますよ」アラート消す
;; via. http://stackoverflow.com/questions/268088/how-to-remove-the-prompt-for-killing-emacsclient-buffers
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
(defun server-remove-kill-buffer-hook ()
  (remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function))
(add-hook 'server-visit-hook 'server-remove-kill-buffer-hook)

;; フレーム終了
;; (global-set-key (kbd "C-x C-c") 'delete-frame)

;; backup files
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
            backup-directory-alist))
(setq make-backup-files nil) ;; doesn't make backup files
;; auto-save files
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backup/") t)))
(setq auto-save-default nil)

;; Http://shibayu36.hatenablog.com/entry/2012/12/29/001418
(when (require 'recentf nil t)
  (setq recentf-max-saved-items 2000)
  (setq recentf-auto-cleanup 10)
  (setq recentf-auto-save-timer
        (run-with-idle-timer 30 t 'recentf-save-list))
  (recentf-mode 1)
  (require 'recentf-ext))

;;; 更新
(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))
(global-set-key (kbd "<f5>") 'revert-buffer-no-confirm)

;; http://stackoverflow.com/questions/384284/how-do-i-rename-an-open-file-in-emacs
(defun rename-current-buffer-and-file (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))
