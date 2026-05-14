# ARCHITECTURE

## System overview

This repository is a reusable local AI development harness.

It is not a full application by itself.  
It is a standard workspace structure that helps the user run AI-assisted development safely with Cursor, Claude Code, and Codex.

The harness provides:

- shared agent rules
- Claude Code project memory
- Cursor persistent project rules
- task definitions
- reusable prompts
- repeatable scripts
- documentation
- task history records
- safety rules for secrets, Git, and existing flows

## Major components

### Cursor workspace

Cursor is used as the main visual workspace.

Responsibilities:

- open the project folder
- edit Markdown and code files
- review file changes
- inspect diffs
- manage project context
- use `.cursor/rules/` as persistent project rules

### Claude Code

Claude Code is used as the main implementation agent.

Responsibilities:

- read `AGENTS.md`
- read `CLAUDE.md`
- read `TASK.md`
- read relevant files in `docs/`
- propose an implementation plan
- make small, focused changes
- run verification commands
- report changed files and results
- record outcomes in `.ai/task_history/`

### Codex

Codex is used as the review and verification agent.

Responsibilities:

- review Claude Code changes
- check whether `TASK.md` was followed
- check Git safety
- check for exposed secrets
- check whether tests or scripts were run
- suggest minimal fixes only when needed

### Documentation layer

The `docs/` folder stores long-term project knowledge.

Responsibilities:

- define requirements
- explain architecture
- specify expected behavior
- document workflow
- track errors
- record decisions

### Prompt layer

The `prompts/` folder stores reusable prompts.

Responsibilities:

- provide repeatable implementation prompts
- provide debugging prompts
- provide review prompts
- provide commit prompts

### Script layer

The `scripts/` folder stores deterministic terminal commands.

Responsibilities:

- check project health
- run tests
- start the project
- create snapshots
- reduce repeated manual work

### AI history layer

The `.ai/` folder stores AI-generated working records.

Responsibilities:

- store task plans
- store reports
- store reviews
- store task history

## Boundaries

### UI layer

The UI layer is Cursor itself.

This harness does not define a product UI by default.  
When copied into an actual app project, UI rules are provided by:

- `.cursor/rules/30_ui_rules.mdc`
- project-specific UI files

### Application/service layer

The application/service layer depends on the project where this harness is copied.

The harness itself only provides:

- rules
- prompts
- docs
- scripts
- workflow

### Data/integration layer

The harness does not connect to real APIs by default.

Environment variable examples are stored in:

- `.env.example`

Real secrets must be placed only in:

- `.env`

and must never be committed.

## Data flow

### 1. Input

The user writes the active task in:

- `TASK.md`

The AI agents read context from:

- `AGENTS.md`
- `CLAUDE.md`
- `TASK.md`
- `docs/`
- `.cursor/rules/`

### 2. Planning

Claude Code or another agent summarizes:

- objective
- constraints
- acceptance criteria
- affected files
- implementation plan

### 3. Implementation

Claude Code makes small, focused changes.

Expected behavior:

- avoid broad refactors
- preserve existing flows
- protect secrets
- update docs when behavior changes
- keep changes reviewable

### 4. Verification

The user or agent runs:

- `git status`
- `git diff --stat`
- `bash scripts/doctor.sh`
- `bash scripts/test.sh`

Codex reviews the changes.

### 5. Output

The task result is recorded in:

- `.ai/task_history/`

The final result is saved with Git:

- `git add .`
- `git commit`
- `git push`

## Key decisions

### Decision A: Use `AGENTS.md` as the shared rulebook

Reason:

All AI agents need one common source of rules.

Impact:

Cursor, Claude Code, Codex, and future agents can follow the same safety and workflow standards.

### Decision B: Use `TASK.md` as the active task file

Reason:

The user needs one simple place to describe what should be done today.

Impact:

AI agents can avoid guessing and work from a clear objective.

### Decision C: Use `.cursor/rules/` for Cursor-specific behavior

Reason:

Cursor can apply persistent project rules from this folder.

Impact:

Cursor responses and edits stay aligned with the project standards.

### Decision D: Use `scripts/` for repeatable checks

Reason:

Manual checking is easy to forget.

Impact:

The same checks can be run every time before review or commit.

### Decision E: Use Codex as reviewer after Claude Code implementation

Reason:

Separating implementation and review reduces the risk of unchecked mistakes.

Impact:

Claude Code builds. Codex checks. Cursor displays. The user decides.

## Risks

### Risk: An AI agent edits too many files

Mitigation:

- Keep tasks scoped in `TASK.md`.
- Require a plan before major edits.
- Review `git diff --stat`.
- Keep changes small and reversible.

### Risk: Secrets are exposed or committed

Mitigation:

- Keep real secrets in `.env`.
- Commit only `.env.example`.
- Use `.gitignore`.
- Review `git status` before commit.

### Risk: Existing working flows are broken

Mitigation:

- Preserve existing behavior by default.
- Use `.cursor/rules/40_no_breaking_existing_flow.mdc`.
- Require explicit approval for breaking changes.
- Include rollback notes for risky edits.

### Risk: Verification is skipped

Mitigation:

- Use `scripts/doctor.sh`.
- Use `scripts/test.sh`.
- Require final verification notes.
- Do not mark tasks complete unless checks were attempted.

### Risk: User gets confused about where to paste commands

Mitigation:

- Use Cursor Terminal as the default terminal.
- Put repeatable commands in `scripts/`.
- Keep instructions in `README.md` and `docs/WORKFLOW.md`.