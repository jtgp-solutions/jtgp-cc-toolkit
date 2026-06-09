#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(printf '%s' "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('file_path', data.get('path', '')))
except Exception:
    print('')
" 2>/dev/null || echo "")

case "$FILE_PATH" in
  *.java|*.ts|*.tsx|*.js|*.jsx|*.py|*.go|*.rs|*.kt) ;;
  *) exit 0 ;;
esac

HAS_COMMENT=$(printf '%s' "$INPUT" | python3 -c "
import sys, json, re

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

content = data.get('new_string', data.get('content', data.get('new_content', '')))
if not content:
    sys.exit(0)

file_path = data.get('file_path', data.get('path', ''))

patterns = [
    r'(?m)^\s*//',
    r'/\*(?!\s*@)',
    r'(?m)^\s*#\s',
]

for p in patterns:
    if re.search(p, content):
        print('yes')
        sys.exit(0)

sys.exit(0)
" 2>/dev/null || echo "")

if [ "$HAS_COMMENT" = "yes" ]; then
  printf '%s\n' '{"decision":"ask","reason":"This edit appears to introduce code comments. Project standard is no comments in code unless a public-interface documentation standard requires it. Confirm this comment is required (e.g. Javadoc on a public API) before proceeding."}'
fi

exit 0
