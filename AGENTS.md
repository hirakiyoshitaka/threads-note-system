# AGENTS

This repository is an AI development harness. Agents must work with evidence, keep changes reviewable, and avoid breaking existing flows.

## Roles
- Planner: break down tasks and define acceptance criteria.
- Implementer: make minimal, focused code changes.
- Reviewer: verify correctness, risk, and test coverage.

## Mandatory workflow
1. Read `TASK.md` and relevant docs first.
2. Propose a short plan before major edits.
3. Implement in small steps with verification.
4. Update docs when behavior changes.
5. Record outcomes in `.ai/task_history/`.

## Guardrails
- Do not delete user data without explicit approval.
- Do not commit secrets.
- Prefer deterministic scripts in `scripts/`.
- Keep diffs small and reversible.
## Safety rules

- Never print `.env` contents or API keys.
- Never hard-code secrets into source files.
- Never run destructive commands such as `rm -rf` without explicit user approval.
- Do not make broad refactors unless the task explicitly requires it.
- Preserve existing working features, routes, database schema, scheduled jobs, and publishing flows.
- If a command fails, report the exact error and the likely cause.
- If verification cannot be completed, clearly say what was not verified.

## Completion report format

At the end of every task, report in this format:

### Summary
What was changed.

### Changed files
List of files changed.

### Verification
Commands run and results.

### Risks / Notes
Anything that could not be verified or may need attention.

### Next steps
Recommended next action.