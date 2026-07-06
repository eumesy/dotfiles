# dotfiles リポジトリの編集規約

## ドキュメント（README.md）

- Brewfile / install.sh の内容（パッケージ名・VS Code 拡張名など）を README に列挙しない。[`Brewfile`](Brewfile) のような相対リンクで実体ファイルを参照する。
  - 理由: 列挙は更新に追随せず腐る。single source of truth は各ファイル本体。
- README に書くのは、コードから読み取れない方針・手順（Settings Sync の主従関係、Overleaf の push 凍結など）に限る。
- 例外的に README が一覧を持つのは、その一覧を SSOT から生成している場合に限る。install.sh 完了後の手動ステップは [`MANUAL_STEPS.tsv`](MANUAL_STEPS.tsv) が SSOT で、README の該当ブロックと install.sh の完了メッセージを [`scripts/gen-manual-steps.sh`](scripts/gen-manual-steps.sh) が生成する（手書きの列挙ではないので腐らない）。TSV を編集したら再生成し、README の `MANUAL_STEPS:BEGIN`〜`END` ブロックは手で編集しない（pre-commit hook が同期を検査する）。

## Brewfile

- パッケージを追加するときは、役割が分かる 1 行コメントを付ける（README で列挙しない代わりに、Brewfile 自体をカタログとして読めるようにする）。

## install.sh

- 各ステップは再実行しても安全（冪等）に書く。既存ステップの書き方（`ln -sfn`、`mkdir -p`、存在チェック guard、`.bak` バックアップ）に合わせる。
- 編集したら `scripts/lint-install.sh` を実行して NG が無いことを確認する（pre-commit hook でも自動実行される。hook は install.sh 内の `git config core.hooksPath scripts/githooks` が有効化する）。
- lint は非冪等になりがちなパターンの検出であって証明ではない。ステップを追加・変更したら「2 回目の実行で何が起こるか」を必ず確認する。
- パッケージの追加は install.sh に `brew install` を直接書かず Brewfile に追加する。
