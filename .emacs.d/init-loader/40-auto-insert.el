(require 'autoinsert)

(setq auto-insert-directory "~/.template/")

(setq auto-insert-alist
      (append '(
                ("\\.py" . "python.py")
                ) auto-insert-alist))
