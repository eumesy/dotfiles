;; org
(add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))
(setq org-src-fontify-natively t)
(setq org-export-default-language "ja")

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
(when (require 'howm nil t)
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

;; markdown-mode
;; ref. http://jblevins.org/projects/markdown-mode/
(use-package markdown-mode
  :mode (
         ("\\.md\\'" . markdown-mode)
         )
  :config
  (bind-keys :map markdown-mode-map
             ("TAB" . markdown-cycle)
             ("C-<" . markdown-promote)
             ("C->" . markdown-demote)
             ("M-RET" . markdown-insert-list-item)
             ;; ("M-{" . markdown-beginning-of-block)
             ;; ("M-}" . markdown-end-of-block)
             )
  ;; face
  ;; via. http://qiita.com/rysk-t/items/62bb0eef4d581d9eba82
  (custom-set-faces
   '(markdown-header-delimiter-face ((t (:inherit org-mode-line-clock))))
   '(markdown-header-face-1 ((t (:inherit org-level-1))))
   '(markdown-header-face-2 ((t (:inherit org-level-2))))
   '(markdown-header-face-3 ((t (:inherit org-level-3))))
   '(markdown-header-face-4 ((t (:inherit org-level-4))))
   '(markdown-header-face-5 ((t (:inherit org-level-5))))
   '(markdown-header-face-6 ((t (:inherit org-level-6))))
   )
  ;; inherit color to headers '#'
  ;; via. http://codeout.hatenablog.com/entry/2014/04/16/023011
  ;; (add-to-list 'markdown-mode-font-lock-keywords-basic
  ;;              (cons markdown-regex-header-1-atx '((1 markdown-header-face-1)
  ;;                                                  (2 markdown-header-face-1)
  ;;                                                  (3 markdown-header-face-1))))
  ;; (add-to-list 'markdown-mode-font-lock-keywords-basic
  ;;              (cons markdown-regex-header-2-atx '((1 markdown-header-face-2)
  ;;                                                  (2 markdown-header-face-2)
  ;;                                                  (3 markdown-header-face-2))))
  ;; (add-to-list 'markdown-mode-font-lock-keywords-basic
  ;;              (cons markdown-regex-header-3-atx '((1 markdown-header-face-3)
  ;;                                                  (2 markdown-header-face-3)
  ;;                                                  (3 markdown-header-face-3))))
  ;; (add-to-list 'markdown-mode-font-lock-keywords-basic
  ;;              (cons markdown-regex-header-4-atx '((1 markdown-header-face-4)
  ;;                                                  (2 markdown-header-face-4)
  ;;                                                  (3 markdown-header-face-4))))
  ;; (add-to-list 'markdown-mode-font-lock-keywords-basic
  ;;              (cons markdown-regex-header-5-atx '((1 markdown-header-face-5)
  ;;                                                  (2 markdown-header-face-5)
  ;;                                                  (3 markdown-header-face-5))))
  ;; (add-to-list 'markdown-mode-font-lock-keywords-basic
  ;;              (cons markdown-regex-header-6-atx '((1 markdown-header-face-6)
  ;;                                                  (2 markdown-header-face-6)
  ;;                                                  (3 markdown-header-face-6))))
  )
;; via. http://yasuyk.github.io/blog/2013/01/16/emacs-marked/
(defun markdown-preview-file ()
  "run Marked on the current file and revert the buffer"
  (interactive)
  (shell-command
   (format "open -a '/Applications/Marked 2.app' %s"
           (shell-quote-argument (buffer-file-name))))
  )
