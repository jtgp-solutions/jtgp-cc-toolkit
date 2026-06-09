---
name: resume
description: Resume work on an issue from its living spec and context in a fresh session. Reconstructs full state from files alone — no prior session memory needed. Handles both specs_root and tasks_root locations. Auto-invoke when the user says "resume", "continue", or references an issue ID that already has a spec.
---

# Skill: resume

## Preconditions

Read `.jtgp/config.json`. Language for terminal: `lang_terminal`.

## Locate the issue context

Search in this order:
1. `{specs_root}/{ISSUE-ID}/CONTEXT.md`
2. `{specs_root}/` — glob for any folder matching `*{ISSUE-ID}*`
3. `{tasks_root}/{ISSUE-ID}/` — if tasks_root is configured
4. `{tasks_root}/` — glob for any folder matching `*{ISSUE-ID}*`

If found in multiple locations, load both and reconcile — the most recently updated file wins on status.

## What to read, in order

1. `CONTEXT.md` — current status, branch, worktree, PR state, session log
2. `SPEC.md` — what was built and why, decisions, rationale
3. `PLAN.md` — phases, files, edge cases
4. `VERIFICATION.md` — what was proven to work (if exists)
5. If `tasks_root` is set: any evidence or context files there for this issue

## Re-establish the working environment

- Locate or recreate the worktree and branch.
- Verify PR status via the configured PR tool if a PR URL exists.
- Reconcile reality with the files: if branch state differs from CONTEXT.md, report the discrepancy.

## For a returning bug

If the issue is reopening post-merge, go to the spec's `## If a bug returns after merge` section: prime suspects, what to check first, how to reproduce. Dispatch the `investigator` agent with this context.

## KB sync on resume

If `kb_sync_on_start` is true and a KB provider is configured:
- Check if the KB has a more recent version of the spec than the local file.
- If so, show the diff and ask whether to pull the remote version.

## Output

Report concisely (in `lang_terminal`):
- Issue, current phase, branch/worktree status, PR status.
- What was done and what remains.
- Single most likely next action.

Ask whether to proceed with that action or adjust direction — using selectable options. Do not auto-execute without confirmation.
