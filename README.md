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

## Claude Code グローバル設定

- 実体は別リポジトリ [eumesy/claude](https://github.com/eumesy/claude)（CLAUDE.md・settings.json・skills/）。install.sh が `ghq get` で `~/ghq/github.com/eumesy/claude` に clone し、`~/.claude/` 配下から symlink を張る
- GitHub Web で直接編集したら、各端末で `git -C ~/ghq/github.com/eumesy/claude pull` して反映する

## Finder の右クリックメニュー

Finder でフォルダを右クリックすると、以下のアクションで直接開ける:

- **New VS Code Window Here** — このリポジトリ同梱の Quick Action
  （`macos/*.workflow`、install.sh が ~/Library/Services に配置）
- **New iTerm2 Tab/Window Here** — iTerm2 が同梱する Service（iTerm2 を入れると自動で出る）
- **New Terminal at Folder / New Terminal Tab at Folder** — macOS 標準

出ない場合: System Settings → Keyboard → Keyboard Shortcuts → Services →
Files and Folders で該当項目を有効化する。

## git

- **GitHub への push は HTTPS、fetch/clone は ssh**（`url.<https>.pushInsteadOf` で push だけ透過的に迂回。install.sh の「6. git」参照）。ssh がプロキシ型サンドボックス（Claude Code 等）を通れないことがあるため。認証は `gh auth login` で取得したトークン（macOS Keychain 保存）を gh の credential helper が供給する。github.com 限定の helper なので、全ホスト用の osxkeychain（Overleaf 等）とは共存する
- トークンが Keychain にある都合上、Claude のサンドボックス内からは取り出せず、Claude からの push は承認つきのサンドボックス外実行になる（許容している既知の制限）

## LaTeX 執筆環境

執筆は VS Code + LaTeX Workshop で、Overleaf 同等の操作感になるよう設定してある。

- **ビルド**: 各プロジェクトの `latexmkrc` に一元化（例: ISCIE 原稿は platex → dvipdfmx、SyncTeX 有効）。ローカル（MacTeX、brew cask `mactex-no-gui`）と Overleaf で同一のビルドになる
- **エディタ操作**: `⌘S` / `C-x C-s` = 保存で自動ビルド、`⌘Enter` / `Ctrl+.` = 手動ビルド（完了後 PDF がカーソル行へ自動スクロール）、PDF 上のダブルクリック = ソースの該当行へジャンプ、`⌥;` = 行コメントのトグル、.tex はソフトラップ表示
- **PDF 表示**: LaTeX Workshop のタブ内ビューアに一本化（前述の「拡張機能の依存・競合メモ」参照）
- **数式プレビュー**: 数式にマウスホバーでポップアップ表示（LaTeX Workshop 標準）。さらに自作拡張 `latex-auto-mathpreview`（`vscode/extensions/`）が、.tex を開いたとき Math Preview Panel を自動で開いて **.tex エディタの直下**に配置し（右列の PDF を侵食しない）、フォーカスをエディタに戻す。カーソルが数式内にある間、パネルにライブレンダリングされる。プレビューは MathJax レンダリングのため実 TeX と差異があり、`vscode/latex-preview-macros.tex` にプレビュー専用の吸収マクロを定義してある（settings.json の `latex-workshop.hover.preview.newcommand.newcommandFile` が参照。実ビルドには無関係）: (1) MathJax が知らないコマンド（`\mathds`, `\textsc` 等）の見た目代替、(2) 負スペース（`\!` 等）・lap 系（`\mathclap` 等）の無効化 — 行頭・行末にあると MathJax の SVG が数式の端をクリップして見切れるため。副作用としてプレビューの字間は実 PDF よりやや広めになる。マクロファイルは保存すれば次のレンダリングから反映（Reload Window 不要）。newcommandFile の絶対パスはマシン依存（`/Users/sho` 前提。存在しないマシンでは黙って無効になるだけでエラーにはならない）。mathtools 系（`\coloneqq` 等）は同 `hover.preview.mathjax.extensions` で対応。プレビューは MathJax レンダリングのため、MathJax が知らないパッケージ由来コマンド（`\mathds`, `\textsc` 等）の見た目代替を `vscode/latex-preview-macros.tex` に定義してある（settings.json の `latex-workshop.hover.preview.newcommand.newcommandFile` が参照。実ビルドには無関係）。mathtools 系（`\coloneqq` 等）は同 `hover.preview.mathjax.extensions` で対応
- **Overleaf 同期**: git bridge で同期（`git clone https://git.overleaf.com/<projectId>`）。co-author が Overleaf 上でコメント・添削している間は push を凍結する（コメントは git で運ばれず、push で位置ずれ・消失しうるため）
- **バージョン管理**: 1 指示 1 commit。GitHub ミラー remote へは commit ごと自動 push、Overleaf への push のみ都度確認。規約の実体は Claude skill [`skills/latex-git-workflow/`（eumesy/claude リポジトリ内）](https://github.com/eumesy/claude/blob/main/skills/latex-git-workflow/SKILL.md)
