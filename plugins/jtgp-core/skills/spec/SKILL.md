---
name: spec
description: Create or evolve the living specification for an issue. This is the spec-anchored source of truth — created before planning, kept current through implementation, and read by any future session to resume. Syncs with the knowledge base (Outline/Notion) if configured. Auto-invoke when starting a new issue, or when the user says "spec", "start issue", or references an issue ID with no existing spec.
---

# Skill: spec

## Preconditions

Read `.jtgp/config.json`. If it does not exist, stop and run `/jtgp:setup` first.

Load engagement config: issue tracker, KB provider, specs root, language settings.

All output (spec content, questions to the user) must use the language configured in `lang_docs`. Terminal messages to the user use `lang_terminal`.

## Resolve the issue

If an issue ID is provided, fetch its details from the configured issue tracker:
- `github` → `gh issue view {ID} --repo {issue_tracker_project}`
- `gitlab` → `glab issue view {ID} --repo {issue_tracker_project}`
- `jira` → fetch via Jira MCP if available, otherwise ask user to describe inline
- `notion` → fetch via Notion MCP if available, otherwise ask user to describe inline
- `manual` → ask user to describe inline

If no issue ID is provided, ask using selectable options:
1. Enter an issue ID (fetch from tracker)
2. Describe the issue inline
3. This is a smoke test — generate a placeholder spec

## Knowledge base sync (if configured)

If `kb_sync_on_start` is true and a KB provider is configured:
- Search the KB for an existing spec or prior context for this issue
- If found, load it as starting context — do not duplicate, evolve
- Note: KB sync is best-effort; proceed if the MCP call fails

## Sizing

Classify the issue honestly. State the classification at the top of the spec:
- **small** — localized change, single file or tight cluster, no new integration
- **medium** — multiple files or one new integration, moderate domain logic
- **large** — cross-cutting, new architecture surface, external integration, or security surface

Sizing drives critique rounds and agent dispatch depth downstream. Do not inflate.

## YAGNI

Every requirement must trace to evidence from the issue. Speculative scope goes to the "Out of scope / deferred" section, not the requirements list.

## Output

Create `{specs_root}/{ISSUE-ID}/SPEC.md` using the SPEC template.
Create `{specs_root}/{ISSUE-ID}/CONTEXT.md` using the CONTEXT template.

If a `tasks_root` is configured, note it in CONTEXT.md as the path for QA artifacts.

After writing, summarize the spec in 3–4 lines and direct the user to `/jtgp:plan {ISSUE-ID}`.
Do not start planning or writing code in this skill.
