#!/bin/bash
# PreToolUse フック：Bash を実行する前に呼ばれ、危ないコマンドなら止める。
# exit 2 で終わると実行が止まり、標準エラーの内容が理由として Claude に返る。

command=$(jq -r '.tool_input.command // empty')

# コマンドの区切り（行頭・空白・; & | ( ）のあとに続くかで判定する
start='(^|[;&|([:space:]])'

block() {
  echo "my-plugin: このコマンドは止めました（$1）。必要ならユーザーに確認し、ユーザー自身に実行してもらってください。" >&2
  exit 2
}

check() {
  if echo "$command" | grep -Eq -- "$1"; then
    block "$2"
  fi
}

check "${start}(sudo[[:space:]]+)?(rm|rmdir)[[:space:]]" "ファイルの削除"
check "${start}find[[:space:]].*-delete" "find -delete による削除"
check "${start}git[[:space:]]+clean([[:space:]]|$)" "git clean による削除"
check "${start}git[[:space:]]+reset[[:space:]]+--hard" "git reset --hard による変更の破棄"
check "${start}git[[:space:]]+push([[:space:]].*)?[[:space:]](--force|-f)([[:space:]]|$)" "git push の強制上書き"
check "(curl|wget)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(ba|z)?sh" "ダウンロードしたスクリプトをそのまま実行"
check "${start}dd[[:space:]].*of=/dev/" "デバイスへの直接書き込み"
check "${start}mkfs" "ディスクのフォーマット"
check "${start}chmod[[:space:]]+-R[[:space:]]+777" "権限を全開にする変更"

exit 0
