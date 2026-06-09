---
name: execute
description: Autonomously implement an approved, hardened plan. This is the plan-to-bypass handoff — it assumes the plan was reviewed and runs implementation, tests, and self-review without stopping for per-step confirmation, halting only at the PR boundary. Auto-invoke when the user says "execute", "executar", "implementar", "build it" on an issue that has an approved plan.
---

# Skill: execute

You implement an approved plan end to end. You run autonomously: no per-file confirmation. You stop only at the PR boundary, which always requires human approval.

## Preconditions

Read `specs/{ISSUE_ID}/PLAN.md`, `SPEC.md`, and `CONTEXT.md`. The plan status in CONTEXT.md must be `plan-approved`. If it is not, stop and tell the user to run `/jtgp:critique {ISSUE_ID}` first. Never execute an un-critiqued plan for medium or large sizing.

## Working context

Confirm you are operating in the correct worktree and branch for this issue. If a worktree does not exist, create one named for the issue before touching code. Never implement an issue from a branch belonging to another issue.

## Implementation rules

- Implement p0 and p1 items only. p2 requires explicit user opt-in recorded in CONTEXT.md.
- Follow the project's conventions and rules without exception. Code carries no comments unless a public-interface doc standard requires it.
- Use TodoWrite to track each phase before starting it. Mark phases complete as you go.
- Delegate the bulk implementation to the `developer` agent. Delegate test creation to the `tester` agent.
- After each phase, update `CONTEXT.md`: what was done, files touched, decisions made and why.

## Self-review before handing off

When implementation is complete, before declaring done:
1. Dispatch the `critic` agent once more against the actual diff — not the plan — to catch what was missed or left incomplete.
2. Dispatch the `tester` agent to confirm tests cover the p0/p1 edge cases from the plan.
3. Address blocking and major findings. Log minor ones in CONTEXT.md.

## Keep the spec alive

This is the spec-anchored contract: update `SPEC.md` to reflect what was actually built where it diverged from the original. The spec must always describe the real, current state.

## Stop at the PR boundary

Do not open the PR. When done, run `/jtgp:verify {ISSUE_ID}` conceptually — or tell the user to — and report:
- Phases completed
- Files changed
- Test results
- Anything deferred

Set `CONTEXT.md` status to `awaiting-verification`. The PR is opened only after verification passes and the user approves.
