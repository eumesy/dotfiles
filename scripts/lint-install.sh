#!/usr/bin/env bash
#
# install.sh の冪等性 lint（静的チェック）
#
# 「何度実行しても安全」を証明するものではなく、非冪等になりがちな
# 書き方を機械的に検出するヒューリスティック。ステップを追加・変更したら、
# これに加えて「2 回目の実行で何が起こるか」を必ず確認すること。
#
# 使い方:
#   scripts/lint-install.sh
#   （install.sh をコミットする際は pre-commit hook からも自動実行される）
set -euo pipefail
cd "$(dirname "$0")/.."

target=install.sh
fail=0

# コメント行を除いた実行行を、行番号付きで取り出す
lines() { grep -n '' "$target" | grep -vE '^[0-9]+:[[:space:]]*#'; }

check() { # check <説明> <検出行>
  local desc=$1 hits=$2
  if [ -n "$hits" ]; then
    echo "NG: $desc"
    echo "$hits" | sed 's/^/      /'
    fail=1
  fi
}

check "『>>』による追記は冪等でない（実行ごとに内容が増える）" \
  "$(lines | grep -E '>>' || true)"

check "『ln -s』は『ln -sfn』にする（-f なしは 2 回目に失敗する）。guard 付きで使う場合は同一行に『||』で書く" \
  "$(lines | grep -E 'ln -s' | grep -v 'ln -sfn' | grep -vE '\|\|' || true)"

check "『mkdir』は『mkdir -p』にする（既存ディレクトリで失敗しないように）" \
  "$(lines | grep -E '\bmkdir\b' | grep -v -- '-p' || true)"

check "『mv』は存在 guard 付きの .bak バックアップ以外で使わない（2 回目に元ファイルが無い）" \
  "$(lines | grep -E '\bmv\b' | grep -v '\.bak' || true)"

check "パッケージは install.sh に直接書かず Brewfile に追加する" \
  "$(lines | grep -E '\bbrew (install|tap)\b' || true)"

if ! grep -q 'set -euo pipefail' "$target"; then
  echo "NG: set -euo pipefail が無い"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "OK: $target は冪等性 lint をパス"
else
  echo ""
  echo "冪等な書き方の例は $target 内の既存ステップを参照。"
  exit 1
fi
