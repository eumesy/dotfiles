# dotfiles

Mac のセットアップを 1 コマンドで再現するためのリポジトリ。

## 新しい Mac での手順

```sh
xcode-select --install
git clone https://github.com/eumesy/dotfiles.git ~/ghq/github.com/eumesy/dotfiles
~/ghq/github.com/eumesy/dotfiles/install.sh   # ~/dotfiles symlink も作られる
```

インストールされるもの:

- Homebrew と [`Brewfile`](Brewfile) に列挙したパッケージ
  （CLI ツール・GUI アプリ・MacTeX。各ツールの役割は Brewfile 内のコメント参照）
- VS Code 拡張（リストは [`install.sh`](install.sh) 内。普段は Settings Sync が
  拡張も同期するが、未ログインでも最低限動くように install.sh でも入れる）
- 各種設定ファイルの symlink（対象の一覧は [`install.sh`](install.sh) 参照）

install.sh は冪等（何度実行しても安全）に保つ規約で、非冪等になりがちな書き方は
[`scripts/lint-install.sh`](scripts/lint-install.sh) が検出する（pre-commit hook で自動実行）。

## VS Code 設定の管理方針

- **主**: VS Code 内蔵の **Settings Sync**（GitHub アカウントでログイン）が
  設定・拡張・キーバインドを全端末に自動同期する
- **従**: settings.json / keybindings.json の実体は `vscode/` 以下にあり、
  VS Code の設定ディレクトリからは symlink（install.sh が作成）。
  設定変更は自動的に git 管理下に入るので、手動コピーは不要

### 拡張機能の依存・競合メモ

- **PDF 表示は LaTeX Workshop に一本化**（ビルド後のプレビュー・サイドバーからの
  PDF 表示・SyncTeX ジャンプすべて）。**vscode-pdf (tomoki1207.pdf) は入れない**こと。
  LaTeX Workshop と競合して警告が出る（2026-07 に一度入れて削除した実績あり）
- 自作拡張 `latex-auto-mathpreview`（`vscode/extensions/`）は **LaTeX Workshop 依存**
  （そのコマンド `latex-workshop.showMathPreviewPanel` を呼ぶだけの薄いラッパー）。
  LaTeX Workshop が無い環境では何もしない（エラーにもならない）

## Claude Code グローバル設定 (CLAUDE.md)

- 実体は `claude/CLAUDE.md`（このリポジトリ内）、
  `~/.claude/CLAUDE.md` はそこへの symlink（install.sh が作成）
- GitHub Web で直接編集したら、各端末で `git -C ~/dotfiles pull` して反映する

## Finder の右クリックメニュー

Finder でフォルダを右クリックすると、以下のアクションで直接開ける:

- **New VS Code Window Here** — このリポジトリ同梱の Quick Action
  （`macos/*.workflow`、install.sh が ~/Library/Services に配置）
- **New iTerm2 Tab/Window Here** — iTerm2 が同梱する Service（iTerm2 を入れると自動で出る）
- **New Terminal at Folder / New Terminal Tab at Folder** — macOS 標準

出ない場合: System Settings → Keyboard → Keyboard Shortcuts → Services →
Files and Folders で該当項目を有効化する。

## LaTeX プロジェクトの方針

- ビルド設定は各プロジェクトの `latexmkrc` に一元化
  （ローカルと Overleaf で同一のビルドになる）
- Overleaf とは git bridge で同期:
  `git clone https://git.overleaf.com/<projectId>`
- co-author が Overleaf 上でコメント・添削している間は push を凍結する
  （git push はコメントの位置ずれ・消失を起こしうるため）
