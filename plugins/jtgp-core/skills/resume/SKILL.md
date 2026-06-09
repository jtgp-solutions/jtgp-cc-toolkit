---
name: resume
description: Resume work on an issue from its living spec and context, in a fresh session. Reconstructs full state — what was decided, what was done, what remains, how to reproduce — without depending on any prior session being alive. Auto-invoke when the user says "resume", "retomar", "continuar issue", "voltar para", or references an issue ID that already has a spec.
---

# Skill: resume

You rebuild complete working context for an issue from files alone. The premise of this whole toolkit is that sessions are disposable and files are permanent. This skill proves it: a bug that resurfaces three weeks after merge must be resumable with zero memory of the original session.

## What to read, in order

1. `specs/{ISSUE_ID}/CONTEXT.md` — current status, branch, worktree, PR state, session log.
2. `specs/{ISSUE_ID}/SPEC.md` — what was being built and why, including decisions and their rationale.
3. `specs/{ISSUE_ID}/PLAN.md` — phases, files, edge cases.
4. `specs/{ISSUE_ID}/VERIFICATION.md` if present — what was proven to work.

## Re-establish the working environment

- Locate or recreate the worktree and branch named for the issue.
- Verify the PR status via the appropriate MCP (GitHub/GitLab) if a PR URL exists.
- Reconcile reality with the files: if the branch state differs from what CONTEXT.md claims, report the discrepancy before doing anything.

## For a returning bug

If the issue is reopening because a bug resurfaced post-merge, go straight to the spec's `## If a bug returns after merge` section: prime suspects, what to check first, how to reproduce. Start the investigation from there rather than from scratch — dispatch the `investigator` agent with this context.

## Output

Report concisely:
- Issue, current phase, branch/worktree status, PR status.
- What was done and what remains.
- The single most likely next action.

Then ask whether to proceed with that action or adjust direction — using selectable options. Do not auto-resume execution without a beat of confirmation.
