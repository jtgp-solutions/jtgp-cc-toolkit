#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(printf '%s' "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    ti = data.get('tool_input', {})
    print(ti.get('file_path', ti.get('path', '')))
except:
    print('')
" 2>/dev/null || echo "")

case "$FILE_PATH" in
  *.java|*.ts|*.tsx|*.js|*.jsx|*.py|*.go|*.rs|*.kt|*.rb|*.cs) ;;
  *) exit 0 ;;
esac

CONFIG_FILE="$(pwd)/.jtgp/config.json"
NO_COMMENTS="true"
if [ -f "$CONFIG_FILE" ]; then
  NO_COMMENTS=$(python3 -c "
import json
try:
    with open('$CONFIG_FILE') as f:
        cfg = json.load(f)
    print(str(cfg.get('code_no_comments', True)).lower())
except:
    print('true')
" 2>/dev/null || echo "true")
fi

if [ "$NO_COMMENTS" != "true" ]; then
  exit 0
fi

HAS_COMMENT=$(printf '%s' "$INPUT" | python3 -c "
import sys, json, re

try:
    data = json.load(sys.stdin)
except:
    sys.exit(0)

ti = data.get('tool_input', {})
content = ti.get('new_string', ti.get('content', ti.get('new_content', '')))
if not content:
    sys.exit(0)

patterns = [
    r'(?m)^\s*//',
    r'/\*(?!\s*@)',
    r'(?m)^\s*#\s',
]

for p in patterns:
    if re.search(p, content):
        print('yes')
        sys.exit(0)
" 2>/dev/null || echo "")

if [ "$HAS_COMMENT" = "yes" ]; then
  printf '%s\n' '{"decision":"ask","reason":"This edit appears to introduce inline code comments. The engagement is configured with code_no_comments: true. Confirm this comment is required (e.g. a mandatory doc annotation) before proceeding."}'
fi

exit 0
