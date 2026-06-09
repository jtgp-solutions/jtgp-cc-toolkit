---
name: critique
description: Adversarially review and harden an implementation plan before execution. Runs a critic agent that actively tries to find flaws, then revises. Repeats up to N rounds until no material issues remain. Auto-invoke after a plan exists and before execution, or when the user says "critique", "critica", "revisar plano", "harden".
---

# Skill: critique

You run an adversarial loop against the plan. The goal is to surface design flaws, scope creep, missing edge cases, and workarounds-disguised-as-solutions before any code is written. Catching a design problem here costs minutes; catching it after implementation costs hours.

## Preconditions

Read `specs/{ISSUE_ID}/PLAN.md` and `specs/{ISSUE_ID}/SPEC.md`. If the plan is missing, stop and direct the user to `/jtgp:plan {ISSUE_ID}`.

## The loop

Determine round count from sizing: small → 1 round, medium → 2 rounds, large → up to 3 rounds.

For each round:

1. Dispatch the `critic` agent. Its job is to assume the plan is wrong and prove it. The critic must check, at minimum:
   - Is any item a workaround forced by current implementation limits, rather than the best solution?
   - Is the plan scalable, or does it bake in a ceiling?
   - Are there edge cases in the spec's evidence that the plan ignores?
   - Does the plan violate YAGNI by building unproven futures?
   - Does it violate the project's conventions (from CLAUDE.md / rules)?
2. The critic produces findings, each with severity: blocking / major / minor, and each backed by evidence or explicit reasoning.
3. Revise the plan to address blocking and major findings. Minor findings are logged but may be deferred with a one-line justification.
4. If a round produces zero blocking or major findings, stop early — do not invent problems to justify another round.

## Output

Update `PLAN.md` in place with revisions. Append a `## Critique log` section recording each round's findings and how they were resolved. Update `CONTEXT.md` status to `plan-approved` once the loop ends clean.

## After the loop

Report rounds run and the most important changes made. Tell the user the plan is hardened and the next step is `/jtgp:execute {ISSUE_ID}`. Remind them execution runs autonomously and stops only at the PR boundary.
