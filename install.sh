#!/usr/bin/env bash
#
# 新しい Mac のセットアップスクリプト（冪等：何度実行しても安全）
#
# 使い方:
#   xcode-select --install   # 事前に一度だけ
#   git clone https://github.com/<you>/dotfiles.git ~/dotfiles
#   ~/dotfiles/install.sh
#
set -euo pipefail

# $0 は「実行時に指定されたこのスクリプト自身のパス」（例: ~/dotfiles/install.sh）。
# dirname はパスからファイル名を除いた親ディレクトリを返す（例: ~/dotfiles）。
# つまりこの行は「スクリプトが置かれているディレクトリに移動」という意味。
# これにより、どのディレクトリから実行しても Brewfile 等への相対パスが正しく解決される。
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
fi

# ---- 5. VS Code settings（存在しない場合のみ配置。Settings Sync が優先）----
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
for f in settings.json keybindings.json; do
  if [ ! -f "$VSCODE_USER/$f" ] && [ -f "vscode/$f" ]; then
    echo "==> Placing vscode/$f"
    cp "vscode/$f" "$VSCODE_USER/$f"
  fi
done

# ---- 6. git ----
git config --global credential.helper osxkeychain

# ---- 7. Claude Code: グローバル CLAUDE.md を symlink ----
mkdir -p "$HOME/.claude"
if [ -f "$HOME/.claude/CLAUDE.md" ] && [ ! -L "$HOME/.claude/CLAUDE.md" ]; then
  echo "==> Backing up existing ~/.claude/CLAUDE.md -> CLAUDE.md.bak"
  mv "$HOME/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md.bak"
fi
ln -sfn "$PWD/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# ---- 8. zsh 設定を symlink ----
for pair in "zsh/zshrc:.zshrc" "zsh/zprofile:.zprofile"; do
  src="${pair%%:*}"; dst="${pair##*:}"
  if [ -f "$HOME/$dst" ] && [ ! -L "$HOME/$dst" ]; then
    echo "==> Backing up existing ~/$dst -> $dst.bak"
    mv "$HOME/$dst" "$HOME/$dst.bak"
  fi
  ln -sfn "$PWD/$src" "$HOME/$dst"
done

echo ""
echo "done. 残りの手動ステップ:"
echo "  1. VS Code を起動し Settings Sync にログイン（設定・拡張の自動同期）"
echo "  2. gh auth login  (GitHub CLI)"
echo "  3. Overleaf プロジェクトを clone:"
echo "     git clone https://git.overleaf.com/<projectId>"
echo "     （トークンは Overleaf Account Settings → Git integration tokens）"
