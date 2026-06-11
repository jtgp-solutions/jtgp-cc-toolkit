# JTGP Plugin — How to Use

> Every flow follows the same spine: **spec → plan → critique → execute → verify → PR**
> What changes between scenarios is where you enter and how deep you go.

---

## Before you start: `/jtgp:spec` asks what you need

Every issue starts with `/jtgp:spec {ISSUE-ID}`. The first thing the skill asks is:

```
What is the goal of this issue?

1. Implement (feature / task)
   → full flow: spec → plan → critique → execute → verify → PR

2. Fix a bug
   → full flow with emphasis on evidence and root cause

3. Investigate / query data
   → spec only: findings report, no plan or execute

4. Validate a business rule
   → spec + KB lookup: confirms implementation vs functional spec

5. Other
   → describe and the agent suggests the flow
```

This keeps context lean — the agent only loads what the scenario actually needs.

---

## Scenario 1 — Feature / task development

```
/jtgp:spec ISSUE-ID      → fetches from tracker, searches KB, confirms draft with you
/jtgp:plan ISSUE-ID      → phased plan, file-level, p0/p1/p2 edge cases
/jtgp:critique ISSUE-ID  → adversarial loop (rounds by sizing: small=1, medium=2, large=3)
/jtgp:execute ISSUE-ID   → autonomous implementation, stops at PR boundary
/jtgp:verify ISSUE-ID    → evidence gate: PASS / CONCERNS / FAIL / WAIVED
                         → you open and approve the PR
```

**Tips:**
- Large sizing means cross-cutting changes, new integrations, or security surface. Check whether the scope should be split before executing.
- Before critique, check if a related issue shares the same bug pattern. Mention it to the agent — it will document the relationship and flag scope implications.

---

## Scenario 2 — Bug fix

Same flow as feature development. No shortcuts — the spec is where evidence is established.

**What to bring to the spec:**
- Prints, curls, stack traces, video frames, reproduction steps
- The agent does codebase discovery before writing anything
- Root cause is confirmed before planning — it may change diagnosis mid-spec as evidence arrives

**Mandatory in every bug SPEC.md:**
```markdown
## If a bug returns after merge
prime_suspects: [the two most likely culprits]
check_first:    [which file or method to read first]
reproduce_with: [the exact test, curl, or reproduction script]
```

This is what makes `/jtgp:resume` on a post-merge regression take minutes instead of hours.

---

## Scenario 3 — PR review

```
/jtgp:review-pr {PR-number or URL}
```

The skill:
1. Creates an **isolated worktree automatically** — never touches your active issue branches
2. Fetches the diff, description, CI status, and existing reviews
3. Dispatches the `critic` agent (conventions, correctness, bad smells, tests, evidence)
4. Produces a ready-to-paste review comment in your configured `lang_pr_review`
5. **Never auto-posts** — posting and approving/rejecting is always yours

**Verdict levels:**
- `PASS` — approve, no required changes
- `CONCERNS` — approve with suggestions, non-blocking
- `FAIL` — request changes, blocking items listed
- `WAIVED` — author justified a known issue, acknowledge and approve

---

## Scenario 4 — Resuming an issue (fresh session / returning bug)

```
/jtgp:resume ISSUE-ID
```

The skill reads SPEC.md, CONTEXT.md, PLAN.md, VERIFICATION.md from files alone — no session memory needed. It also checks the git worktree and PR status, and reconciles reality against what the files say.

**Two situations where this is critical:**

1. **Continuing after closing a session.** Decisions, rationale, edge cases, deferred items — all in the files. The agent reconstructs full context without you re-explaining anything.

2. **A bug resurfaced after merge.** The agent goes straight to `## If a bug returns after merge` in SPEC.md — prime suspects, what to check first, how to reproduce. Uses the `investigator` agent with that head start.

---

## Scenario 5 — Investigation / data query (no code change)

Select option **3 (Investigate / query data)** when the spec skill asks for the goal.

The agent will:
- Search the codebase and query the DB via MCP (if configured)
- Search the KB for related specs and decisions
- Produce a findings report in SPEC.md — no PLAN.md, no execute, no PR

**Use cases:**
- "Why is this query slow in production?"
- "Which modules would be affected if we change this enum?"
- "Does service X have the same bug pattern as service Y?"
- "What does the current implementation do vs what the spec says?"

---

## Scenario 6 — Run a specific test or validate a behavior

```
/jtgp:test {description or test name}
```

Use this when you want to **run and report** without opening a formal issue. It does not write new tests — that belongs in execute.

**What it does:**
- Identifies the relevant module and test class from context or your description
- Runs the test suite (or a specific test by name) using the configured build tool
- Captures real runtime output — not "should pass"
- Reports: passed / failed / which assertion / which line

**When to use:**
- Confirming a behavior before opening an issue
- Verifying a fix you made manually
- Checking if an existing test suite is green before starting a new issue
- Quick regression check on a module without a full verify cycle

**When NOT to use:**
- Writing new tests — use execute
- Full E2E of a feature — use verify
- Retaking a failed verify — go back to execute

---

## Scenario 7 — Business rule validation

Select option **4 (Validate a business rule)** when the spec skill asks for the goal.

The agent will:
- Fetch the functional spec from the configured KB (Outline/Notion)
- Cross-reference the spec against the current implementation
- Flag deviations as requirements (R1, R2...) in the spec
- Produce a findings summary before any code is written

This prevents fixing in the wrong direction — the spec defines the contract, the code is measured against it.

---

## Scenario 8 — Workspace cleanup

```
/jtgp:cleanup
```

Finds and removes:
- Orphaned agent-generated worktrees (agent-HASH pattern)
- Worktrees whose branches are already merged into the base branch
- Stale git references (directory gone, reference remains)

Always shows candidates first. Removes only after your confirmation.

**Run it:** before starting a new batch of issues, after a sprint closes, or whenever `git worktree list` looks cluttered.

---

## Scenario 9 — Capture a permanent rule

```
/jtgp:learn
```

**You can trigger it manually** when you correct a standing behavior:
- "In this project we always use records for DTOs, never classes"
- "Never use `.orElse(null)` — always `.orElseThrow()`"
- "Commits must not mention AI or Claude"

**The agent proposes it automatically** when it detects:
- A violation pattern repeated across multiple files not covered by existing rules
- An architectural decision found during discovery not present in the local KB or shared KB (e.g. RIAG/Outline)
- A critique finding that could have been prevented by a rule

**What it does NOT auto-propose:**
- Issue-specific decisions (those go in SPEC.md)
- Things already documented in CLAUDE.md or existing rules
- Style preferences without evidence of impact

**Scope question — local or team-wide?**

The skill asks before writing:
```
Is this rule personal (your setup only) or team-wide?

1. Personal → writes to .jtgp/rules/{domain}.md
2. Team-wide → writes to .jtgp/rules/ AND syncs to the shared KB (Outline/Notion via MCP)
```

Team-wide rules propagate to the shared KB so everyone on the engagement benefits.

---

## Quick reference

| Scenario | Skill | Stops at |
|---|---|---|
| Feature / task | `/jtgp:spec` (option 1) | PR boundary — human opens |
| Bug fix | `/jtgp:spec` (option 2) | PR boundary — human opens |
| PR review | `/jtgp:review-pr` | You post the comment |
| Resume session / returning bug | `/jtgp:resume` | Confirmation before next action |
| Investigation | `/jtgp:spec` (option 3) | Findings report |
| Run specific test | `/jtgp:test` | Test report |
| Business rule validation | `/jtgp:spec` (option 4) | Findings in spec |
| Workspace cleanup | `/jtgp:cleanup` | After your confirmation |
| Capture rule | `/jtgp:learn` | Rule written + optional KB sync |

---

## The two things that never change

**Sessions are disposable. Specs are permanent.**

If SPEC.md and CONTEXT.md are current, any fresh session can resume any issue. The agent reads files, not memory.

**You decide. The plugin executes.**

The plugin stops at every decision boundary: before writing the spec (shows you the draft first), before executing (plan must be approved), before the PR (verify must pass). You are never bypassed on things that matter.
