---
name: spec
description: Create or evolve the living specification for a feature or issue. This is the spec-anchored source of truth that survives the entire lifecycle — created before planning, kept up to date through implementation, and consulted whenever work resumes. Auto-invoke when the user starts a new feature, issue, or task, or says "spec", "especificação", "começar issue", or references an issue ID without an existing spec.
---

# Skill: spec

You are creating or evolving a **living specification** — the single source of truth for a feature or issue. Unlike a one-shot plan, this spec stays alive: it is updated at every phase and is what any future session reads to understand what was built and why.

## Inputs you need

Resolve these before writing the spec. If something is missing and cannot be inferred, ask using selectable options (offer 2-4 concrete choices plus an open input), never open-ended questions.

- Issue ID (e.g. PROJ-123). If absent, ask for it.
- Issue source: tracker (Jira/Linear/GitHub Issues via MCP) or described inline.
- Evidence already provided: curls, stack traces, screenshots, logs, reproduction steps.

## Sizing — decide depth before writing

Classify the work and state the classification explicitly at the top of the spec:

- **small**: localized change, single file or tight cluster, no new integration. Spec is short; skip exhaustive edge-case hunting.
- **medium**: multiple files or one new integration, moderate domain logic. Full spec.
- **large**: cross-cutting, new architecture surface, external integration, or security surface. Full spec plus explicit risk and rollback sections.

Sizing drives how many agents downstream skills dispatch. Do not inflate. Default to the smallest size the evidence supports.

## YAGNI — evidence-based scope

Every requirement in the spec must trace to evidence: the issue text, a stakeholder request, a reproduction, or a stated business rule. If a requirement is speculative ("we might need…"), move it to an explicit "Out of scope / deferred" section. Do not design for futures that have no evidence.

## What to produce

Create or update `specs/{ISSUE_ID}/SPEC.md` using the template at `templates/SPEC.md`. If the file exists, evolve it — never overwrite decisions; append and revise with timestamps.

Then create `specs/{ISSUE_ID}/CONTEXT.md` from `templates/CONTEXT.md` if it does not exist. The CONTEXT.md points at the SPEC.md and tracks live session state.

## After writing

State the sizing, summarize the spec in 3-4 lines, and tell the user the next step is `/jtgp:plan {ISSUE_ID}`. Do not start planning or coding in this skill.
