---
name: review-pr
description: Review a colleague's pull request against project conventions and quality standards, producing a ready-to-paste comment. Runs in an isolated worktree so it never contaminates active issue work. Auto-invoke when the user says "review PR", "revisar PR", "code review", or pastes a PR URL.
---

# Skill: review-pr

You review someone else's PR. Your output is a comment the user can paste into the PR, plus a clear verdict. You do not modify the PR's code.

## Isolation

Check out the PR into an isolated, temporary worktree. Never review from an active issue's worktree — contamination of branches is a hard failure. Discard the worktree when done.

## What to check

Load the project's conventions and rules. Dispatch the `critic` agent against the PR diff with these lenses:

- **Conventions** — does it follow the project's documented standards?
- **Correctness** — logic errors, off-by-one, null handling, concurrency.
- **Bad smells** — duplication, leaky abstractions, dead code, speculative generality (YAGNI).
- **Edge cases** — what inputs or states are unhandled?
- **Breaking changes** — API, schema, contract impacts.
- **Tests** — do they exist, are they meaningful, are any redundant or mergeable?
- **Evidence** — does the PR description show it was actually run, not just written?

## Verdict

Classify with the same four-level gate:
- **PASS** — approve, no required changes.
- **CONCERNS** — approve with suggestions; list non-blocking items.
- **FAIL** — request changes; list blocking items with specifics.
- **WAIVED** — a noted issue the author has justified; acknowledge and approve.

## Output

Produce a single, well-structured review comment in the project's language, ordered blocking → major → minor, each finding specific and actionable (file and line where possible). Lead with the verdict. Keep it respectful and direct. Do not pad with praise that isn't earned, but acknowledge genuinely good solutions briefly.

Do not post the comment. Hand it to the user to post. Posting and approving/rejecting are always the user's action.
