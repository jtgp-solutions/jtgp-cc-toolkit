---
name: cleanup
description: Remove orphaned worktrees and stale branch references. Targets agent-generated worktrees with hash names (agent-XXXX) and worktrees whose branches have already been merged. Auto-invoke when the user says "cleanup", "clean worktrees", or asks to remove stale branches.
---

# Skill: cleanup

## Preconditions

Read `.jtgp/config.json`. Language for terminal: `lang_terminal`.
Worktrees root: `worktrees_root`.

## What to clean

### Orphaned agent worktrees
Find worktrees with names matching `agent-[a-f0-9]{8,}` pattern — these are leftovers from Claude Code subagents. They accumulate silently and waste disk space.

```bash
git worktree list --porcelain
```

For each worktree matching the pattern:
- Confirm it is not currently in use (no active Claude Code session pointing to it)
- Report it as a candidate for removal

### Merged branch worktrees
For each worktree in `{worktrees_root}/`:
- Check if its branch has been merged into the base branch: `git branch --merged {pr_base_branch}`
- If merged, report it as a candidate for removal

### Stale local branches
List local branches whose remote tracking branch no longer exists: `git branch -vv | grep ': gone]'`

## Safety rules

- **Never delete anything without listing candidates first**
- **Never delete a worktree that has uncommitted changes** — flag it instead
- **Always ask for explicit confirmation** before any deletion
- Show the list of candidates and ask: "Delete all of these? (yes / select individually / cancel)"

## Output

Report:
- N orphaned agent worktrees found → (list paths)
- N merged-branch worktrees found → (list paths + branch name)
- N stale local branches found → (list)

After confirmation, run `git worktree remove {path}` and `git branch -d {branch}` for approved items.
Report what was cleaned.
