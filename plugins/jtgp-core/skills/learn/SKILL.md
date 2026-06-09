---
name: learn
description: Capture a correction the user just made and turn it into a permanent engagement rule, so the same correction never has to be made twice. Auto-invoke when the user corrects a standing behavior with phrases like "in this project we always...", "never do X", "from now on", or explicitly says "/jtgp:learn".
---

# Skill: learn

## Preconditions

Read `.jtgp/config.json`. Language for terminal: `lang_terminal`.

## When to fire

Distinguish one-off preferences from standing rules:
- "use records here" on one file → not a rule, just do it.
- "in this project we always use records for DTOs" → a rule. Capture it.

When unsure, ask with a yes/no selectable: "Should I make this a permanent rule for this engagement?"

## How to capture

Rules live in `.jtgp/rules/`, scoped by domain or path:
- Language/framework rules → `.jtgp/rules/{lang-or-framework}.md`
- Domain rules → `.jtgp/rules/{domain}.md`
- Cross-cutting always-true rules → update `CLAUDE.md` in the workspace root

Write the rule as an operational instruction, not a description.

Include why the rule exists — one line, traced to the correction that prompted it.

Before writing, check for conflicts with existing rules. If the new rule contradicts an existing one, surface the conflict and ask which wins.

## Output

State exactly which file was written and the rule added.
Keep rules files operational and concise — if one grows past ~150 lines, suggest splitting.
