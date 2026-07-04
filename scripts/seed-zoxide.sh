#!/usr/bin/env bash
#
# zoxide のディレクトリ DB への種まきスクリプト（冪等：何度実行しても安全）
#
# 処理の流れ:
#   1. zsh のコマンド履歴 (~/.zsh_history, ~/.zsh_sessions/*.history) から
#      `cd <path>` の引数を抽出し、現存するディレクトリを zoxide add で登録
#   2. ghq 管理下の全リポジトリ (ghq list --full-path) を zoxide add で登録
#
# 依存: zoxide, ghq（どちらも Brewfile 経由でインストール済み）
# 使い方: ~/dotfiles/scripts/seed-zoxide.sh
#
set -euo pipefail

# ---- CONFIG ----
HISTORY_GLOBS=("$HOME/.zsh_history" "$HOME"/.zsh_sessions/*.history)

# 履歴中の cd 引数を絶対パスに解決する（当時の cwd は不明なので相対パスは $HOME 起点とみなす）
resolve() {
  local d="$1"
  case "$d" in
    /*)    echo "$d" ;;
    "~")   echo "$HOME" ;;
    "~/"*) echo "$HOME/${d#\~/}" ;;
    *)     echo "$HOME/$d" ;;
  esac
}

# ---- 1. 履歴の cd 引数から ----
added=0
while IFS= read -r raw; do
  # cd - や .. を含むパスは対象外（解決結果が信頼できないため）
  case "$raw" in ""|-|*..*) continue ;; esac
  dir="$(resolve "$raw")"
  if [ -d "$dir" ]; then
    zoxide add "$dir"
    added=$((added + 1))
  fi
done < <(grep -hE '(^|;)cd ' "${HISTORY_GLOBS[@]}" 2>/dev/null \
  | sed -E 's/^(: [0-9]+:[0-9]+;)?cd +//' \
  | sed -E 's/[ ;&|].*$//' \
  | sort -u)
echo "==> zsh 履歴から ${added} 件登録"

# ---- 2. ghq リポジトリから ----
count=0
while IFS= read -r repo; do
  zoxide add "$repo"
  count=$((count + 1))
done < <(ghq list --full-path)
echo "==> ghq リポジトリから ${count} 件登録"

echo "done. 確認するには: zoxide query --list | head"
