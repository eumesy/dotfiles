#!/usr/bin/env bash
#
# 新しい Mac のセットアップスクリプト
#
# 規約: 各ステップは再実行しても安全（冪等）に書く。ステップを追加・変更したら
#       scripts/lint-install.sh を実行し、「2 回目の実行で何が起こるか」も確認する。
#
# 使い方:
#   xcode-select --install   # 事前に一度だけ
#   git clone https://github.com/<you>/dotfiles.git ~/dotfiles
#   ~/dotfiles/install.sh
#
set -euo pipefail

# スクリプト自身が置かれているディレクトリ（= dotfiles リポジトリ）に移動
cd "$(dirname "$0")"

# ---- 1. Homebrew ----
if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# ---- 2. Packages ----
echo "==> brew bundle..."
brew bundle --file=Brewfile

# ---- 3. TeX 初期設定（mactex-no-gui は Brewfile 経由でインストール済み）----
if [ -x /Library/TeX/texbin/tlmgr ]; then
  eval "$(/usr/libexec/path_helper)"
  sudo tlmgr update --self --all || true
  sudo tlmgr paper a4 || true
fi

# ---- 4. VS Code extensions ----
# （普段は Settings Sync が拡張も同期するが、Sync 未ログインでも動くように）
if command -v code >/dev/null 2>&1; then
  echo "==> Installing VS Code extensions..."
  code --install-extension James-Yu.latex-workshop
  code --install-extension tuttieee.emacs-mcx
  code --install-extension anthropic.claude-code
fi

# ---- 5. VS Code settings を symlink ----
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
for f in settings.json keybindings.json; do
  if [ -f "$VSCODE_USER/$f" ] && [ ! -L "$VSCODE_USER/$f" ]; then
    echo "==> Backing up existing $f -> $f.bak"
    mv "$VSCODE_USER/$f" "$VSCODE_USER/$f.bak"
  fi
  ln -sfn "$PWD/vscode/$f" "$VSCODE_USER/$f"
done

# ---- 6. git ----
git config --global credential.helper osxkeychain
# リポジトリ同梱の git hooks を有効化（pre-commit で install.sh の冪等性 lint）
git config core.hooksPath scripts/githooks
# GitHub への push だけ HTTPS 経由にする（fetch/clone は従来どおり ssh のまま）。
# ssh はプロキシ型サンドボックス（Claude Code 等）を通れないことがあるため。
# 認証は gh auth login で Keychain に保存したトークンを使う。gh auth setup-git は
# github.com 限定の credential helper を追加するだけで、上の osxkeychain（全ホスト用、
# Overleaf 等）とは共存する。トークンが Keychain にある都合上、サンドボックス内からは
# 取り出せないので、Claude からの push はサンドボックス外実行（要承認）になる
git config --global url."https://github.com/".pushInsteadOf "git@github.com:"
gh auth setup-git 2>/dev/null || echo "==> gh 未ログインのため credential helper 未設定（gh auth login 後に再実行）"
# git-split-diffs（Brewfile）を git の pager にして diff/show/log -p を GitHub 風の
# side-by-side・シンタックスハイライト表示にする。ターミナル内で完結する（VS Code を開かない）。
# less -RFX で色を保ちつつ、1 画面に収まる差分はページャを介さず表示する（git-split-diffs 公式の推奨）。
# 旧 delta 設定（interactive.diffFilter / delta.*）は既存マシンに残ると、delta 削除後に
# git add -p 等が壊れるため撤去する（--unset-all/--remove-section はキー不在時 exit 5 で
# set -e を殺すので || true でガード。未設定の新規マシンでは no-op）
git config --global --unset-all interactive.diffFilter 2>/dev/null || true
git config --global --remove-section delta 2>/dev/null || true
git config --global core.pager 'git-split-diffs --color | less -RFX'
# グローバル gitignore（.DS_Store 等）。core.excludesFile 未設定時に git が
# 標準で読む ~/.config/git/ignore へ symlink する
mkdir -p "$HOME/.config/git"
if [ -f "$HOME/.config/git/ignore" ] && [ ! -L "$HOME/.config/git/ignore" ]; then
  echo "==> Backing up existing ~/.config/git/ignore -> ignore.bak"
  mv "$HOME/.config/git/ignore" "$HOME/.config/git/ignore.bak"
fi
ln -sfn "$PWD/git/ignore" "$HOME/.config/git/ignore"

# ---- 7. Claude Code: CLI 本体と設定リポジトリ ----
# CLI は公式 native installer で ~/.local/bin/claude に導入する（自己更新型なので
# brew 管理外。デスクトップ版 Claude.app は Brewfile の cask "claude" で導入済み）。
# PATH は zsh/zshrc の先頭行で ~/.local/bin を通している。導入済みなら何もしない
# （installer が rc ファイルへ PATH を追記するのを避ける意味でも guard する）。
if [ ! -x "$HOME/.local/bin/claude" ] && ! command -v claude >/dev/null 2>&1; then
  echo "==> Installing Claude Code CLI..."
  curl -fsSL https://claude.ai/install.sh | bash
fi
# 設定リポジトリ (eumesy/claude) を clone して symlink。
# 実体は https://github.com/eumesy/claude（CLAUDE.md / settings.json / skills / themes）。
# ghq get -u は未 clone なら clone、clone 済みなら pull（冪等）。
ghq get -u github.com/eumesy/claude
CLAUDE_REPO="$(ghq root)/github.com/eumesy/claude"
mkdir -p "$HOME/.claude"
for f in CLAUDE.md settings.json; do
  if [ -f "$HOME/.claude/$f" ] && [ ! -L "$HOME/.claude/$f" ]; then
    echo "==> Backing up existing ~/.claude/$f -> $f.bak"
    mv "$HOME/.claude/$f" "$HOME/.claude/$f.bak"
  fi
  ln -sfn "$CLAUDE_REPO/$f" "$HOME/.claude/$f"
done
for d in skills themes; do
  # repo 側に実体が無ければ symlink を張らない（themes/ 未 push の端末で壊れた symlink を作らない）
  [ -d "$CLAUDE_REPO/$d" ] || continue
  if [ -d "$HOME/.claude/$d" ] && [ ! -L "$HOME/.claude/$d" ]; then
    echo "==> Backing up existing ~/.claude/$d -> $d.bak"
    mv "$HOME/.claude/$d" "$HOME/.claude/$d.bak"
  fi
  ln -sfn "$CLAUDE_REPO/$d" "$HOME/.claude/$d"
done

# ---- 8. zsh 設定を symlink ----
for pair in "zsh/zshenv:.zshenv" "zsh/zshrc:.zshrc" "zsh/zprofile:.zprofile"; do
  src="${pair%%:*}"; dst="${pair##*:}"
  if [ -f "$HOME/$dst" ] && [ ! -L "$HOME/$dst" ]; then
    echo "==> Backing up existing ~/$dst -> $dst.bak"
    mv "$HOME/$dst" "$HOME/$dst.bak"
  fi
  ln -sfn "$PWD/$src" "$HOME/$dst"
done

# ---- 9. ~/dotfiles symlink（実体は ghq 配下）----
[ -e "$HOME/dotfiles" ] || ln -s "$PWD" "$HOME/dotfiles"

# ---- 10. Finder Quick Actions（右クリック → New VS Code Tab/Window Here）----
# Services は symlink だと認識されないことがあるため cp で配置
mkdir -p "$HOME/Library/Services"
cp -R macos/*.workflow "$HOME/Library/Services/"
/System/Library/CoreServices/pbs -update 2>/dev/null || true

# ---- 11. Ghostty 設定を symlink ----
mkdir -p "$HOME/.config/ghostty"
if [ -f "$HOME/.config/ghostty/config" ] && [ ! -L "$HOME/.config/ghostty/config" ]; then
  echo "==> Backing up existing ghostty config -> config.bak"
  mv "$HOME/.config/ghostty/config" "$HOME/.config/ghostty/config.bak"
fi
ln -sfn "$PWD/ghostty/config" "$HOME/.config/ghostty/config"

# ---- 12. Dock に Ghostty を追加（dockutil、既にあれば何もしない）----
if command -v dockutil >/dev/null 2>&1; then
  dockutil --find Ghostty >/dev/null 2>&1 || dockutil --add /Applications/Ghostty.app
fi

# ---- 13. 自作 VS Code 拡張を symlink（.tex を開くと数式プレビュー自動起動）----
mkdir -p "$HOME/.vscode/extensions"
ln -sfn "$PWD/vscode/extensions/latex-auto-mathpreview" \
        "$HOME/.vscode/extensions/eumesy.latex-auto-mathpreview-0.0.1"

# ---- 14. iTerm2: Dynamic Profile を symlink し、デフォルトプロファイルに設定 ----
# プロファイルの実体は iterm2/profiles.json（Nerd Font 指定など）。iTerm2 は
# DynamicProfiles ディレクトリを監視するので、JSON の変更は起動中でも即時反映される。
# ※ defaults write は iTerm2 起動中に実行すると終了時に上書きされうるため、
#    iTerm2 を終了してから実行するのが安全
mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
ln -sfn "$PWD/iterm2/profiles.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles/profiles.json"
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "dotfiles-default-profile"

# ---- 15. 自動同期 LaunchAgent（1 時間ごとに dotfiles / claude repo を pull）----
# 実体は scripts/auto-sync.sh（README「複数 Mac での運用」参照）。
# LaunchAgents は symlink だと launchctl に読まれないことがあるため cp で配置。
# 登録は legacy な load/unload でなく bootstrap/bootout を使う（bootout → bootstrap で冪等）。
# GUI セッション外（ssh 等）だと bootstrap は失敗しうるので、install.sh 全体は止めず警告に留める
mkdir -p "$HOME/Library/LaunchAgents"
cp macos/com.eumesy.dotfiles-auto-sync.plist "$HOME/Library/LaunchAgents/"
launchctl bootout "gui/$(id -u)/com.eumesy.dotfiles-auto-sync" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.eumesy.dotfiles-auto-sync.plist" \
  || echo "==> LaunchAgent の登録に失敗（GUI セッション外?）。自動同期は停止したままなので、ログイン後に install.sh を再実行してください"

# ---- 16. cmux 設定を symlink ----
# ターミナル部分の見た目（背景・半透明・ブラー等）は cmux も ~/.config/ghostty/config を
# 読むため Ghostty と共通。ここでは app UI 側の設定（cmux/cmux.json）を管理する。
# 反映は `cmux reload-config`（起動中でも可）
mkdir -p "$HOME/.config/cmux"
if [ -f "$HOME/.config/cmux/cmux.json" ] && [ ! -L "$HOME/.config/cmux/cmux.json" ]; then
  echo "==> Backing up existing cmux.json -> cmux.json.bak"
  mv "$HOME/.config/cmux/cmux.json" "$HOME/.config/cmux/cmux.json.bak"
fi
ln -sfn "$PWD/cmux/cmux.json" "$HOME/.config/cmux/cmux.json"

# ---- 17. Claude.app（デスクトップ版）をダークモードにする ----
# 外観は ~/Library/Application Support/Claude/config.json の "userThemeMode" キー
# （MCP 設定の claude_desktop_config.json とは別ファイル）。この JSON には OAuth トークン等の
# 秘密情報が同居するため、symlink で repo に持ち込めない（トークンが漏れる）。そこで該当キー
# だけを plutil で in-place 書き換えする。plutil は macOS 標準（依存なし）で JSON 形式を保ち、
# 他キー・トークンは保持、何度実行しても結果は同じ（冪等）。config.json はアプリ初回起動時に
# 作られるので、未起動の新規端末では存在せずスキップされる（下の手動ステップで再実行を促す）。
# ※ Claude.app 起動中に書き換えると終了時に上書きされうるため、Claude.app を終了してから
#    実行するのが安全（反映は次回起動時）。
CLAUDE_APP_CONFIG="$HOME/Library/Application Support/Claude/config.json"
if [ -f "$CLAUDE_APP_CONFIG" ]; then
  plutil -replace userThemeMode -string dark "$CLAUDE_APP_CONFIG" \
    || echo "==> Claude.app のダークモード設定に失敗（config.json が不正?）。スキップします"
fi

echo ""
echo "done. 残りの手動ステップ（ログイン資格情報は端末ローカル。repo では同期されない）:"
echo "  1. VS Code を起動し Settings Sync にログイン（設定・拡張の自動同期）"
echo "  2. gh auth login  (GitHub CLI)"
echo "  3. claude を起動してログイン（Claude Code CLI。ブラウザ OAuth → Keychain 保存）"
echo "  4. codex login  (OpenAI Codex CLI。ChatGPT アカウント。README「OpenAI Codex CLI」参照)"
echo "  5. Overleaf プロジェクトを clone:"
echo "     git clone https://git.overleaf.com/<projectId>"
echo "     （トークンは Overleaf Account Settings → Git integration tokens）"
echo "  6. Claude.app を初回起動していない場合、ダークモードは未適用。起動後に install.sh を"
echo "     再実行するか、Claude.app の Settings → Appearance → Dark で設定する"
