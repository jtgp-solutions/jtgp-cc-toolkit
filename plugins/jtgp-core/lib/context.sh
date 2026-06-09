#!/usr/bin/env bash
# lib/context.sh
# Source this file to load the engagement config into environment variables.
# Usage: source "$(dirname "$0")/../lib/context.sh" || exit 1

CONFIG_FILE="$(pwd)/.jtgp/config.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: No engagement config found at .jtgp/config.json"
  echo "Run /jtgp:setup to configure this engagement first."
  exit 1
fi

_jtgp_get() {
  python3 -c "
import json, sys
try:
    with open('$CONFIG_FILE') as f:
        cfg = json.load(f)
    keys = '$1'.split('.')
    val = cfg
    for k in keys:
        val = val[k]
    print(val if val is not None else '')
except (KeyError, TypeError):
    print('')
except Exception as e:
    print('', file=sys.stderr)
" 2>/dev/null
}

export JTGP_ENGAGEMENT=$(_jtgp_get engagement)
export JTGP_GIT_EMAIL=$(_jtgp_get git_email)

export JTGP_ISSUE_TRACKER=$(_jtgp_get issue_tracker)
export JTGP_ISSUE_TRACKER_URL=$(_jtgp_get issue_tracker_url)
export JTGP_ISSUE_TRACKER_PROJECT=$(_jtgp_get issue_tracker_project)
export JTGP_ISSUE_PREFIXES=$(_jtgp_get issue_prefixes)

export JTGP_KB_PROVIDER=$(_jtgp_get kb_provider)
export JTGP_KB_SPACE_ID=$(_jtgp_get kb_space_id)
export JTGP_KB_SYNC_ON_START=$(_jtgp_get kb_sync_on_start)
export JTGP_KB_SYNC_ON_CLOSE=$(_jtgp_get kb_sync_on_close)

export JTGP_PR_TOOL=$(_jtgp_get pr_tool)
export JTGP_PR_BASE_BRANCH=$(_jtgp_get pr_base_branch)

export JTGP_SPECS_ROOT=$(_jtgp_get specs_root)
export JTGP_TASKS_ROOT=$(_jtgp_get tasks_root)
export JTGP_WORKTREES_ROOT=$(_jtgp_get worktrees_root)

export JTGP_LANG_CODE=$(_jtgp_get lang_code)
export JTGP_LANG_DOCS=$(_jtgp_get lang_docs)
export JTGP_LANG_TERMINAL=$(_jtgp_get lang_terminal)
export JTGP_LANG_COMMIT=$(_jtgp_get lang_commit_messages)
export JTGP_LANG_PR_DESC=$(_jtgp_get lang_pr_description)
export JTGP_LANG_PR_REVIEW=$(_jtgp_get lang_pr_review)

export JTGP_CODE_NO_COMMENTS=$(_jtgp_get code_no_comments)
export JTGP_CODE_STYLE=$(_jtgp_get code_style)
export JTGP_TEST_FRAMEWORK=$(_jtgp_get test_framework)
export JTGP_BUILD_TOOL=$(_jtgp_get build_tool)
export JTGP_BRANCH_PATTERN=$(_jtgp_get branch_pattern)
export JTGP_COMMIT_CONVENTION=$(_jtgp_get commit_convention)
