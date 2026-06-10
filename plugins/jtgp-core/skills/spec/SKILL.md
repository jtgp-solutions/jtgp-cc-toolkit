---
name: jtgp:spec
description: Create or evolve the living specification for an issue. Automatically fetches from the issue tracker and searches the knowledge base (Outline/Notion) for related specs, confirms with the user before writing. All artifacts in a single unified folder. Auto-invoke when starting a new issue, or when the user says "spec", "start issue", or references an issue ID with no existing spec.
---

# Skill: spec

## Preconditions

Read `.jtgp/config.json`. If it does not exist, stop and run `/jtgp:setup` first.

Load engagement config: issue tracker, KB provider, specs root, language settings.

Terminal messages: `lang_terminal`. Spec content: `lang_docs`.

## Unified folder structure

The primary identifier is always the issue tracker ID (e.g. `PRJ-XXX`).
All artifacts live under one folder — no split between specs and qa:

```
{specs_root}/{ISSUE-ID}-{short-title}/
├── SPEC.md           ← living source of truth
├── CONTEXT.md        ← session state anchor
├── PLAN.md
├── VERIFICATION.md
└── qa/               ← evidence, curls, test data, Figma notes
    └── evidencias/
```

For new issues: ignore `tasks_root` — everything goes here.
For resume on old issues: still check `tasks_root` for legacy context.

## Step 1 — Fetch the issue

Fetch from the configured tracker:
- `jira` → fetch via Jira MCP. Extract: title, description, acceptance criteria, linked SPEC-XXX references, Figma links.
- `github` → `gh issue view {ID} --repo {issue_tracker_project}`
- `gitlab` → `glab issue view {ID}`
- `notion` → fetch via Notion MCP
- `manual` → ask user to describe inline

If the Jira issue references a SPEC-XXX spec ID, extract it — needed in Step 2.

If fetch fails: inform the user, ask them to describe inline, and proceed.

## Step 2 — Search knowledge base

If `kb_provider` is `outline` or `notion` and `kb_sync_on_start` is true:

Search the KB for related content. Try in order:
1. SPEC-XXX ID found in Step 1 (if any)
2. PRJ-XXX ID
3. Key terms from the issue title

For each result found, show: document title, last updated date, brief summary.
Present as selectable options and wait for the user to confirm which to use.

If nothing found: inform clearly — "No related spec found in Outline for PRJ-XXX / SPEC-XXX. You can describe the requirements inline or check Outline manually." Then ask how to proceed.

**Never proceed without user confirmation of KB content.**

## Step 3 — Build and confirm the spec draft

Using issue details (Step 1) and confirmed KB content (Step 2):
- Extract requirements from Jira acceptance criteria and KB spec
- Classify each as p0/p1/p2
- Identify obvious edge cases from the evidence
- Apply YAGNI: speculative scope goes to "Out of scope / deferred"

Show the draft to the user before writing:
> "Here is the spec draft for {ISSUE-ID}. Does this look correct?"
Options: yes / adjust / start over

If adjust: apply corrections and show again. Repeat until confirmed.

## Step 4 — Sizing

After the spec is confirmed, classify:
- **small** — localized change, single file or tight cluster, no new integration
- **medium** — multiple files or one new integration, moderate domain logic
- **large** — cross-cutting, new architecture surface, external integration, or security surface

State the classification and brief rationale at the top of SPEC.md.

## Step 5 — Write to disk

Only after user confirms the draft:

Create `{specs_root}/{ISSUE-ID}-{short-title}/SPEC.md`
Create `{specs_root}/{ISSUE-ID}-{short-title}/CONTEXT.md`
Create `{specs_root}/{ISSUE-ID}-{short-title}/qa/` directory

## After writing

Summarize the spec in 3–4 lines. Direct the user to `/jtgp:plan {ISSUE-ID}`.
Do not start planning or writing code in this skill.
