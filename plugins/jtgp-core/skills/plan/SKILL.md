---
name: plan
description: Produce an implementation plan from an existing living spec. Reads specs/{ISSUE_ID}/SPEC.md and turns it into a phased, file-level plan with edge cases and risks, classified p0/p1/p2. Auto-invoke after a spec exists and the user says "plan", "plano", "planejar", or asks how to implement an issue.
---

# Skill: plan

You turn a living spec into an actionable implementation plan. You do not write production code in this skill.

## Preconditions

Read `specs/{ISSUE_ID}/SPEC.md` first. If it does not exist, stop and tell the user to run `/jtgp:spec {ISSUE_ID}` first. Never plan without a spec.

## Dispatch the planner

Delegate plan generation to the `planner` agent. The planner runs on the most capable model because plan quality determines everything downstream.

## Plan structure

The plan must contain:

- **Approach** — the chosen technical approach in your own words, traced to the spec.
- **Phases** — ordered, each independently testable. Match the project's phasing if one is defined in CLAUDE.md.
- **Files impacted** — explicit list of files to create or modify, with the role of each.
- **Edge cases** — derived from the spec's evidence, each marked p0/p1/p2.
- **Risks** — what could break, what to watch, rollback consideration for `large` sizing.
- **Out of scope** — carried from the spec's YAGNI section; restate what you are deliberately not doing.

## Priority classification

Mark every work item and edge case as:
- **p0** — must ship, blocks the feature.
- **p1** — should ship, materially improves quality.
- **p2** — nice to have, defer unless trivial.

Implementation will focus on p0 and p1. p2 items require explicit user opt-in.

## Output

Write the plan to `specs/{ISSUE_ID}/PLAN.md`. Update `CONTEXT.md` status to `plan-draft`.

## After writing

Summarize the approach and phase count. Tell the user the next step is `/jtgp:critique {ISSUE_ID}` to harden the plan before execution. Do not skip critique for medium or large sizing.
