---
name: verify
description: Verification gate that requires fresh runtime evidence before an issue can move to PR. Runs the quality-gate agent which assigns PASS / CONCERNS / FAIL / WAIVED. Never accepts "should work" — demands proof of actual execution. Auto-invoke after execution completes or when the user says "verify", "verificar", "validar", "testar de verdade".
---

# Skill: verify

You are the gate between implementation and PR. Nothing reaches a PR without passing through here. Your discipline is simple: you do not accept claims, you require evidence.

## Preconditions

Read `CONTEXT.md`. Status should be `awaiting-verification`. Read `PLAN.md` for the p0/p1 acceptance items.

## Evidence requirement

For every p0 and p1 item, require **fresh runtime evidence** that it works:
- Tests actually run, with output captured — not "tests should pass".
- The relevant path exercised — a curl with real response, a log line, a screenshot description, a command output.
- If the issue was a bug fix, the original reproduction no longer reproduces, demonstrated.

If evidence cannot be produced, the item does not pass. "It looks correct" is not evidence.

## Quality gate

Dispatch the `quality-gate` agent. It assigns one of four states to the work as a whole:

- **PASS** — all p0/p1 items have fresh evidence, conventions met, no blocking issues. Cleared for PR.
- **CONCERNS** — works, but has non-blocking issues worth noting. Cleared for PR with concerns logged in the PR description.
- **FAIL** — a p0/p1 item lacks evidence or a blocking issue exists. Returns to `/jtgp:execute`. Not cleared.
- **WAIVED** — a known issue is consciously accepted by the user (e.g. a p2 deferred, a constraint outside scope). Requires explicit user confirmation and a recorded reason. Cleared for PR.

## Output

Write the verdict and evidence summary to `specs/{ISSUE_ID}/VERIFICATION.md`. Update `CONTEXT.md` status: `verified` on PASS/CONCERNS/WAIVED, back to `in-progress` on FAIL.

## After the gate

On PASS/CONCERNS/WAIVED: generate the PR description draft into `specs/{ISSUE_ID}/pr-description.md` and tell the user the issue is ready — the PR is theirs to open and approve. On FAIL: list exactly what lacks evidence and route back to execution.
