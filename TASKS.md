# TASKS (dotfiles / 環境設定まわり)

複数リポジトリ（dotfiles・eumesy/claude）にまたがる環境・設定タスクの永続トラッカー。git 管理外の親フォルダには置かず、tracked な dotfiles に置く（グローバル CLAUDE.md「タスクはツリー構造で管理し、TASKS.md に永続化する」の git 管理下ルール）。

## 将来: COLOR 設定の一元管理（2026-07-07 本人決定・バックログ）

- [ ] 色（COLOR）関係の設定を一箇所（SSOT）で集中管理したい。現状は複数箇所に分散している:
  - Claude Code カスタムテーマ: `eumesy/claude/themes/highlight-you.json` の `overrides.userMessageBackground`（現 `#33260f` amber。自分の依頼メッセージ背景を強調。fullscreen 時のみ有効）。
  - Ghostty: `dotfiles/ghostty/config`（現状は `background-opacity`/`background-blur` のみ。テーマ/パレットは端末既定に委任）。
  - git-split-diffs 配色: git config `split-diffs.theme-name`（既定 `dark`。dotfiles install.sh「6. git」が設定）。
  - Claude.app のダークモード: install.sh が `plutil` で config.json の `userThemeMode` を設定。
  - 必要に応じ VS Code テーマ・iTerm2 プロファイルの配色も対象に含める。
- 制約: Claude Code のテーマは固定スキーマの JSON を直読みし、外部変数参照は不可。一元化するなら「大文字定数を SSOT にし、install.sh 等の生成器で各ツールの設定ファイルへ展開する」方式になる（2026-07-07 に Option A として提示。この日は現状維持＝テーマ JSON 直接編集の hot-reload を優先し見送り）。
- 着手の入口: dotfiles に色用の共有 CONFIG（例: `dotfiles/COLORS.env` 等、UPPER_SNAKE_CASE 定数）を置き、install.sh の生成器から各設定へ展開する設計を検討する。関連 preference はグローバル CLAUDE.md「設定値・定数は名前をつけてスコープの外側に括り出す」、テーマ機構は skill `claude-code-custom-themes`。

## 将来（低温度・やれたら）: 自分のメッセージ背景ブロックを上下に広げる（2026-07-07 本人希望）

- [ ] Claude Code の自分の投稿（ユーザーメッセージ）の**上下に「塗られた空行」を1行ずつ**入れ、`userMessageBackground`（現 amber `#33260f`）のブロックを縦に広げて更に目立たせたい。温度感は「将来何かあったらやりたい」程度。
- 現状 未実装＝**Claude Code 側に機能が無い**（2026-07-07 に確認）。メッセージ padding/spacing/blank-line の設定キーもテーマトークンも存在しない（settings スキーマ・2.1.201 バイナリ・テーマトークン一覧で確認。`userMessagePadding` 等は 0 ヒット）。背景塗りは本文行のぶんに固定。`UserPromptSubmit` フックの出力はコンテキスト行きで表示メッセージを書き換えられず自動化も不可。
- 唯一の現状回避は手動（本文の先頭・末尾に空行を自分で入れると本文の一部として塗られる）だが手動運用は本人方針に反するため常用しない。
- 再検討トリガー: 公式に縦 padding トークン/「メッセージ前後を塗る」オプションが追加されたら適用する、または feature request を提出する（本人の「自作回避・公式待ち」方針）。関連: skill `claude-code-custom-themes`、テーマ `eumesy/claude/themes/highlight-you.json`。
