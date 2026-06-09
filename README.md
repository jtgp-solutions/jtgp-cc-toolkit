# JTGP Claude Code Toolkit

A private, versioned plugin marketplace that standardizes spec-anchored development across multiple engineering engagements. Adapts to any engagement via interactive setup — install once, configure per workspace.

## Core idea

**Sessions are disposable. Specs are permanent.**

Context lives in files, not in a chat session. A living `SPEC.md` per issue is the source of truth — created before planning, kept current through implementation, synced to your knowledge base (Outline/Notion) if configured.

## Setup

Install the plugin, then run setup once per engagement workspace:

```
/plugin marketplace add jtgp-solutions/jtgp-cc-toolkit
/plugin install jtgp-core@jtgp
/jtgp:setup
```

Setup asks 22 questions covering: issue tracker, knowledge base, PR tool, language preferences (code, docs, terminal, commits, PR descriptions), code standards, test framework, branch conventions. All answers are saved to `.jtgp/config.json` (git-ignored, stays local).

## The workflow

```
/jtgp:setup          → configure the engagement (once)
/jtgp:spec ISSUE-ID  → create the living spec (source of truth)
/jtgp:plan ISSUE-ID  → phased implementation plan from the spec
/jtgp:critique       → adversarial loop hardens the plan
/jtgp:execute        → autonomous implementation (stops at PR boundary)
/jtgp:verify         → evidence gate: PASS / CONCERNS / FAIL / WAIVED
                     → PR opened by human after PASS
```

Plus:

```
/jtgp:resume ISSUE-ID  → rebuild full context in a fresh session
/jtgp:review-pr N      → review a colleague's PR (isolated worktree)
/jtgp:learn            → capture a correction as a permanent rule
/jtgp:cleanup          → remove orphaned worktrees and stale branches
```

## What adapts per engagement

Everything in `.jtgp/config.json`:

| Category | Fields |
|---|---|
| Identity | engagement name, git email |
| Issue tracker | github / gitlab / jira / notion / linear / manual |
| Knowledge base | outline / notion / confluence / none |
| PR tool | gh / glab / manual |
| Languages | code, docs, terminal, commits, PR descriptions, PR reviews |
| Code standards | no-comments rule, code style, test framework, build tool |
| Conventions | branch pattern, commit convention |

## Multi-engagement example

```
workspace/project1/    → /jtgp:setup → github + outline + gh + pt-br docs + java-spring
workspace/project2/     → /jtgp:setup → gitlab + outline + glab + pt-br docs + java-spring
workspace/project3/     → /jtgp:setup → notion + notion  + gh  + pt-br docs + react-ts
workspace/new-project/    → /jtgp:setup → any combination
```

## Components

- **skills/** — 10 workflow commands namespaced `/jtgp:*`
- **agents/** — planner, critic, developer, tester, investigator, quality-gate (Opus for reasoning, Sonnet for execution)
- **hooks/** — git identity guard (reads from config), no-comments guard (respects config), spec-sync reminder
- **lib/** — `context.sh` loads config into env vars for hooks
- **templates/** — `SPEC.md`, `CONTEXT.md`, `config.json`

## Security

`.jtgp/config.json` is always git-ignored. It contains your corporate email and engagement-specific IDs — it must never be committed.
