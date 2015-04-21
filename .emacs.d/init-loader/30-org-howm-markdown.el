;; org
(add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))
(setq org-src-fontify-natively t)
(setq org-export-default-language "ja")

;;; org-latex

;; howm
(add-to-list 'load-path "~/.emacs.d/elisp/howm")
(setq howm-directory "~/Dropbox/howm/")
(setq howm-menu-lang 'ja)
;; org-mode 併用
(setq howm-view-title-header "*") ;; howm のロードより前に書くこと
(setq howm-file-name-format "%Y/%m/%Y-%m-%d.org") ;; 1日1ファイル
(setq howm-template-date-format "[%Y-%m-%d %H:%M]")
(setq howm-template "* %title%cursor\n\n%date\n")
(setq howm-prefix "\C-x,") ;; org-mode との衝突回避
;;
(when (require 'howm-mode nil t)
  (define-key global-map (kbd "C-x , ,") 'howm-menu) ;; org-mode との衝突回避
  )
(add-hook 'howm-after-save-hook
          (function (lambda ()
                      ;; 内容が空の場合はファイルを削除する。
                      (if (= (point-min) (point-max))
                          (delete-file (buffer-file-name (current-buffer)))))))
;; ~/Dropbox/howm の下で org-mode で編集する場合は howm-mode を追加
;; http://d.hatena.ne.jp/TakashiHattori/20120627/1340768058
(add-hook 'org-mode-hook
          (function (lambda ()
                      (if (string-match "Dropbox/howm" buffer-file-name)
                          (howm-mode)))))

;;; Markdown
;; http://jblevins.org/projects/markdown-mode/
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))

;; via. http://yasuyk.github.io/blog/2013/01/16/emacs-marked/
(defun markdown-preview-file ()
  "run Marked on the current file and revert the buffer"
  (interactive)
  (shell-command
   (format "open -a '/Applications/Marked 2.app' %s"
           (shell-quote-argument (buffer-file-name))))
  )
