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

# ---- 7. Claude Code: グローバル CLAUDE.md / skills を symlink ----
mkdir -p "$HOME/.claude"
if [ -f "$HOME/.claude/CLAUDE.md" ] && [ ! -L "$HOME/.claude/CLAUDE.md" ]; then
  echo "==> Backing up existing ~/.claude/CLAUDE.md -> CLAUDE.md.bak"
  mv "$HOME/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md.bak"
fi
ln -sfn "$PWD/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
if [ -d "$HOME/.claude/skills" ] && [ ! -L "$HOME/.claude/skills" ]; then
  echo "==> Backing up existing ~/.claude/skills -> skills.bak"
  mv "$HOME/.claude/skills" "$HOME/.claude/skills.bak"
fi
ln -sfn "$PWD/claude/skills" "$HOME/.claude/skills"

# ---- 8. zsh 設定を symlink ----
for pair in "zsh/zshrc:.zshrc" "zsh/zprofile:.zprofile"; do
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

echo ""
echo "done. 残りの手動ステップ:"
echo "  1. VS Code を起動し Settings Sync にログイン（設定・拡張の自動同期）"
echo "  2. gh auth login  (GitHub CLI)"
echo "  3. Overleaf プロジェクトを clone:"
echo "     git clone https://git.overleaf.com/<projectId>"
echo "     （トークンは Overleaf Account Settings → Git integration tokens）"
