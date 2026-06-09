# JTGP Claude Code Toolkit

A private, versioned plugin marketplace that standardizes spec-anchored development across multiple engineering engagements. Ships reusable skills, specialized agents, and safety hooks for autonomous planning, critique, execution, and verification — installable in any repo with a single command.

## Core idea

**Sessions are disposable. Specs are permanent.**

Context lives in files, not in a chat session. A living `SPEC.md` per issue is the source of truth — created before planning, kept current through implementation, and read by any future session to resume work. A bug that resurfaces three weeks after merge is resumable with zero memory of the original session.

## The workflow

```
/jtgp:spec PROJ-123      → create the living spec (source of truth)
/jtgp:plan PROJ-123      → phased, file-level plan from the spec
/jtgp:critique PROJ-123  → adversarial loop hardens the plan (N rounds by size)
/jtgp:execute PROJ-123   → autonomous implementation (plan→bypass handoff)
/jtgp:verify PROJ-123    → evidence gate: PASS / CONCERNS / FAIL / WAIVED
                         → PR opened by human after PASS
```

Plus:

```
/jtgp:resume PROJ-123    → rebuild full context in a fresh session
/jtgp:review-pr <url>    → review a colleague's PR (isolated worktree)
/jtgp:learn              → capture a correction as a permanent rule
```

## Concepts absorbed from the ecosystem

- **Spec-anchored** (not spec-once): the spec stays alive through the lifecycle.
- **Sizing** (small/medium/large): depth and agent count scale to real complexity.
- **YAGNI, evidence-based**: every requirement traces to evidence; no speculative scope.
- **Adversarial critique**: a critic agent tries to reject the plan before code is written.
- **Four-level quality gate**: PASS / CONCERNS / FAIL / WAIVED.
- **Evidence requirement**: "should work" never passes; fresh runtime proof required.
- **Multi-model**: Opus for planning/critique/judgment, Sonnet for implementation/tests.

## Install

```
/plugin marketplace add jtgp-solutions/jtgp-cc-toolkit
/plugin install jtgp-core@jtgp
```

(Private repo — the machine must be authenticated to the GitHub account that owns it.)

## Per-repo setup

1. Create a `.jtgp-identity` file in the repo root with the correct git identity:
   ```
   email=you@company.com
   ```
   The `git-identity` hook blocks commits/pushes when the configured git email
   does not match — preventing cross-account commits when multiple engagements
   share a machine.

2. Specs live under `specs/{ISSUE_ID}/`. Worktrees are named per issue.

## Components

- **skills/** — the workflow commands (namespaced `/jtgp:*`)
- **agents/** — planner, critic, developer, tester, investigator, quality-gate
- **hooks/** — git identity guard, no-comments guard, spec-sync reminder
- **templates/** — SPEC.md (living source of truth), CONTEXT.md (session anchor)

## Versioning

This plugin is versioned. Engagements pin a version; improvements roll out by bumping
the version in `plugins/jtgp-core/plugin.json` and updating installs.
