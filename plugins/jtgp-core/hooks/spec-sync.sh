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
  */SPEC.md|*/CONTEXT.md|*/PLAN.md|*/VERIFICATION.md) exit 0 ;;
  */.jtgp/*) exit 0 ;;
esac

case "$FILE_PATH" in
  *.java|*.ts|*.tsx|*.js|*.jsx|*.py|*.go|*.rs|*.kt|*.rb|*.cs|*.sql) ;;
  *) exit 0 ;;
esac

printf '%s\n' '{"systemMessage":"Source file changed. Spec-anchored reminder: if this change diverges from the plan or alters behavior described in the spec, update the SPEC.md and CONTEXT.md so the living spec stays the source of truth."}'
exit 0
