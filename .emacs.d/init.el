(set-language-environment 'Japanese)

(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;-------------------------------------------------
;; package
;;-------------------------------------------------
(cond
 ((string-match "apple-darwin" system-configuration)
  (require 'cask)
  )
 ((string-match "linux" system-configuration)
  (require 'cask "~/.cask/cask.el")
  )
)
(cask-initialize)

(require 'use-package)

(add-to-list 'load-path "~/.emacs.d/elisp")
(when (require 'auto-install nil t)
  ;; インストール先指定
  (setq auto-install-directory "~/.emacs.d/elisp")
  ;; EmacsWiki に登録されている elisp の名前を取得
  ;; (auto-install-update-emacswiki-package-name t)
  )



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
  (global-set-key (kbd "C-M-o") 'helm-occur)

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

;; (global-unset-key "\C-t")
;; prefix for tmux

;;; flycheck
(add-hook 'c-mode 'flycheck-mode)

;;; hs-minor-mode
(global-set-key (kbd "C-\\") 'hs-toggle-hiding)

;;; outline-minor-mode
;; ref. http://qiita.com/kawabata@github/items/9a1a1e211c57a56578d8
;; alternative: outline-magic http://www.emacswiki.org/emacs/OutlineMagic
(with-eval-after-load 'outline
  (bind-key "<tab>" 'org-cycle outline-minor-mode-map)
  (bind-key "TAB"   'org-cycle outline-minor-mode-map)
  (bind-key "C-TAB"   'org-global-cycle outline-minor-mode-map)
  (bind-key "C-<tab>" 'org-global-cycle outline-minor-mode-map)
  (bind-key "C-c C-f" 'outline-forward-same-level outline-minor-mode-map)
  (bind-key "C-c C-b" 'outline-backward-same-level outline-minor-mode-map)
  (bind-key "C-c C-n" 'outline-next-visible-heading outline-minor-mode-map)
  (bind-key "C-c C-p" 'outline-previous-visible-heading outline-minor-mode-map)
  (bind-key "<tab>" 'org-cycle outline-mode-map)
  (bind-key "TAB"   'org-cycle outline-mode-map)
  (bind-key "S-TAB"   'org-global-cycle outline-mode-map)
  (bind-key "S-<tab>" 'org-global-cycle outline-mode-map))



;; init-loader
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-safe-themes
   (quote
    ("967b1948874c82a0d33c0a4be18c7a9f03715dc0af5194751407df72c25f93fe" "400994f0731b2109b519af2f2d1f022e7ced630a78890543526b9342a3b04cf1" default)))
 '(git-gutter:added-sign "+")
 '(git-gutter:deleted-sign "-")
 '(git-gutter:modified-sign "=")
 '(google-translate-default-source-language "en")
 '(google-translate-default-target-language "ja")
 '(init-loader-show-log-after-init (quote error-only)))
(init-loader-load "~/.emacs.d/init-loader")

;;; init.el ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
