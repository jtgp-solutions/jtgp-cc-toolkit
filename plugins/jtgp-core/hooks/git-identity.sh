#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    cmd = data.get('tool_input', {}).get('command', '')
    print(cmd)
except:
    print('')
" 2>/dev/null || echo "")

case "$COMMAND" in
  *"git commit"*|*"git push"*) ;;
  *) exit 0 ;;
esac

CONFIG_FILE="$(pwd)/.jtgp/config.json"
if [ ! -f "$CONFIG_FILE" ]; then
  exit 0
fi

EXPECTED_EMAIL=$(python3 -c "
import json
try:
    with open('$CONFIG_FILE') as f:
        cfg = json.load(f)
    print(cfg.get('git_email', ''))
except:
    print('')
" 2>/dev/null || echo "")

if [ -z "$EXPECTED_EMAIL" ]; then
  exit 0
fi

CURRENT_EMAIL=$(git config user.email 2>/dev/null | tr -d '[:space:]' || echo "")

if [ "$CURRENT_EMAIL" != "$EXPECTED_EMAIL" ]; then
  python3 -c "
import json
print(json.dumps({
    'decision': 'block',
    'reason': f'Git identity mismatch. Expected: $EXPECTED_EMAIL (from .jtgp/config.json). Current: $CURRENT_EMAIL. Fix with: git config user.email $EXPECTED_EMAIL'
}))
"
fi

exit 0
