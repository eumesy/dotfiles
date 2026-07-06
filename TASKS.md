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
