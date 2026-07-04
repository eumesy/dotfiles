# HANDOFF — 次セッションへの引き継ぎ書（2026-07-04 作成）

「launchd 自動同期 + Starship プロンプト」導入を別セッションで行うための引き継ぎ。
新セッションは `~/dotfiles` で Claude Code を開き、最初に「HANDOFF.md を読んで再開して」と指示すればよい。

## 現状（2026-07-04 時点）

- リポジトリ: [github.com/eumesy/dotfiles](https://github.com/eumesy/dotfiles)（public, branch `main`）
  - 実体は `~/ghq/github.com/eumesy/dotfiles`、`~/dotfiles` はそこへの symlink
- symlink 済み: `~/.zshrc` `~/.zprofile` → `zsh/`、`~/.claude/CLAUDE.md` → `claude/CLAUDE.md`
  （install.sh が冪等に作成する）
- Brewfile: git, gh, ghq, fzf, visual-studio-code, mactex-no-gui（TeX Live 2026 導入済み）
- 旧資産: [github.com/eumesy/dotfiles-2021](https://github.com/eumesy/dotfiles-2021)
  （public、旧 `dotfiles` を rename したもの。starship.toml / .latexmkrc-* / Emacs / tmux 等あり）
- 関連: ISCIE 原稿リポジトリ（Dropbox 配下
  `.../2026-04-ot-for-nlp-survey-ISCIE-寄稿/latex/ot_for_nlp_survey_ISCIE`、
  Overleaf git bridge 接続済み・認証は Keychain）。
  **原稿リポジトリは自動同期の対象外**（co-author のコメント中は push 凍結という人間判断が必要）

## やること 1: launchd 自動同期（合意済みの設計）

- `scripts/dotfiles-sync.sh` を新規作成。処理内容:
  1. `~/dotfiles` に未 commit の変更があれば自動 commit（メッセージ "auto-sync"）
  2. `git pull --rebase --autostash`（GitHub Web での編集を取り込む）
  3. ahead なら `git push`
  4. rebase 競合時は自動処理を中断し、`~/Desktop` に通知ファイルを置く（安全弁）
- launchd plist（`com.eumesy.dotfiles-sync.plist`、15 分間隔 + ログイン時）も
  dotfiles 内に置き、install.sh から symlink + `launchctl bootstrap` で登録
- 動作確認: GitHub Web で編集 → 15 分以内にローカル反映 / ローカル変更 → 自動 push

## やること 2: Starship プロンプト

- Brewfile に `brew "starship"` を追加
- `dotfiles-2021` の `starship.toml` を取得して内容をユーザーに見せ、
  好みが変わっていないか確認のうえ移植（`starship/starship.toml` + symlink）
- `zsh/zshrc` 末尾に `eval "$(starship init zsh)"` を追加
- 狙い: すべての git repo で branch / 未commit / ahead-behind（⇡⇣）を常時表示
  （dotfiles 自動同期の状態可視化の保険。原稿リポジトリの push/pull 忘れ検知にも効く）

## やること 3（任意・急がない）: dotfiles-2021 資産の選別移植

- 候補: `.latexmkrc-platex` 等の latexmk 設定群、`.tmux.conf`、Emacs 設定、
  `.gitconfig`、`.gitignore.global`、`Brewfile`（旧）との突き合わせ
- ユーザーと相談しながら 1 つずつ

## 作業規約（必読）

- `claude/CLAUDE.md` に従う。特に:
  - ファイル編集は**常に diff 提示 → ユーザー承認 → 適用**
  - タスクは依存関係つきツリーで TASKS.md に永続化・維持
  - 代名詞・指示語で過去メッセージを参照しない（コマンド等は毎回全文再掲）
- dotfiles 自身の commit & push は定型運用として事前確認不要（2026-07-04 のセッションで合意）
