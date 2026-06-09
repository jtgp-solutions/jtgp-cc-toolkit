---
name: verify
description: Verification gate requiring fresh runtime evidence before PR. Dispatches the quality-gate agent which assigns PASS / CONCERNS / FAIL / WAIVED. Never accepts "should work" — demands proof of actual execution. Auto-invoke after execution completes.
---

# Skill: verify

## Preconditions

Read `.jtgp/config.json`.
Read CONTEXT.md (status should be `awaiting-verification`) and PLAN.md.

Language for verification report: `lang_docs`.
Language for terminal messages: `lang_terminal`.
Build tool from config: used to run the test suite.

## Evidence requirement

For every p0 and p1 acceptance item, require fresh runtime evidence:
- Tests actually run with output captured.
- The relevant code path exercised — a real request/response, log line, or command output.
- If the issue was a bug fix, the original reproduction no longer reproduces.

"Should work" is not evidence.

## Quality gate

Dispatch the `quality-gate` agent. It assigns:
- **PASS** — all p0/p1 items evidenced, conventions met, nothing blocking. Cleared for PR.
- **CONCERNS** — works and evidenced, but non-blocking issues noted. Cleared for PR with concerns logged in the PR description.
- **FAIL** — a p0/p1 item lacks evidence or a blocking issue exists. Returns to `/jtgp:execute`.
- **WAIVED** — a known issue consciously accepted by the user. Requires explicit confirmation and a recorded reason. Cleared for PR.

## KB sync on close

If `kb_sync_on_close` is true and a KB provider is configured:
- Push the final SPEC.md and VERIFICATION.md to the KB space.
- Best-effort: proceed if the MCP call fails.

## Output

Write `{specs_root}/{ISSUE-ID}/VERIFICATION.md`.
Update CONTEXT.md status: `verified` on PASS/CONCERNS/WAIVED, back to `in-progress` on FAIL.

On PASS/CONCERNS/WAIVED:
- Generate PR description draft in `{specs_root}/{ISSUE-ID}/pr-description.md`.
- Language for PR description: `lang_pr_description`.
- Tell the user the issue is ready — the PR is theirs to open and approve.

On FAIL: list exactly what lacks evidence and route back.
