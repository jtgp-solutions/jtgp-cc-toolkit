---
name: critique
description: Adversarially review and harden an implementation plan before execution. Runs a critic agent that actively tries to find flaws, then revises. Rounds scale with sizing. Auto-invoke after a plan exists and before execution.
---

# Skill: critique

## Preconditions

Read `.jtgp/config.json`. Read `{specs_root}/{ISSUE-ID}/PLAN.md` and `SPEC.md`.

Language for output: `lang_docs`. Language for terminal: `lang_terminal`.

## Round count by sizing

- small → 1 round
- medium → 2 rounds
- large → up to 3 rounds

## The loop

For each round:

1. Dispatch the `critic` agent. It assumes the plan is wrong and tries to prove it. Checks:
   - Is any item a workaround rather than the best solution?
   - Is the plan scalable or does it bake in a ceiling?
   - Are there spec edge cases the plan ignores?
   - Does the plan violate YAGNI?
   - Does it violate the engagement's code style or conventions?

2. Critic produces findings with severity: **blocking** / **major** / **minor**, each backed by evidence.

3. Revise the plan to address blocking and major findings. Minor findings are logged but may be deferred with a one-line justification.

4. If a round produces zero blocking or major findings, stop early.

## Output

Update `PLAN.md` in place. Append a `## Critique log` section.
Update CONTEXT.md status to `plan-approved` when the loop ends clean.

Report rounds run and the most important changes made.
Direct the user to `/jtgp:execute {ISSUE-ID}`.
