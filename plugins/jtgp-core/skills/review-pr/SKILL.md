---
name: review-pr
description: Review a colleague's pull/merge request against engagement conventions and quality standards, producing a ready-to-post comment. Runs in an isolated worktree. Auto-invoke when the user says "review PR", "code review", or pastes a PR/MR URL or number.
---

# Skill: review-pr

## Preconditions

Read `.jtgp/config.json`.
PR tool: `pr_tool`. Language for review output: `lang_pr_review`.

## Isolation

Check out the PR into an isolated temporary worktree. Never review from an active issue's worktree. Discard the worktree after review.

## Fetch the PR

- If `pr_tool` is `gh`: `gh pr diff {N} --repo {issue_tracker_project}`
- If `pr_tool` is `glab`: `glab mr diff {N} --repo {issue_tracker_project}`
- Also fetch the PR description, existing review comments, and CI status.

## What to check

Dispatch the `critic` agent against the diff with these lenses:
- **Conventions** — does it follow the engagement's documented standards?
- **Correctness** — logic errors, null handling, concurrency, edge cases.
- **Bad smells** — duplication, leaky abstractions, dead code, YAGNI violations.
- **Tests** — do they exist, are they meaningful, are any redundant?
- **Evidence** — does the PR show it was tested, not just written?
- **Breaking changes** — API, schema, or contract impacts.

## Verdict

- **PASS** — approve, no required changes.
- **CONCERNS** — approve with suggestions; non-blocking items listed.
- **FAIL** — request changes; blocking items listed.
- **WAIVED** — a noted issue the author has justified; acknowledge and approve.

## Output

Produce a single, well-structured review comment in `lang_pr_review`.
Order: blocking → major → minor.
Each finding specific and actionable (file and line where possible).
Lead with the verdict.

Do not post the review. Hand it to the user to post — posting is always a human action.
