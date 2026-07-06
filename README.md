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

## 複数 Mac での運用（変更の同期）

セットアップ後の日常運用。同期チャネルは 3 系統: この repo、[eumesy/claude](https://github.com/eumesy/claude)（Claude Code 設定）、VS Code Settings Sync（後述「VS Code 設定の管理方針」）。

### 変更した端末側

- commit したら**その場で push** する。未 push のまま放置すると、他端末での変更とのコンフリクトの温床になる。
- 設定ファイルの実体は repo 内にあり各所から symlink で参照されているので、アプリの設定画面や手編集で設定を変えた場合も差分は repo の working tree に現れる。`git status` で気づいたら commit & push する。

### 他の端末側（変更を受け取る）

受け取りは自動。LaunchAgent（[`macos/com.eumesy.dotfiles-auto-sync.plist`](macos/com.eumesy.dotfiles-auto-sync.plist)、install.sh が配置・登録）が 1 時間ごとに [`scripts/auto-sync.sh`](scripts/auto-sync.sh) を実行し、この repo と eumesy/claude を pull する。全端末が常時電源オンでも人の操作なしで同期される。

- 設定ファイルの**内容**の変更（zshrc の中身など）は symlink 経由なので pull だけで反映される。Settings Sync などが書き込んだ未 commit の差分は autostash が退避・復元する。
- **Claude 設定（eumesy/claude）は無人で全端末に反映される**設計（自分専用 repo であることを前提に許容）。その代わり、反映されたことは下記の通知で必ず知らせる。
- 人の対応・確認が要る事象だけ macOS 通知が出る:
  - **構成**が変わる更新（install.sh / Brewfile の変更）を取り込んだとき → install.sh を再実行する（冪等。TeX 環境がある端末では tlmgr の更新に sudo パスワードと時間を要する）。
  - Claude 設定（settings.json / skills / CLAUDE.md）の更新を取り込んだとき → `git log` で内容を確認する。
  - pull がコンフリクトしたとき → 手動で解消する。`vscode/` 配下は Settings Sync が同期した側（新しい方）を正として解消し、commit し直す。それ以外は通常どおり内容を見て解消する。
- main にいる端末だけ pull する（作業ブランチ・detached HEAD の端末では何もしない）。fetch できない（オフライン等）ときは何もせず、記録は `~/Library/Logs/com.eumesy.dotfiles-auto-sync.log` に残る。
- 次の実行を待たずに今すぐ反映したいときは手動で:

  ```sh
  git -C ~/dotfiles pull --rebase --autostash && ~/dotfiles/install.sh
  ```

  （eumesy/claude は install.sh 内の `ghq get -u` が pull を兼ねる。`--autostash` は未 commit 差分があると素の pull --rebase が失敗するため）

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

- CLI は自己更新型のため brew 管理外とし、install.sh が公式 native installer で導入する（デスクトップ版 Claude.app は通常どおり [`Brewfile`](Brewfile) の cask）
- **認証**: 各マシンで初回に `claude` を起動しブラウザでログインする。資格情報は macOS Keychain に保存され、repo では同期されない（Codex 同様、資格情報はこの repo にも eumesy/claude にも入れない）
- 実体は別リポジトリ [eumesy/claude](https://github.com/eumesy/claude)（CLAUDE.md・settings.json・skills/）。install.sh が `ghq get` で `~/ghq/github.com/eumesy/claude` に clone し、`~/.claude/` 配下から symlink を張る
- 他端末や GitHub Web での編集を取り込む手順は前述「複数 Mac での運用（変更の同期）」参照（pull すれば symlink 経由で反映される）

## OpenAI Codex CLI（検証用 agent）

Claude Code が生成した成果物のレビューを別プロバイダのモデルに検証させる（cross-provider review）ための CLI。呼び出し方の規約は Claude skill [`skills/agent-review/`（eumesy/claude リポジトリ内）](https://github.com/eumesy/claude/blob/main/skills/agent-review/SKILL.md) が正。

- **導入**: [`Brewfile`](Brewfile) の `cask "codex"`（Claude Code CLI と違い自己更新型ではないので brew で更新する）
- **認証**: 各マシンで初回に `codex login` を実行し、ブラウザで ChatGPT アカウント（有料プラン。本人は Plus を契約）にログインする。資格情報は `~/.codex/auth.json` に保存される
- **秘密情報の扱い**: `~/.codex/auth.json` はパスワード同等の秘密情報。**この repo にも eumesy/claude にも絶対に入れない**（symlink 管理の対象外）。マシン新調時は `codex login` をやり直すのが正規手順。API キー認証は使わない方針（ChatGPT プランで足りる）。将来 API キーが必要になった場合も、git 管理外のファイルか macOS Keychain に置き、repo には置かない
- **設定**: `~/.codex/config.toml` は現状既定のまま（repo 管理なし）。恒久設定を持ちたくなったら、auth.json と分離されていることを確認したうえで dotfiles 管理に載せる

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
- **diff 表示は delta**（Brewfile の `git-delta`）。install.sh の「6. git」が `core.pager=delta` と `delta.side-by-side=true` 等を設定し、`git diff` / `git show` / `git log -p` がターミナル内で 2 カラム・シンタックスハイライト表示になる（VS Code を開かず端末内でレビューできる）。表示を切り替えたいときは `git --no-pager diff`（delta を通さない素の diff）や `git -c delta.side-by-side=false diff`（1 カラム）で個別に上書きできる

## LaTeX 執筆環境

執筆は VS Code + LaTeX Workshop で、Overleaf 同等の操作感になるよう設定してある。

- **ビルド**: 各プロジェクトの `latexmkrc` に一元化（例: ISCIE 原稿は platex → dvipdfmx、SyncTeX 有効）。ローカル（MacTeX、brew cask `mactex-no-gui`）と Overleaf で同一のビルドになる
- **エディタ操作**: `⌘S` / `C-x C-s` = 保存で自動ビルド、`⌘Enter` / `Ctrl+.` = 手動ビルド（完了後 PDF がカーソル行へ自動スクロール）、PDF 上のダブルクリック = ソースの該当行へジャンプ、`⌥;` = 行コメントのトグル、.tex はソフトラップ表示
- **PDF 表示**: LaTeX Workshop のタブ内ビューアに一本化（前述の「拡張機能の依存・競合メモ」参照）
- **数式プレビュー**: 数式にマウスホバーでポップアップ表示（LaTeX Workshop 標準）。さらに自作拡張 `latex-auto-mathpreview`（`vscode/extensions/`）が、.tex を開いたとき Math Preview Panel を自動で開いて **.tex エディタの直下**に配置し（右列の PDF を侵食しない）、フォーカスをエディタに戻す。カーソルが数式内にある間、パネルにライブレンダリングされる。プレビューは MathJax レンダリングのため実 TeX と差異があり、`vscode/latex-preview-macros.tex` にプレビュー専用の吸収マクロを定義してある（settings.json の `latex-workshop.hover.preview.newcommand.newcommandFile` が参照。実ビルドには無関係）: (1) MathJax が知らないコマンド（`\mathds`, `\textsc` 等）の見た目代替、(2) 負スペース（`\!` 等）・lap 系（`\mathclap` 等）の無効化 — 行頭・行末にあると MathJax の SVG が数式の端をクリップして見切れるため。副作用としてプレビューの字間は実 PDF よりやや広めになる。マクロファイルは保存すれば次のレンダリングから反映（Reload Window 不要）。newcommandFile の絶対パスはマシン依存（`/Users/sho` 前提。存在しないマシンでは黙って無効になるだけでエラーにはならない）。mathtools 系（`\coloneqq` 等）は同 `hover.preview.mathjax.extensions` で対応。プレビューは MathJax レンダリングのため、MathJax が知らないパッケージ由来コマンド（`\mathds`, `\textsc` 等）の見た目代替を `vscode/latex-preview-macros.tex` に定義してある（settings.json の `latex-workshop.hover.preview.newcommand.newcommandFile` が参照。実ビルドには無関係）。mathtools 系（`\coloneqq` 等）は同 `hover.preview.mathjax.extensions` で対応
- **Overleaf 同期**: git bridge で同期（`git clone https://git.overleaf.com/<projectId>`）。co-author が Overleaf 上でコメント・添削している間は push を凍結する（コメントは git で運ばれず、push で位置ずれ・消失しうるため）
- **バージョン管理**: 1 指示 1 commit。GitHub ミラー remote へは commit ごと自動 push、Overleaf への push のみ都度確認。規約の実体は Claude skill [`skills/latex-git-workflow/`（eumesy/claude リポジトリ内）](https://github.com/eumesy/claude/blob/main/skills/latex-git-workflow/SKILL.md)
