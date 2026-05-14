# REQUIREMENTS

## Business goal

Build a reusable local AI development harness that allows the user to run AI-assisted development safely and repeatedly across multiple projects.

The harness should make it clear:

- what each AI agent should do
- what files each agent should read
- how tasks are planned
- how changes are verified
- how results are recorded
- how secrets and existing workflows are protected

## Success metric

The harness is successful when the user can open a project in Cursor, update `TASK.md`, run Claude Code for implementation, run Codex for review, verify the result with scripts, and save the work to GitHub without confusion.

## Functional requirements

- FR-1: Provide shared AI agent rules in `AGENTS.md`.
- FR-2: Provide Claude Code project memory and working rules in `CLAUDE.md`.
- FR-3: Provide Cursor persistent rules in `.cursor/rules/`.
- FR-4: Provide task instructions in `TASK.md`.
- FR-5: Provide reusable prompts in `prompts/`.
- FR-6: Provide repeatable terminal scripts in `scripts/`.
- FR-7: Provide project documentation in `docs/`.
- FR-8: Provide task outcome storage in `.ai/task_history/`.
- FR-9: Provide `.env.example` for environment variable examples.
- FR-10: Provide `.gitignore` to prevent secrets and unnecessary files from being committed.

## Non-functional requirements

### Performance

- Scripts should run quickly.
- The harness should not require heavy frameworks by default.
- The setup should remain lightweight and reusable.

### Reliability

- The workflow should be repeatable.
- The same task flow should work across different projects.
- Verification steps should be documented and runnable from the terminal.

### Security

- `.env` files must not be committed.
- API keys, tokens, passwords, and private certificates must not be printed or hard-coded.
- Destructive commands must require explicit user approval.
- Generated credentials and secret files must be ignored by Git.

### Maintainability

- Files should have clear responsibilities.
- Rules should be easy to update.
- Prompts should be reusable.
- Scripts should be deterministic and simple.
- Documentation should explain decisions and workflow.

## Constraints

### Time

- The first version should be simple and usable immediately.
- Improvements can be added step by step.

### Budget

- Avoid paid services unless explicitly required.
- Do not connect paid APIs during harness setup.

### Tech stack

- Cursor
- Claude Code / Opus
- Codex
- Git
- Bash scripts
- Markdown documentation

## Out of scope

- Building a full application.
- Adding unnecessary frameworks.
- Connecting real API keys.
- Automating paid cloud deployment.
- Making broad changes outside the harness structure.