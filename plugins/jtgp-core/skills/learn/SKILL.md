---
name: jtgp:learn
description: Capture a correction or discovered pattern as a permanent engagement rule. Can be triggered manually when you correct a standing behavior, or proposed automatically by the agent when it detects a repeated violation, an undocumented architectural decision, or a critique finding that a rule could have prevented. Writes to local rules or syncs to the shared KB depending on scope.
---

# Skill: learn

## Preconditions

Read `.jtgp/config.json`. Language for terminal: `lang_terminal`.
KB provider and space ID from config (needed for team-wide sync).

## When to fire

### Manual trigger
The user corrects a standing behavior with phrases like:
- "in this project we always..."
- "never do X"
- "from now on..."
- "stop doing X"
- explicitly calls `/jtgp:learn`

### Auto-propose trigger
The agent may propose this skill (never execute it silently) when it detects:

**Propose:**
- A violation pattern repeated across multiple files not covered by existing rules (e.g. `.orElse(null)` in 3+ files, no rule blocking it)
- An architectural decision discovered during spec/discovery/critique that is not documented in local KB, CLAUDE.md, rules, or the shared KB (RIAG/Outline/Notion)
- A critique finding that a documented rule could have prevented ("this would have been caught by a rule about...")

**Do NOT propose:**
- Issue-specific decisions — those belong in SPEC.md
- Anything already documented in CLAUDE.md, existing rules, or the shared KB
- Style preferences without evidence of real impact
- One-off corrections for the current task only

When proposing, ask with a yes/no selectable:
> "I noticed a pattern that might be worth capturing as a permanent rule: {description}. Should I add it?"

Only proceed if confirmed.

## Step 1 — Classify the correction

Distinguish a standing rule from a one-off preference:
- "use records here" on one file → one-off, do it but do not capture
- "in this project we always use records for DTOs" → standing rule, capture it

When unsure: ask "Should I make this a permanent rule for this engagement?"

## Step 2 — Determine scope

Ask before writing:

```
Is this rule personal (your setup only) or team-wide?

1. Personal — writes to .jtgp/rules/{domain}.md
   Applies only to your Claude Code sessions in this engagement.

2. Team-wide — writes to .jtgp/rules/ AND syncs to the shared KB
   Applies to everyone. Requires KB provider configured (Outline/Notion via MCP).
```

If option 2 and no KB is configured, inform the user and default to local only.

## Step 3 — Check for conflicts

Before writing, search:
- `.jtgp/rules/` for existing rules in the relevant domain
- `CLAUDE.md` in the workspace root for cross-cutting rules

If the new rule contradicts an existing one: surface the conflict, show both, ask which wins. Do not silently overwrite.

## Step 4 — Write the rule

Rules live in `.jtgp/rules/`, scoped by domain or path so they auto-load where relevant:
- Language/framework rules → `.jtgp/rules/{language-or-framework}.md`
- Domain rules → `.jtgp/rules/{domain}.md`
- Cross-cutting always-true rules → append to workspace `CLAUDE.md`

Write as an operational instruction, not a description:
- Good: "Always use records for DTOs; never use classes with getters/setters for data carriers."
- Bad: "The team prefers records over classes."

Include one line of rationale traced to the correction that prompted it.

## Step 5 — KB sync (team-wide scope only)

If team-wide and KB is configured:
- Push the rule to the shared KB space (Outline/Notion via MCP)
- Use a consistent document title: "Engineering Rules — {domain}"
- Append, do not overwrite existing content
- Inform the user what was synced and where

Best-effort: if the MCP call fails, write locally and tell the user to sync manually.

## After writing

State exactly which file was written and the rule added.
Keep rules files operational and concise — if one grows past ~150 lines, suggest splitting.
