#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(printf '%s' "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//; s/"$//')

case "$FILE_PATH" in
  */specs/*|*SPEC.md|*CONTEXT.md|*PLAN.md|*VERIFICATION.md) exit 0 ;;
esac

case "$FILE_PATH" in
  *.java|*.ts|*.tsx|*.js|*.jsx|*.py|*.go|*.rs|*.kt|*.sql) ;;
  *) exit 0 ;;
esac

cat <<'EOF'
{
  "systemMessage": "Source file changed. Spec-anchored reminder: if this change diverges from the plan or alters behavior described in the spec, update specs/{ISSUE_ID}/SPEC.md and CONTEXT.md so the living spec stays the source of truth."
}
EOF
exit 0
