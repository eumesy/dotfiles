;; google translate
;; http://qiita.com/catatsuy/items/ae9875706769d4f02317
(global-set-key "\C-xt" 'google-translate-at-point)
(global-set-key "\C-xT" 'google-translate-query-translate)
;; 翻訳のデフォルト値を設定 (無効化は C-u を付与 e.g. C-u C-x t)
(custom-set-variables
 '(google-translate-default-source-language "en")
 '(google-translate-default-target-language "ja"))

