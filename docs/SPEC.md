# SPEC

## Feature

- Name: Reusable AI Development Harness
- Owner: User with AI agent support
- Status: Initial reusable template

## Purpose

This harness standardizes how Cursor, Claude Code, and Codex work together on software projects.

It provides:

- common AI rules
- project-specific task instructions
- persistent Cursor rules
- Claude Code memory
- reusable prompts
- repeatable scripts
- documentation templates
- task history records
- Git and secret safety rules

## API / Interface

This harness does not expose a web API by default.

The main interfaces are files and terminal commands.

### Inputs

Primary user input:

- `TASK.md`

Supporting context:

- `AGENTS.md`
- `CLAUDE.md`
- `README.md`
- `docs/REQUIREMENTS.md`
- `docs/ARCHITECTURE.md`
- `.cursor/rules/*.mdc`
- `prompts/*.md`

Terminal commands:

- `bash scripts/doctor.sh`
- `bash scripts/test.sh`
- `bash scripts/run.sh`
- `bash scripts/snapshot.sh`
- `git status`
- `git diff --stat`

### Outputs

Expected outputs:

- updated project files
- implementation plans
- review notes
- verification results
- task history records
- Git commits
- GitHub push result

Output folders:

- `.ai/plans/`
- `.ai/reports/`
- `.ai/reviews/`
- `.ai/task_history/`

### Errors

Common errors:

- missing required files
- empty important files
- script permission errors
- missing Git repository
- missing runtime tools
- failed tests
- accidental secret files
- unclear task instructions

Expected handling:

- report the exact error
- explain likely cause
- suggest the next action
- do not hide failures
- do not mark task complete unless verification was attempted

## State transitions

### Initial

The project contains the harness structure:

- `AGENTS.md`
- `CLAUDE.md`
- `TASK.md`
- `README.md`
- `.cursor/rules/`
- `docs/`
- `prompts/`
- `scripts/`
- `.ai/`
- `.env.example`
- `.gitignore`

### Intermediate

The user updates `TASK.md`.

Claude Code reads the rules, proposes a plan, edits files, and runs checks.

Codex reviews the current changes.

Cursor is used to inspect files and diffs.

### Final

The task is verified, documented, and recorded.

Expected final actions:

- update `.ai/task_history/`
- run verification scripts
- review `git status`
- review `git diff --stat`
- commit changes
- push to GitHub when approved

## Edge cases

### Case 1: `TASK.md` is unclear

Expected behavior:

- stop and ask for clarification
- do not make broad assumptions
- propose a small safe plan only if possible

### Case 2: A script does not exist or fails

Expected behavior:

- report the missing script or exact failure
- suggest a fix
- do not claim verification passed

### Case 3: `.env` or secrets appear in Git status

Expected behavior:

- stop before committing
- confirm `.gitignore`
- remove secrets from staging
- tell the user what happened

### Case 4: Claude Code makes broad changes

Expected behavior:

- use Codex review
- inspect `git diff --stat`
- revert or reduce changes if outside `TASK.md`

### Case 5: Existing behavior may break

Expected behavior:

- require explicit approval
- document rollback plan
- update `docs/WORKFLOW.md` if migration is needed

## Test cases

- [ ] Happy path: user updates `TASK.md`, Claude implements, Codex reviews, scripts run, Git commit succeeds.
- [ ] Error path: a verification command fails and the failure is reported clearly.
- [ ] Boundary path: task is unclear and the agent asks for clarification instead of guessing.
- [ ] Security path: `.env` exists locally but is not committed.
- [ ] Git path: `git status` and `git diff --stat` are reviewed before commit.
- [ ] Documentation path: behavior changes are reflected in `docs/`.
- [ ] History path: task outcome is recorded in `.ai/task_history/`.