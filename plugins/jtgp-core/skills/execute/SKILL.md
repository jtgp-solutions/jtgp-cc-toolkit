---
name: execute
description: Autonomously implement an approved, hardened plan. Plan-to-bypass handoff — runs implementation, tests, and self-review without stopping for per-step confirmation, halting only at the PR boundary. Auto-invoke when the user says "execute" or "build it" on an issue with an approved plan.
---

# Skill: execute

## Preconditions

Read `.jtgp/config.json`. Read PLAN.md and CONTEXT.md.
CONTEXT.md status must be `plan-approved`. If not, redirect to `/jtgp:critique {ISSUE-ID}`.

Language for code: `lang_code`.
Language for terminal: `lang_terminal`.
Language for commit messages: `lang_commit_messages`.
No-comments rule: `code_no_comments` — if true, code carries zero inline comments.
Test framework: `test_framework`.
Build tool: `build_tool`.
Branch pattern: `branch_pattern`.
Commit convention: `commit_convention`.

## Worktree setup

Create a worktree named for the issue under `{worktrees_root}/{ISSUE-ID}/` using the branch pattern from config. Never implement from a branch belonging to another issue.

## Implementation rules

- Implement p0 and p1 items only. p2 requires explicit opt-in.
- Code identifiers, class names, method names: `lang_code`.
- Zero inline comments if `code_no_comments` is true.
- Use TodoWrite to track each phase.
- Delegate implementation to `developer` agent. Delegate tests to `tester` agent. Run both in parallel when the signature is stable.
- After each phase, update CONTEXT.md.

## Self-review before declaring done

1. Dispatch `critic` against the actual diff — not the plan.
2. Dispatch `tester` to confirm p0/p1 edge case coverage.
3. Address blocking and major findings. Log minor ones.

## Keep the spec alive

Update `SPEC.md` wherever the implementation diverged from the original. The spec must always describe the real, current state.

## Commit

Use `commit_convention` format. Language: `lang_commit_messages`.
The commit message must not mention Claude, AI, or any AI tool.

## Stop at PR boundary

Do not open the PR. Set CONTEXT.md status to `awaiting-verification`.

Before any `gh` command (push, pr create, pr view), if `gh_user` is set in config:
```bash
gh auth switch --user {gh_user}
```
This ensures the correct GitHub account is active for this engagement, regardless of what other sessions may have switched to.

Report phases completed, files changed, test results.
Direct the user to `/jtgp:verify {ISSUE-ID}`.
