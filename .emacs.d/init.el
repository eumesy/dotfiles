(set-language-environment 'Japanese)

(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

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

;;-------------------------------------------------
;; mouse
;;-------------------------------------------------
;; (xterm-mouse-mode -1)
;; tとするとマウス選択によるmacのクリップボードへのコピーがうまくいかない

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
  (auto-install-update-emacswiki-package-name t))

;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;; (package-initialize)

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

;; Http://shibayu36.hatenablog.com/entry/2012/12/29/001418
(when (require 'recentf nil t)
  (setq recentf-max-saved-items 2000)
  (setq recentf-auto-cleanup 10)
  (setq recentf-auto-save-timer
        (run-with-idle-timer 30 t 'recentf-save-list))
  (recentf-mode 1)
  (require 'recentf-ext))

(require 'helm-c-yasnippet)
(global-set-key (kbd "C-M-;") 'helm-c-yas-complete)

(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"
        ;; "~/.emacs.d/elpa/yasnippet-20131021.928/snippets"
        ))
(yas-global-mode 1)

;; 自動改行
(auto-fill-mode -1)

;; popwin
(when (require 'popwin nil t)
  (setq display-buffer-function 'popwin:display-buffer)
  (setq popwin:popup-window-position 'bottom)
  )

(require 'auto-complete-config)
(global-auto-complete-mode 1)
(ac-config-default)
(setq ac-auto-start 2)
(setq ac-use-menu-map t)
(define-key ac-menu-map (kbd "C-n") 'ac-next)
(define-key ac-menu-map (kbd "C-p") 'ac-previous)
(ac-set-trigger-key "TAB")

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

;; 時刻表示
(display-time-mode 1)

;; tabbar.el
;; (require 'tabbar)
(tabbar-mode 1)
(global-set-key (kbd "C-t") 'tabbar-forward)
(global-set-key (kbd "C-S-t") 'tabbar-backward)
(defun my-tabbar-buffer-list ()
  (delq nil
        (mapcar #'(lambda (b)
                    (cond
                     ((eq (current-buffer) b) b) ; Always include the current buffer.
                     ((buffer-file-name b) b)
                     ((char-equal ?\  (aref (buffer-name b) 0)) nil)
		     ((equal "*scratch*" (buffer-name b)) b)
		     ((equal "*ocaml-toplevel*" (buffer-name b)) b)
		     ((char-equal ?* (aref (buffer-name b) 0)) nil) ; それ以外の * で始まるバッファは表示しない
                     ((char-equal ?\  (aref (buffer-name b) 0)) nil)
                     ((buffer-live-p b) b)))
                (buffer-list))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)
;; グループ化しない
(setq tabbar-buffer-groups-function nil)
;; tab-distance
(setq tabbar-separator '(1.5))
;; kill buttons
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))
(set-face-attribute 'tabbar-default nil    :background "black" :foreground "gray72" :height 1.0)
(set-face-attribute 'tabbar-unselected nil :background "black" :foreground "grey72" :box t)
(set-face-attribute 'tabbar-selected nil   :background "black" :foreground "red" :box t)
(set-face-attribute 'tabbar-button nil     :box nil)
(set-face-attribute 'tabbar-separator nil  :height 1.2)

;; dired
;; RET 標準の dired-find-file では dired バッファが複数作られるので
;; dired-find-alternate-file を代わりに使う
(put 'dired-find-alternate-file 'disabled nil)
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
(define-key dired-mode-map (kbd "a") 'dired-find-file)


;; theme
;; Emacs 24
;; http://d.hatena.ne.jp/aoe-tk/20130210/1360506829
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'molokai-gruber-darker t)

;; (load-theme 'molokai t)
;; (load-theme 'gruber-darker t)  ;; helm周りよい
;; (load-theme 'monokai t)
;; (load-theme 'solarized-dark t)
;; (load-theme 'solarized-light t)
;; (load-theme 'dark-laptop t)

;; http://d.hatena.ne.jp/meganii/20101106/1289056658
;; ウィンドウ設定(色)
;; for carbon-emacs
;; (if window-system (progn
;;   (set-background-color "Black")
;;   (set-bforeground-color "grey70")
;;   (set-cursor-color "Gray")
;; ))

(transient-mark-mode t)


;; Cocoa Emacs
;; font
;; (set-face-attribute 'default nil :family "Ricty" :height 180)
;; (set-fontset-font "fontset-default" 'ascii '("Ricty" . "iso10646-*"))
;; (set-fontset-font "fontset-default" 'japanese-jisx0208 '("Ricty" . "iso10646-*"))

;; Command <-> Option
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

(if window-system 
    (setq default-frame-alist
	  (append (list
		   '(width . 120)
		   '(height . 40)
		   '(background-color . "black")
		   )
		  default-frame-alist)))
;; 半透明
(if window-system 
    (progn
      (set-frame-parameter nil 'alpha 90)))
(tool-bar-mode -1)
(menu-bar-mode -1)

(global-set-key (kbd "C-o") 'find-file)     ;; default: C-x C-f
(global-set-key (kbd "M-s") 'save-buffer)   ;; default: C-x C-s
(global-set-key (kbd "M-t") 'other-window)  ;; default: C-x o
(global-set-key (kbd "M-g") 'goto-line)     ;; default: M-g g

;;-------------------------------------------------
;; edit
;;-------------------------------------------------
(global-set-key (kbd "C-h") 'delete-backward-char)
;; http://akisute3.hatenablog.com/entry/20120318/1332059326
;; (keyboard-translate ?\C-h ?\C-?) 

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

;; (global-unset-key "\C-t")
;; prefix for tmux

(global-set-key (kbd "C-M-h") (lambda () (interactive) (move-to-window-line 0)))
(global-set-key (kbd "C-M-m") (lambda () (interactive) (move-to-window-line nil)))
(global-set-key (kbd "C-M-l") (lambda () (interactive) (move-to-window-line -1)))


;; 矩形選択
(cua-mode t)
(setq cua-enable-cua-keys nil)
(global-set-key (kbd "C-RET") 'cua-set-rectangle-mark)

;;; 更新
(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation."
  (interactive) (revert-buffer t t))
(global-set-key (kbd "<f5>") 'revert-buffer-no-confirm)

;;; linum
;; (global-set-key (kbd "<f6>") 'linum-mode)
;; (setq linum-format "%4d ")
;; 軽量化
;; http://d.hatena.ne.jp/daimatz/20120215/1329248780
;; (setq linum-delay t)
;; (defadvice linum-schedule (around my-linum-schedule () activate)
;;   (run-with-idle-timer 0.2 nil #'linum-update-current))

(global-set-key (kbd "<f8>") 'toggle-truncate-lines)


;; display column number on mode line
(column-number-mode t)


;;; file名の補完で大文字小文字を区別しない
(setq completion-ignore-case t)


;; テンプレート機能
(require 'autoinsert)
(setq auto-insert-directory "~/Dropbox/template/")
(setq auto-insert-alist
      (nconc '(
	       ("\\.cpp$" . "temp.cpp")
	       ("\\.c$" . "temp.c")
	       ) auto-insert-alist))
(add-hook 'find-file-not-found-hooks 'auto-insert)


;;; gccsence
;; (require 'gccsense)

;;; Scheme
;;   jakld
(setq scheme-program-name "java -Xss1m -jar /Users/sho/Dropbox/java/Scheme/jakld.jar")

;;   Gauche
;; 対話モード
;; (setq scheme-program-name "gosh -i")
;; (setq process-coding-system-alist
;;       (cons '("gosh" utf-8 . utf-8) process-coding-system-alist))

;; schemeモードとrun-schemeモードにcmuscheme.elを使用
;;(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
;;(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process." t)
;;直前/直後の括弧に対応する括弧を光らせます。

(show-paren-mode)
(setq show-paren-style 'mixed)
(set-face-background 'show-paren-match-face "gray10")
(set-face-foreground 'show-paren-match-face "SkyBlue")

;; org
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))
(setq org-src-fontify-natively t)
;; org-reveal
;; (load-library "ox-reveal")

;; Markdown MODE
;;; http://jblevins.org/projects/markdown-mode/
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))
(add-to-list 'ac-modes 'markdown-mode)

;;; via. http://yasuyk.github.io/blog/2013/01/16/emacs-marked/
(defun markdown-preview-file ()
  "run Marked on the current file and revert the buffer"
  (interactive)
  (shell-command
   (format "open -a /Applications/Marked.app %s"
	   (shell-quote-argument (buffer-file-name))))
  )
(global-set-key "\C-cm" 'markdown-preview-file)

;; C mode
(setq auto-mode-alist (cons '("\\.tc\\'" . c-mode) auto-mode-alist))
;; http://at-aka.blogspot.com/2006/12/emacs-c.html
(add-hook
 'c-mode-common-hook
 '(lambda ()
    ;; センテンスの終了である ';' を入力したら、自動改行+インデント
    ;; (c-toggle-auto-hungry-state 1)
    
    ;; RET キーで自動改行+インデント
    (define-key c-mode-base-map "\C-m" 'newline-and-indent)
    ;; インデント幅
    (setq c-basic-offset 2)
    ;; タブ幅
    (setq tab-width 4)
    ))

;; verilog mode
;;; http://linuxcom.info/verilog-mode.html
;;; Load verilog-mode only when needed
;; (autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
;; Any files that end in .v should be in verilog mode
;; (setq auto-mode-alist (cons '("\\.v\\'" . verilog-mode) auto-mode-alist))
;; (setq auto-mode-alist (cons '("\\.vt\\'" . verilog-mode) auto-mode-alist))
;;; Any files in verilog mode shuold have their keywords colorized
;; (add-hook 'verilog-mode-hook '(lambda () (font-look-mode 1)))
;; (add-to-list 'ac-modes 'verilog-mode)

;; bison mode/flex mode
;; (require 'font-lock)
;; (require 'cc-mode)
;; (require 'bison-mode)
;; (add-to-list 'auto-mode-alist '("\\.y$" . bison-mode))
;; (add-to-list 'auto-mode-alist '("\\.yy$" . bison-mode))
;; (autoload 'bison-mode "bison-mode" t)
;; (add-to-list 'auto-mode-alist '("\\.l$" . flex-mode))
;; (add-to-list 'auto-mode-alist '("\\.ll$" . flex-mode))
;; (autoload 'flex-mode "flex-mode" t)
;; (add-to-list 'ac-modes 'bison-mode)
;; (add-to-list 'ac-modes 'flex-mode)

;; ess (R-mode)
;; (setq load-path (append '("~/.emacs.d/elisp/ess-13.05/lisp") load-path))
;; (require 'ess-site)

;; Coq
;; (setq auto-mode-alist (cons '("\.v$" . coq-mode) auto-mode-alist))
;; (autoload 'coq-mode "coq" "Major mode for editing Coq vernacular." t)
;; (add-to-list 'ac-modes 'coq-mode)
;;; ProofGeneral
;; (load-file "$HOME/.emacs.d/ProofGeneral/generic/proof-site.elc")

;; OCaml
;;; Tuareg-mode
;;; via. http://tuareg.forge.ocamlcore.org/ -> Released Files
(setq load-path (append '("~/.emacs.d/elisp/tuareg-2.0.6") load-path))
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)
;; (setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(setq auto-mode-alist
      (append '(("\\.ml[ily]?$" . tuareg-mode)
                ("\\.topml$" . tuareg-mode))
              auto-mode-alist))
(modify-coding-system-alist 'file "\\.ml\\w?" 'euc-jp-unix)

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

;; tex
(add-to-list 'ac-modes 'latex-mode)

;; howm
(add-to-list 'load-path "~/.emacs.d/elisp/howm")
(setq howm-directory "~/Dropbox/howm/")
(setq howm-menu-lang 'ja)
;; org-mode 併用
(setq howm-view-title-header "*") ;; howm のロードより前に書く
(setq howm-file-name-format "%Y/%m/%Y-%m-%d-%H%M%S.org")
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

;; google translate
;; http://qiita.com/catatsuy/items/ae9875706769d4f02317
(global-set-key "\C-xt" 'google-translate-at-point)
(global-set-key "\C-xT" 'google-translate-query-translate)
;; 翻訳のデフォルト値を設定 (無効化は C-u を付与 e.g. C-u C-x t)
(custom-set-variables
  '(google-translate-default-source-language "en")
  '(google-translate-default-target-language "ja"))

;; pbcopy
;; OS X の clipboard と同期
(turn-on-pbcopy)


;;-------------------------------------------------
;; git
;;-------------------------------------------------
;; git-gutter
(global-git-gutter-mode t)


;; rainbow-mode
(add-hook 'emacs-lisp-mode-hook 'rainbow-mode)
