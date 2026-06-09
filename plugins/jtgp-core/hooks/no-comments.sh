#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(printf '%s' "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//; s/"$//')

case "$FILE_PATH" in
  *.java|*.ts|*.tsx|*.js|*.jsx|*.py|*.go|*.rs|*.kt) ;;
  *) exit 0 ;;
esac

CONTENT=$(printf '%s' "$INPUT" | grep -o '"new_string"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 || true)
if [ -z "$CONTENT" ]; then
  CONTENT=$(printf '%s' "$INPUT" | grep -o '"content"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 || true)
fi

if printf '%s' "$CONTENT" | grep -qE '(//[^\"]|/\*|\*/|[^:]#[[:space:]])'; then
  cat <<'EOF'
{
  "decision": "ask",
  "reason": "This edit appears to introduce code comments. Project standard is no comments in code unless a public-interface documentation standard requires it. Confirm this comment is required (e.g. Javadoc on a public API) before proceeding."
}
EOF
  exit 0
fi

exit 0
