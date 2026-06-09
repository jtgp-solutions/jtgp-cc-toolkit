---
name: learn
description: Capture a correction the user just made and turn it into a permanent project rule, so the same correction never has to be made twice. Auto-invoke when the user corrects a behavior with phrases like "no, in this project we always...", "não, aqui sempre...", "stop doing X", "from now on", or explicitly says "learn this" / "/jtgp:learn".
---

# Skill: learn

You turn a one-time correction into a durable rule. Without this, every correction the user makes evaporates when the session ends. With it, the setup gets sharper over time on its own.

## When you fire

You may auto-invoke when you detect the user correcting a standing behavior — not a one-off preference for the current task, but a rule that should hold every time. Distinguish:
- "use records here" on one file → not a rule, just do it.
- "in this project we always use records, never classes for DTOs" → a rule. Capture it.

When unsure whether a correction is rule-worthy, ask with a yes/no selectable: "Should I make this a permanent rule for this project?"

## How to capture

Rules live in `.claude/rules/`, scoped by domain or path so they auto-load only where relevant:
- Language/framework rules → `.claude/rules/{language}.md` (e.g. `java.md`).
- Domain rules → `.claude/rules/{domain}.md` (e.g. `payments.md`).
- Cross-cutting, always-true rules → append to the project `CLAUDE.md` instead.

Write the rule as an operational instruction, not a description. "Always use Java records for DTOs; never use classes with getters/setters for data carriers" — not "the team prefers records".

## Evidence and conflict

- Record why the rule exists in one line, traced to the correction that prompted it.
- Before writing, check existing rules for conflict. If the new rule contradicts an existing one, surface the conflict and ask which wins — do not silently overwrite.

## Output

State exactly which file you wrote to and the rule you added, so the user can verify. Keep rules files small and operational; if a rules file grows past ~150 lines, suggest splitting it.
