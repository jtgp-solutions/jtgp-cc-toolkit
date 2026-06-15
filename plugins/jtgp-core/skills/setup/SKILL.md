---
name: setup
description: Interactive first-time setup for a new engagement. Creates .jtgp/config.json with all engagement-specific configuration — issue tracker, knowledge base, language preferences, code standards, and branch conventions. Run once per engagement workspace. Auto-invoke when any other skill detects that .jtgp/config.json does not exist.
---

# Skill: setup

You are configuring a new engagement workspace. Ask each question clearly, one at a time, using selectable options where applicable. Include a brief description of what each field means and why it matters. Never hardcode values — every field comes from the user's answers.

At the end, write `.jtgp/config.json` and add `.jtgp/` to `.gitignore` (create the file if it does not exist). The config must never be committed — it contains engagement-specific information that should stay local.

---

## Questions to ask, in order

### 1. Engagement name
> **What it is:** A short identifier for this work engagement. Used in logs, reports, and session context.
> **Suggestion:** the company or project name in lowercase, e.g. `turn2c`, `tivit`, `vonex`, `acme-corp`

Ask: "What is the name of this engagement?"

---

### 2. Git email
> **What it is:** The git user.email configured for commits in this engagement. Used by the git-identity hook to block accidental cross-account commits.
> **Suggestion:** the corporate email you use for git commits here, e.g. `you@company.com`

Ask: "What is your git email for this engagement?"

---

### 3. Issue tracker
> **What it is:** Where tasks and issues come from. The plugin reads issue details from here when starting a spec.
> **Options:** `github` · `gitlab` · `jira` · `notion` · `linear` · `manual` (describe inline, no integration)

Ask: "Which issue tracker does this engagement use?"

---

### 4. Issue tracker details (conditional on step 3)

- If `github`: ask for the GitHub owner/org (e.g. `Turn2C`) and repo or `*` for all repos.
- If `gitlab`: ask for the GitLab project path (e.g. `group/project`) and host URL if self-hosted.
- If `jira`: ask for the Jira project key (e.g. `ERP`) and base URL.
- If `notion`: ask for the Notion database ID where tasks live.
- If `linear`: ask for the team key.
- If `manual`: no extra info needed.

---

### 5. Issue prefixes
> **What it is:** The prefix(es) used in issue IDs. Used by the plugin to identify issue references in branch names, commit messages, and file paths.
> **Suggestion:** e.g. `["ERP-", "CORE-", "ERPISSUES-"]` for Turn2C, `["TIV-"]` for Tivit, `["VON-"]` for Vonex. Use `[]` if there is no consistent prefix.

Ask: "What issue ID prefix(es) does this engagement use? (comma-separated)"

---

### 6. Knowledge base provider
> **What it is:** Where team knowledge, specs, and decisions are stored. The plugin syncs the living spec to/from here at the start and end of each issue.
> **Options:** `outline` · `notion` · `confluence` · `none` (local files only)

Ask: "Which knowledge base does this engagement use?"

---

### 7. Knowledge base details (conditional on step 6)

- If `outline`: ask for the space slug or ID (e.g. `turn2c-erp`).
- If `notion`: ask for the Notion workspace or database ID for specs.
- If `confluence`: ask for the space key and base URL.
- If `none`: skip.

---

### 7.5. Local knowledge base patterns (optional)
> **What it is:** Filename patterns for local knowledge files that live in your specs directory — decisions, architecture notes, or prior research that you or the team wrote directly in the workspace. When the plugin searches for context before escalating a question, it will look for these files in `{specs_root}/` alongside the remote KB.
> **Why it matters:** Some teams document implementation decisions locally (not in Outline/Notion) as files inside spec folders. Without this, the plugin skips them and may propose unnecessary escalations.
> **Suggestion:** `["knowledge-base-*.md", "DECISIONS.md", "plano-mestre.md"]` — or leave blank if all knowledge lives in the remote KB.

Ask: "Do you have local knowledge files in your specs directory? If so, what are their filename patterns? (comma-separated globs, or leave blank)"

---

### 8. PR tool
> **What it is:** The CLI used to create and manage pull/merge requests.
> **Options:** `gh` (GitHub CLI) · `glab` (GitLab CLI) · `manual` (you open PRs yourself)

Ask: "Which PR tool does this engagement use?"

---

### 8.5. GitHub CLI user (conditional — only if pr_tool is `gh`)
> **What it is:** The GitHub account username to use when running `gh` commands in this engagement. Required when you have multiple GitHub accounts configured in `gh auth` (e.g. personal + work). The plugin runs `gh auth switch --user {gh_user}` before any PR operation to ensure the right account is active.
> **Why it matters:** `gh` has a single active account globally — if you switch workspaces without switching the account, PRs and API calls go to the wrong org.
> **Suggestion:** run `gh auth status` to see your configured accounts and pick the one for this engagement. Leave blank if you only have one account.

Ask: "Which `gh` account should this engagement use? (run `gh auth status` to check — leave blank if only one account)"

---

### 9. Base branch for PRs
> **What it is:** The branch that PRs target. Used when generating PR descriptions and running diffs.
> **Suggestion:** `main`, `master`, `develop` — check the repo default

Ask: "What is the base branch for PRs in this engagement?"

---

### 10. Specs root directory
> **What it is:** Where living specs and plans are stored locally. The plugin creates `{specs_root}/{ISSUE-ID}/` for each issue.
> **Suggestion:** `specs` — matches the Turn2C pattern. Use `docs/specs` or `tasks` if that fits better.

Ask: "Where should specs be stored? (relative path from workspace root)"
Default: `specs`

---

### 11. Tasks root directory (optional)
> **What it is:** A secondary directory for QA evidence, test results, and task-specific artifacts. Leave blank if you keep everything under specs.
> **Suggestion:** `qa/tasks` (Turn2C pattern) or leave blank

Ask: "Is there a separate directory for QA/task artifacts? (leave blank if not)"

---

### 12. Code language
> **What it is:** The language production code should be written in — identifiers, variable names, method names, class names.
> **Options:** `english` (strongly recommended for code) · `portuguese-br` · `spanish` · other

Ask: "What language should production code be written in?"
Suggest: `english` — code is read internationally and by tools that expect English identifiers.

---

### 13. Documentation language
> **What it is:** The language for docs, specs, README files, and comments (if allowed).
> **Options:** `english` · `portuguese-br` · `spanish` · other

Ask: "What language should documentation be written in?"

---

### 14. Terminal / conversation language
> **What it is:** The language Claude uses when communicating with you in the terminal — responses, questions, status messages.
> **Options:** `english` · `portuguese-br` · `spanish` · other

Ask: "What language should Claude use when talking to you in the terminal?"

---

### 15. Commit message language
> **What it is:** The language for git commit messages.
> **Options:** `english` (recommended — works with all git tooling) · `portuguese-br` · `spanish` · other

Ask: "What language should commit messages be written in?"
Suggest: `english`

---

### 16. PR description language
> **What it is:** The language for pull/merge request descriptions and review comments.
> **Options:** `english` · `portuguese-br` · `spanish` · other

Ask: "What language should PR descriptions and reviews be written in?"

---

### 17. No-comments rule
> **What it is:** Whether production code should contain zero inline comments. When enabled, the no-comments hook will flag any comment introduced in a code file.
> **Options:** `true` (no comments in code — clean code philosophy) · `false` (comments allowed)

Ask: "Should production code be comment-free? (true/false)"
Suggest: `true` — self-documenting code is a strong practice.

---

### 18. Code style / stack
> **What it is:** The primary language and framework, used to guide the developer agent and quality-gate.
> **Suggestion:** e.g. `java-spring-boot`, `node-express`, `python-fastapi`, `react-typescript`, `ruby-rails`

Ask: "What is the primary stack for this engagement?"

---

### 19. Test framework
> **What it is:** The testing library used for unit and integration tests. Guides the tester agent.
> **Suggestion:** e.g. `junit5-mockito`, `jest`, `pytest`, `rspec`, `vitest`

Ask: "What test framework does this engagement use?"

---

### 20. Build tool
> **What it is:** The build/dependency management tool. Used to run tests and builds in hooks and skills.
> **Suggestion:** e.g. `maven`, `gradle`, `npm`, `yarn`, `pip`, `cargo`

Ask: "What build tool does this engagement use?"

---

### 21. Branch naming pattern
> **What it is:** The naming convention for feature branches. Used when creating worktrees and generating branch names.
> **Suggestion:** e.g. `feature/{ISSUE-ID}-{description}`, `{ISSUE-ID}/{description}`, `feat/{description}`

Ask: "What is the branch naming pattern for this engagement?"

---

### 22. Commit message convention
> **What it is:** The format standard for commit messages.
> **Options:** `conventional` (feat:, fix:, chore: etc.) · `gitmoji` · `free` (no convention) · describe your own

Ask: "What commit message convention does this engagement use?"
Suggest: `conventional`

---

## After collecting all answers

1. Create `.jtgp/` directory if it does not exist.
2. Write `.jtgp/config.json` with all collected values.
3. Add `.jtgp/` to `.gitignore` — append if the file exists, create if it does not.
4. Display a summary table of what was configured.
5. Tell the user: "Setup complete. Run `/jtgp:spec {ISSUE-ID}` to start your first issue."

If the user skips an optional field (tasks_root, kb details, kb_local_patterns), leave it as an empty string or empty array — do not invent values.

## Update mode (`/jtgp:setup --update`)

When called with `--update`, do not re-ask all questions. Instead:
1. Read the existing `.jtgp/config.json`.
2. Identify fields that are missing or empty (fields added in newer plugin versions).
3. Ask only those missing fields — one at a time, with the same descriptions and suggestions as above.
4. Merge the answers into the existing config without touching fields that already have values.
5. Tell the user which fields were added.

This allows the config to stay current as the plugin evolves without forcing a full re-setup.
