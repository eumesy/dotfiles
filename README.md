# dotfiles

Mac のセットアップを 1 コマンドで再現するためのリポジトリ。

## 新しい Mac での手順

```sh
xcode-select --install
git clone https://github.com/<you>/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

インストールされるもの:

- Homebrew + `Brewfile` のパッケージ（git, gh, VS Code）
- MacTeX / TeX Live（未インストールの場合のみ、`mactex-no-gui`）
- VS Code 拡張（LaTeX Workshop, Awesome Emacs Keymap）

## VS Code 設定の管理方針

- **主**: VS Code 内蔵の **Settings Sync**（GitHub アカウントでログイン）が
  設定・拡張・キーバインドを全端末に自動同期する
- **従**: `vscode/` 以下にバックアップコピーを保持
  （install.sh は設定ファイルが存在しない場合のみ配置する）

設定を大きく変えたら、バックアップも更新しておく:

```sh
cp "$HOME/Library/Application Support/Code/User/settings.json"    ~/dotfiles/vscode/
cp "$HOME/Library/Application Support/Code/User/keybindings.json" ~/dotfiles/vscode/
```

## Claude Code グローバル設定 (CLAUDE.md)

- 実体は `claude/CLAUDE.md`（このリポジトリ内）、
  `~/.claude/CLAUDE.md` はそこへの symlink（install.sh が作成）
- GitHub Web で直接編集したら、各端末で `git -C ~/dotfiles pull` して反映する

## LaTeX プロジェクトの方針

- ビルド設定は各プロジェクトの `latexmkrc` に一元化
  （ローカルと Overleaf で同一のビルドになる）
- Overleaf とは git bridge で同期:
  `git clone https://git.overleaf.com/<projectId>`
- co-author が Overleaf 上でコメント・添削している間は push を凍結する
  （git push はコメントの位置ずれ・消失を起こしうるため）
