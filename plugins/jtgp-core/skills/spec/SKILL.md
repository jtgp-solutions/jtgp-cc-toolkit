---
name: jtgp:spec
description: Create or evolve the living specification for an issue. Starts by asking the goal of the issue to determine the right flow — implementation, bug fix, investigation, rule validation, or other. Fetches from the issue tracker, searches the KB, and confirms the draft with you before writing. Auto-invoke when starting a new issue or when an issue ID is referenced with no existing spec.
---

# Skill: spec

## Preconditions

Read `.jtgp/config.json`. If missing, stop and run `/jtgp:setup` first.
Load: issue tracker, KB provider, specs root, language settings.
Terminal messages: `lang_terminal`. Spec content: `lang_docs`.

## Step 0 — Understand the goal

Before fetching anything, ask the user what they need. Present as selectable options:

```
What is the goal of this issue?

1. Implement (feature / task)
   Full flow: spec → plan → critique → execute → verify → PR

2. Fix a bug
   Full flow with emphasis on evidence and root cause confirmation.

3. Investigate / query data
   Spec only: findings report. No plan, no execute, no PR.

4. Validate a business rule
   Spec + KB lookup: confirm implementation vs functional spec.

5. Other
   Describe what you need and I will suggest the appropriate flow.
```

Record the selected goal in CONTEXT.md as `goal:` field.
Adapt subsequent steps to the goal — for option 3 or 4, make clear no PLAN.md or execute will be produced; the output is a findings report in SPEC.md.

## Step 1 — Fetch the issue

Fetch from the configured tracker:
- `jira` → Jira MCP. Extract: title, description, acceptance criteria, linked spec IDs, Figma links.
- `github` → `gh issue view {ID} --repo {issue_tracker_project}`
- `gitlab` → `glab issue view {ID}`
- `notion` → Notion MCP
- `manual` → ask user to describe inline

If the issue references a linked spec ID in the KB, extract it — needed in Step 2.
If fetch fails: inform the user, ask them to describe inline, and proceed.

## Step 2 — Search knowledge base

Search for related context in this order. Do not skip steps.

### 2a — Local specs (always, regardless of KB provider)

Search `{specs_root}/` for prior issues in the same domain:
- Glob for `{kb_local_patterns}` files (e.g. `knowledge-base-*.md`, `DECISIONS.md`) in any subfolder
- Glob for SPEC.md and PLAN.md files whose folder name contains key terms from the issue title or module name
- Read any matches and extract relevant decisions, patterns, and findings

This step is **mandatory before any escalation**. Local specs often contain implementation decisions not yet synced to the remote KB — skipping them is the primary cause of unnecessary escalations.

### 2b — Remote KB (if configured)

If `kb_provider` is configured and `kb_sync_on_start` is true:

Search for related content. Try in order:
1. Linked spec ID found in Step 1 (if any)
2. Issue ID
3. Key terms from the issue title

For each result: show document title, last updated date, brief summary.
Present as selectable options and wait for confirmation before using any content.

If nothing found: inform clearly. Ask how to proceed (describe inline or check KB manually).

### 2c — Exhaustion rule (before any escalation)

**Before proposing escalation to a person, confirm that ALL of the following have been checked:**
- [ ] Local specs (`specs_root`) searched for the affected module and related business rules
- [ ] Remote KB searched (if configured)
- [ ] Git history of the affected files checked for relevant commit messages or prior decisions
- [ ] Related specs referenced in found documents also read (follow the trail)

Only escalate when the question genuinely has no answer in any of these sources. If you find a partial answer, state what you found and what specific gap remains — do not escalate a question the sources already answer.

**Never proceed without user confirmation of KB content.**

## Step 3 — Build and confirm the spec draft

Using issue details and confirmed KB content:
- For **implement / bug**: extract requirements, classify p0/p1/p2, identify edge cases, apply YAGNI
- For **investigate / rule validation**: extract the question being answered, the evidence sources, what "done" looks like for the findings

Show the draft to the user:
> "Here is the spec draft for {ISSUE-ID}. Does this look correct?"
Options: yes / adjust / start over

Repeat until confirmed.

## Step 4 — Sizing

After spec is confirmed, classify:
- **small** — localized change, single file, no new integration
- **medium** — multiple files or one new integration, moderate domain logic
- **large** — cross-cutting, new architecture surface, external integration, or security surface

State classification and rationale at the top of SPEC.md.
For investigation/rule validation goals: sizing is always `small` — no plan depth needed.

## Step 5 — Write to disk

Only after user confirms:

```
{specs_root}/{ISSUE-ID}-{short-title}/
├── SPEC.md
├── CONTEXT.md       ← includes goal: field
└── qa/              ← for evidence, curls, screenshots
```

## After writing

For **implement / bug**: summarize in 3–4 lines, direct to `/jtgp:plan {ISSUE-ID}`.
For **investigate / rule validation**: summarize findings so far, direct to `/jtgp:verify` or tell user findings are ready — no plan or execute needed.
Do not start planning or writing code in this skill.
