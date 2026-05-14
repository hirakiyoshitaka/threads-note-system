## Required startup steps

At the start of every session:

1. Read `AGENTS.md`.
2. Read `TASK.md`.
3. Read relevant files in `docs/`.
4. Check the current directory.
5. Check `git status`.
6. Summarize the objective and constraints.
7. Propose a short plan before editing.

## Safety rules

- Never print `.env` contents or API keys.
- Never hard-code secrets into source files.
- Do not run destructive commands without explicit approval.
- Do not perform broad refactors unless the task explicitly requires it.
- Preserve existing working features, routes, database schema, scheduled jobs, and publishing flows.
- When running with dangerous permission modes, stay strictly within the scope of `TASK.md`.

## Implementation rules

- Make small, reviewable changes.
- Prefer deterministic scripts in `scripts/`.
- If behavior changes, update relevant docs.
- If a command fails, report the exact command, result, and likely cause.
- If verification cannot be completed, clearly state what was not verified.
- Record task results in `.ai/task_history/`.

## Final response format

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