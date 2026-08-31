# Model matrix — which model each agent runs on, and when to override

Two levers, in this order: **`effort` first, `model` second.** Lowering `effort` on a capable model
keeps convention-fidelity and the prompt cache; swapping model forfeits both (caches are model-scoped).
Never downgrade a model to save cost before measuring the same model at lower effort.

## Current tiers

| Model | In/Out $/1M | Context | Role in this plugin |
|---|---|---|---|
| `fable` (Fable 5) | 10 / 50 | 1M | Escalation only — long-horizon autonomous runs, reincident bugs |
| `opus` (Opus 5) | 5 / 25 | 1M | Judgment: plan, critique, root cause, gate |
| `sonnet` (Sonnet 5) | 2 / 10 | 1M | Default for anything that touches code |
| `haiku` (Haiku 4.5) | 1 / 5 | **200K** | Mechanical sweeps only |

## Assignment

| Agent / task | Model | Effort | Why |
|---|---|---|---|
| `planner` | `opus` | high | Plan quality determines everything downstream |
| `critic` | `opus` | high | Adversarial reading needs the judgment tier |
| `investigator` | `opus` | high | Escalate to `fable` when the bug already came back after a merge |
| `quality-gate` | `opus` | high | Gate that ships or blocks work |
| `developer` | `sonnet` | medium/high | Thinking was done in plan + critique; execution is mechanical |
| `tester` | `sonnet` | medium/high | Same |
| Grep sweep, log filtering, dir listing | `haiku` | — | Only place haiku still pays. Needs >200K context? Use `sonnet` |
| Mechanical edit (rename, import, compile fix) | `sonnet` | low | Haiku misses engagement conventions; the rework costs more than the delta |
| Architecture decision with a real trade-off | `opus`/`fable` | max | `max` only when correctness outweighs cost |

## Escalation to `fable`

Override the agent's default model to `fable` (effort `xhigh`) in exactly two situations:

1. **A full autonomous run** — `/jtgp-core:execute` going from approved plan to PR without checkpoints on a
   large or high-blast-radius issue. Long-horizon agentic work is what the tier is for.
2. **A bug that resurfaced after one of your own merged fixes** — the `learn` skill's case 2. The first
   root cause was wrong; paying 2x to not be wrong twice is the cheap option.

Everything else stays on the table above. `fable` has thinking always on and produces long turns — it is
not a drop-in for routine work.

## Rules

- Every agent carries an explicit `model` in its frontmatter. An agent without one silently inherits the
  session model, which is how the cheapest-to-reason loop ends up on the most expensive model.
- Prefer doing simple things directly (Read, Grep, Edit) over spawning an agent.
- Group work into one agent: one agent doing five things beats five agents doing one.
