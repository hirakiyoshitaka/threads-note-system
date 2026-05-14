# 最強ハーネス (AI Development Harness)

A starter workspace for running AI-assisted development with clear rules, prompts, scripts, and documentation.

## Structure
- `.cursor/rules/`: persistent Cursor rules.
- `docs/`: requirements, architecture, specs, workflow, logs.
- `prompts/`: reusable prompts for implementation/debug/review/commit.
- `scripts/`: repeatable project commands.
- `.ai/`: generated plans, reports, reviews, and task history.

## Quick start
1. Copy `.env.example` to `.env` and fill values.
2. Update `TASK.md` with the active objective.
3. Run `scripts/doctor.sh`.
4. Start your project with `scripts/run.sh`.

## Principles
- Keep changes small and testable.
- Prefer explicit docs over hidden assumptions.
- Never break existing workflows without approval.
## AI roles

### Cursor
Use Cursor as the main workspace for:
- Opening the project folder
- Editing files
- Reviewing diffs
- Managing project context

### Claude Code
Use Claude Code as the main implementation agent for:
- Reading `AGENTS.md`, `CLAUDE.md`, and `TASK.md`
- Proposing an implementation plan
- Editing files
- Running checks
- Reporting results

### Codex
Use Codex as the reviewer for:
- Reviewing Claude Code changes
- Checking safety and correctness
- Verifying tests and scripts
- Suggesting minimal fixes

## Standard workflow

1. Open this folder in Cursor.
2. Update `TASK.md`.
3. Open Cursor Terminal.
4. Run `git status`.
5. Start Claude Code.
6. Ask Claude Code to read `AGENTS.md`, `CLAUDE.md`, and `TASK.md`.
7. Let Claude Code plan and implement.
8. Run `scripts/doctor.sh` and `scripts/test.sh`.
9. Start Codex.
10. Ask Codex to review the changes.
11. Review diffs in Cursor.
12. Commit and push to GitHub.