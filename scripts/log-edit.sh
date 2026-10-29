#!/bin/bash
# PostToolUse フック：Write / Edit のあとに呼ばれ、編集したファイルのパスをログに残す。
# フックの入力は JSON で標準入力に届く。

log_file="${TMPDIR:-/tmp}/my-plugin-edits.log"

file_path=$(jq -r '.tool_input.file_path // empty')

if [ -n "$file_path" ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') $file_path" >> "$log_file"
fi

exit 0
