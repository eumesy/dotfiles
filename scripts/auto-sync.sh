#!/usr/bin/env bash
#
# dotfiles / eumesy-claude リポジトリの自動同期スクリプト
#
# 背景:
#   全端末が常時電源オンの複数 Mac 運用では「端末を使い始めるタイミング」が無いため、
#   launchd（macos/com.eumesy.dotfiles-auto-sync.plist、install.sh が配置・登録）から
#   定期実行して、他端末が push した変更を自動で取り込む。
#
# 処理の流れ（リポジトリごと）:
#   1. main 以外のブランチにいる（作業中）・detached HEAD の場合は何もしない
#   2. fetch する。失敗（オフライン等）はログに残して静かに終了。
#      fetch はこの実行に限り ssh remote を https に読み替える（launchd 環境には
#      SSH_AUTH_SOCK が無く ssh が使えないため。public repo なので匿名 https で足りる）
#   3. rebase --autostash で upstream に追いつく（未 commit 差分は autostash が退避・復元）。
#      コンフリクトで失敗したら rebase を中止して macOS 通知を出す。
#      autostash の復元だけがコンフリクトした場合（マーカーが tree に残り、
#      同じ差分が stash にも保持される）も通知する
#   4. 人の確認が要るファイルが更新されていたら macOS 通知を出す:
#      install.sh / Brewfile → 「install.sh を再実行」、
#      settings.json / skills / CLAUDE.md → 「Claude 設定の更新。内容を確認」
#      （Claude 設定は無人反映される設計なので、事後確認の通知を必ず出す）
#
# 使い方:
#   scripts/auto-sync.sh            # CONFIG の既定リポジトリを同期
#   scripts/auto-sync.sh <path>...  # 指定したリポジトリだけ同期（既定を上書き）
#
# 依存: git・osascript（macOS 標準）。launchd から呼ばれる前提だが手動実行も可。

set -u

# launchd の最小環境でも git 等が見つかるよう PATH を明示する
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin"

# ---- CONFIG ----
# 同期対象リポジトリ（コマンドライン引数で上書き可）
REPOS_DEFAULT=(
  "$HOME/ghq/github.com/eumesy/dotfiles"
  "$HOME/ghq/github.com/eumesy/claude"
)
# これらが更新されたら「install.sh 再実行」を通知する（repo ルートからの相対パス）
STRUCTURAL_FILES=(install.sh Brewfile)
# これらが更新されたら「Claude 設定の更新。内容を確認」を通知する
CLAUDE_CONFIG_FILES=(settings.json skills CLAUDE.md)
# 多重起動防止ロック（launchd 定期実行と手動実行の競合を防ぐ。テスト用に env で上書き可）
LOCK_DIR="${AUTO_SYNC_LOCK_DIR:-/tmp/com.eumesy.dotfiles-auto-sync.lock}"
# ----------------

log() { echo "[$(date '+%F %T')] $*" >&2; } # launchd 経由では ~/Library/Logs のログに残る

# 多重起動防止。まず取得を試み、失敗時のみ「trap が走らず残った古いロック（6 時間超）」を
# 疑って一度だけ回収を試みる（先に stale 判定すると、生きたロックを消し合うレースの窓が広がる）
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  [ -n "$(find "$LOCK_DIR" -maxdepth 0 -mmin +360 2>/dev/null)" ] || exit 0
  rmdir "$LOCK_DIR" 2>/dev/null || true
  mkdir "$LOCK_DIR" 2>/dev/null || exit 0
fi
trap 'rmdir "$LOCK_DIR" 2>/dev/null' EXIT

notify() { # $1: 通知本文
  /usr/bin/osascript -e "display notification \"$1\" with title \"dotfiles auto-sync\"" >/dev/null 2>&1 || true
}

sync_repo() { # $1: リポジトリの絶対パス
  local repo="$1"
  [ -e "$repo/.git" ] || return 0
  # 作業ブランチ中・detached HEAD の作業ツリーには触らない
  [ "$(git -C "$repo" branch --show-current 2>/dev/null)" = "main" ] || return 0
  # fetch 失敗（オフライン等）はログに残して静かにスキップ
  if ! git -C "$repo" -c url.https://github.com/.insteadOf=git@github.com: fetch --quiet; then
    log "$repo: fetch failed（オフライン?）"
    return 0
  fi
  # upstream 未設定は「更新なし」と区別してログに残す（永久に同期されない誤設定の検知）
  if ! git -C "$repo" rev-parse -q --verify '@{u}' >/dev/null 2>&1; then
    log "$repo: main に upstream が未設定のためスキップ"
    return 0
  fi
  # 取り込むものが無ければ終了
  [ "$(git -C "$repo" rev-list --count 'HEAD..@{u}')" -gt 0 ] || return 0

  local before stash_before stash_after
  before="$(git -C "$repo" rev-parse HEAD)"
  stash_before="$(git -C "$repo" rev-parse -q --verify refs/stash 2>/dev/null || echo none)"
  # fetch 済みなので、ネットワークを使わず upstream へ rebase で追いつく
  if ! git -C "$repo" rebase --autostash --quiet '@{u}' >/dev/null 2>&1; then
    git -C "$repo" rebase --abort >/dev/null 2>&1 || true
    log "$repo: rebase failed"
    notify "pull が失敗しました（コンフリクトの可能性）。git -C $repo status を確認してください"
    return 0
  fi
  # rebase 成功後、autostash の復元だけがコンフリクトすることがある。このとき git は
  # working tree にコンフリクトマーカーを残し、同じ差分を stash にも保持する（実機確認済み）
  stash_after="$(git -C "$repo" rev-parse -q --verify refs/stash 2>/dev/null || echo none)"
  if [ "$stash_after" != "$stash_before" ]; then
    notify "未 commit 差分の復元がコンフリクトしています。git -C $repo status で解消し、解消後に git stash drop してください"
  fi
  if ! git -C "$repo" diff --quiet "$before" HEAD -- "${STRUCTURAL_FILES[@]}" 2>/dev/null; then
    notify "$(basename "$repo"): 構成が変わる更新を取り込みました。install.sh を再実行してください"
  fi
  if ! git -C "$repo" diff --quiet "$before" HEAD -- "${CLAUDE_CONFIG_FILES[@]}" 2>/dev/null; then
    notify "$(basename "$repo"): Claude 設定の更新を取り込みました。git -C $repo log で内容を確認してください"
  fi
}

repos=("${REPOS_DEFAULT[@]}")
[ "$#" -gt 0 ] && repos=("$@")
for r in "${repos[@]}"; do
  sync_repo "$r"
done
