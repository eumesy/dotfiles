#!/usr/bin/env bash
#
# MANUAL_STEPS.tsv（手動ステップの SSOT）から README の生成ブロックを作る。
#
# README の以下 2 行のマーカーに挟まれた領域を、TSV から生成した番号つきリストで
# 置き換える（マーカー自体は残す）:
#   <!-- MANUAL_STEPS:BEGIN ... -->
#   <!-- MANUAL_STEPS:END -->
# install.sh 側は同じ TSV の action 列を実行時に直接描画するので、ここでは扱わない。
#
# 使い方:
#   scripts/gen-manual-steps.sh          # README を書き換える（in-place）
#   scripts/gen-manual-steps.sh --check  # README が TSV と同期していなければ非 0 で終了
#                                        # （ファイルは変更しない）
#
# 検査対象は既定で作業ツリーの MANUAL_STEPS.tsv / README.md。pre-commit hook は
# index（staged 内容）で検査したいので、環境変数 MANUAL_STEPS_TSV / MANUAL_STEPS_README
# に一時ファイルのパスを渡して対象を差し替える。
#
# 依存: bash・sed・diff・mktemp（いずれも macOS 標準）。
set -euo pipefail
cd "$(dirname "$0")/.."

TSV="${MANUAL_STEPS_TSV:-MANUAL_STEPS.tsv}"
README="${MANUAL_STEPS_README:-README.md}"
BEGIN='<!-- MANUAL_STEPS:BEGIN'
END='<!-- MANUAL_STEPS:END'

check_mode=0
[ "${1:-}" = "--check" ] && check_mode=1

# マーカーがちょうど 1 つずつ、かつ BEGIN が END より前にあることを確認する
if [ "$(grep -c "$BEGIN" "$README")" != 1 ] || [ "$(grep -c "$END" "$README")" != 1 ]; then
  echo "ERROR: $README に MANUAL_STEPS の BEGIN/END マーカーが 1 つずつ必要です" >&2
  exit 2
fi
begin_ln="$(grep -n "$BEGIN" "$README" | cut -d: -f1)"
end_ln="$(grep -n "$END" "$README" | cut -d: -f1)"
if [ "$begin_ln" -ge "$end_ln" ]; then
  echo "ERROR: $README の BEGIN マーカーが END より後ろにあります" >&2
  exit 2
fi

# TSV から番号つき Markdown リストを生成する（前後に空行を入れて Markdown として確実に描画させる）
render_block() {
  echo ""
  local n=0 action detail
  while IFS=$'\t' read -r action detail || [ -n "$action" ]; do
    case "$action" in ''|'#'*) continue ;; esac
    n=$((n + 1))
    if [ -n "${detail:-}" ]; then
      printf '%d. %s（詳細: 本 README「%s」節）\n' "$n" "$action" "$detail"
    else
      printf '%d. %s\n' "$n" "$action"
    fi
  done < "$TSV"
  echo ""
}

# BEGIN マーカー行までの前半 + 生成ブロック + END マーカー行からの後半 を結合する
build() {
  sed -n "1,/$BEGIN/p" "$README"
  render_block
  sed -n "/$END/,\$p" "$README"
}

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
build > "$tmp"

if [ "$check_mode" -eq 1 ]; then
  if ! diff -q "$tmp" "$README" >/dev/null; then
    echo "NG: $README が $TSV と同期していません。scripts/gen-manual-steps.sh を実行してください" >&2
    exit 1
  fi
  echo "OK: $README は $TSV と同期しています"
else
  cat "$tmp" > "$README"
  echo "generated: $README の手動ステップブロックを $TSV から再生成しました"
fi
