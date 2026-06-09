#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"command"[[:space:]]*:[[:space:]]*"//; s/"$//')

case "$COMMAND" in
  *"git commit"*|*"git push"*) ;;
  *) exit 0 ;;
esac

EXPECTED_FILE="${CLAUDE_PROJECT_DIR:-$PWD}/.jtgp-identity"
if [ ! -f "$EXPECTED_FILE" ]; then
  exit 0
fi

EXPECTED_EMAIL=$(grep '^email=' "$EXPECTED_FILE" | head -1 | cut -d= -f2- | tr -d '[:space:]')
if [ -z "$EXPECTED_EMAIL" ]; then
  exit 0
fi

CURRENT_EMAIL=$(git config user.email 2>/dev/null | tr -d '[:space:]' || echo "")

if [ "$CURRENT_EMAIL" != "$EXPECTED_EMAIL" ]; then
  cat <<EOF
{
  "decision": "block",
  "reason": "Git identity mismatch. Expected '$EXPECTED_EMAIL' (from .jtgp-identity) but git is configured with '$CURRENT_EMAIL'. Set the correct identity for this repo before committing: git config user.email '$EXPECTED_EMAIL'"
}
EOF
  exit 0
fi

exit 0
