# TASK

## Current task

- Title: Build the strongest reusable AI development harness
- Owner: AI agents with user review
- Priority: High
- Due date: Today

## Context

- Problem statement:
  We need a reusable local AI development harness that can be used across projects with Cursor, Claude Code, and Codex. The harness should standardize rules, workflow, safety, prompts, scripts, documentation, and task history.

- Expected outcome:
  This repository becomes a reusable template for AI-assisted development. Cursor, Claude Code, and Codex each have clear roles, startup rules, safety rules, verification steps, and report formats.

- Non-goals:
  - Do not build a full application yet.
  - Do not add unnecessary frameworks.
  - Do not connect paid APIs.
  - Do not expose or commit secrets.
  - Do not make broad refactors unrelated to the harness.

## Acceptance criteria

- [ ] `AGENTS.md` exists and defines shared AI agent rules.
- [ ] `CLAUDE.md` exists and defines Claude Code project memory and working rules.
- [ ] `.cursor/rules/` exists and contains Cursor project rules.
- [ ] `docs/` exists and contains requirements, architecture, workflow, errors, and decisions documents.
- [ ] `prompts/` exists and contains reusable prompts for implementation, debugging, review, and commit.
- [ ] `scripts/` exists and contains repeatable terminal scripts.
- [ ] `.ai/task_history/` exists for recording task outcomes.
- [ ] Important files are not empty.
- [ ] Safety rules mention `.env`, API keys, destructive commands, and preserving existing flows.
- [ ] Final report format is defined.
- [ ] Scripts can be run from the terminal.
- [ ] No secrets are committed.

## Verification plan

- Commands to run:
  - `pwd`
  - `ls -la`
  - `find . -maxdepth 3 -type f | sort`
  - `git status`
  - `bash scripts/doctor.sh`
  - `bash scripts/test.sh`

- Manual checks:
  - Open `AGENTS.md` and confirm shared rules are written.
  - Open `CLAUDE.md` and confirm Claude Code rules are written.
  - Open `.cursor/rules/` and confirm Cursor rule files exist.
  - Open `scripts/doctor.sh` and confirm it checks important files.
  - Confirm `.env` is not committed.

- Rollback plan:
  - If the harness setup breaks or creates unwanted files, use `git status` to inspect changes.
  - Remove only files created for this harness after user approval.
  - If already committed, revert the commit with `git revert`.