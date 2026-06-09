---
name: plan
description: Produce an implementation plan from an existing living spec. Reads the spec, dispatches the planner agent, and writes a phased file-level plan with edge cases classified p0/p1/p2. Auto-invoke after a spec exists and the user says "plan" or asks how to implement the issue.
---

# Skill: plan

## Preconditions

Read `.jtgp/config.json`. If missing, redirect to `/jtgp:setup`.

Read `{specs_root}/{ISSUE-ID}/SPEC.md`. If missing, redirect to `/jtgp:spec {ISSUE-ID}`.

Language for plan content: `lang_docs`. Language for terminal messages: `lang_terminal`.

## Dispatch

Delegate to the `planner` agent with the spec content, code style, test framework, and build tool from config as context. The planner is model-intensive — this is where plan quality is determined.

## Plan structure

- **Approach** — chosen technical approach traced to the spec
- **Phases** — ordered, each independently testable
- **Files impacted** — explicit list with role of each file
- **Edge cases** — each marked p0/p1/p2, traced to spec evidence
- **Risks** — what could break, rollback for `large` sizing
- **Out of scope** — YAGNI items carried from the spec

## Priority classification

- **p0** — must ship, blocks the feature
- **p1** — should ship, materially improves quality
- **p2** — nice to have, requires explicit opt-in

Implementation focuses on p0 and p1 only.

## Output

Write `{specs_root}/{ISSUE-ID}/PLAN.md`.
Update CONTEXT.md status to `plan-draft`.

Direct the user to `/jtgp:critique {ISSUE-ID}`. Do not skip critique for medium or large sizing.
