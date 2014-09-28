(set-language-environment 'Japanese)

(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;-------------------------------------------------
;; package
;;-------------------------------------------------
(require 'cask)
(cask-initialize)

(add-to-list 'load-path "~/.emacs.d/elisp")
(when (require 'auto-install nil t)
  ;; インストール先指定
  (setq auto-install-directory "~/.emacs.d/elisp")
  ;; EmacsWiki に登録されている elisp の名前を取得
  ;; (auto-install-update-emacswiki-package-name t)
  )

;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;; (package-initialize)

;; init-loader
(custom-set-variables
 '(init-loader-show-log-after-init 'error-only))
(init-loader-load "~/.emacs.d/init-loader")

;;-------------------------------------------------
;; application
;;-------------------------------------------------
;;; emacsclient
;; ALTERNATIVE_EDITOR を渡さずに開いてしまったときのために(Emacs.appのダブルクリックとか)
(require 'server)
(unless (server-running-p) ;; 重複起動抑止
  (server-start))

;; サーバ/クライアント全終了
;; via. 「Emacsテクニックバイブル」p.91
(defalias 'exit 'save-buffers-kill-emacs)

;;-------------------------------------------------
;; helm
;;-------------------------------------------------
(when (require 'helm-config nil t)
  (helm-mode t)

  (setq helm-idle-delay 0.1)
  (setq helm-ff-auto-update-initial-value nil) ;; 自動補完無効
  ;; (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action) ;; tab補完
  ;; (define-key helm-read-file-map (kbd "<tab>") 'helm-execute-persistent-action) ;; tab補完

  (global-set-key (kbd "C-l") 'helm-for-files)
  (global-set-key (kbd "C-x b") 'helm-for-files)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "M-x") 'helm-M-x)

  ;; minibuffer
  (define-key helm-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
  ;; Emulate `kill-line' in helm minibuffer (C-k)
  ;; http://d.hatena.ne.jp/a_bicky/20140104/1388822688
  (setq helm-delete-minibuffer-contents-from-point t)
  (defadvice helm-delete-minibuffer-contents (before helm-emulate-kill-line activate)
    "Emulate `kill-line' in helm minibuffer"
    (kill-new (buffer-substring (point) (field-end))))

  ;; helm-mode で無効にするコマンド
  ;; (add-to-list 'helm-completing-read-handlers-alist '(dired-do-copy . nil))
  ;; (add-to-list 'helm-completing-read-handlers-alist '(dired-do-rename . nil))
  ;; (add-to-list 'helm-completing-read-handlers-alist '(dired-create-directory . nil))
  )

;; helm-ag
(global-set-key (kbd "C-M-s") 'helm-ag-this-file)

(global-set-key (kbd "<f8>") 'toggle-truncate-lines)

;; 自動改行
(auto-fill-mode -1)

;; テンプレート機能
(require 'autoinsert)
(setq auto-insert-directory "~/Dropbox/template/")
(setq auto-insert-alist
      (nconc '(
               ("\\.cpp$" . "temp.cpp")
               ("\\.c$" . "temp.c")
               ) auto-insert-alist))
(add-hook 'find-file-not-found-hooks 'auto-insert)

;;-------------------------------------------------
;; git
;;-------------------------------------------------
;; git-gutter
(global-git-gutter-mode t)

;; (global-unset-key "\C-t")
;; prefix for tmux

(add-hook 'after-init-hook #'global-flycheck-mode)

;;; init.el ends here
