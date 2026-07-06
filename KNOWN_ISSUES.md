# Known issues

このリポジトリの設定で把握済みだが、上流ツール側に起因するため dotfiles では対処しない事象を記録する。設定ミスと取り違えて再調査するのを避けるために残す。

## fzf の Esc / Ctrl-G が Ghostty 上で効かない（2026-07-06）

- **症状:** Ghostty のターミナルで fzf（Ctrl-L の zoxide 検索、Ctrl-R の履歴検索など）を開いたとき、キャンセルの標準キーである **Esc と Ctrl-G が効かない**。**Ctrl-C は効く**。文字削除（Ctrl-H / Ctrl-W）は正常に動く。
- **原因:** fzf 本体のバグ。Ghostty が有効化する kitty keyboard protocol の下で fzf が一部のキーを取りこぼす（fzf CHANGELOG では 0.72.0 で arrow / Home / End の同種バグ #4776 を修正済みだが、Esc / Ctrl-G は 0.73.1 時点で未修正）。dotfiles の設定ミスではない。
- **環境:** fzf 0.73.1（Homebrew 最新）、Ghostty（`TERM=xterm-ghostty`）。
- **回避:** キャンセルは **Ctrl-C** を使う。dotfiles 側の設定変更はしない（上流修正待ち）。
- **上流修正が入ったら:** `brew upgrade fzf` 後に Esc / Ctrl-G が効くか再確認し、直っていれば本項目を削除する。
