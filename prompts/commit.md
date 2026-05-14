# Commit Prompt

You are preparing a clean and safe Git commit.

## Purpose

This prompt is used before committing changes to Git.

The goal is to make sure:

- only relevant files are committed
- secrets are not committed
- generated or heavy files are not committed
- verification was attempted
- the commit message is clear
- the user understands what will be saved

## Input

- Changes: {{changes}}
- Why: {{rationale}}

## Required reading

Before preparing a commit, read or inspect:

1. `AGENTS.md`
2. `TASK.md`
3. `.gitignore`
4. Current Git status
5. Current Git diff summary
6. Verification results, if available

## Safety rules

- Do not commit `.env`.
- Do not commit `.env.local`.
- Do not commit API keys.
- Do not commit tokens.
- Do not commit passwords.
- Do not commit private certificates.
- Do not commit generated credentials.
- Do not commit unnecessary large folders.
- Do not rewrite Git history unless explicitly requested.
- Do not push unless the user asked to push or the workflow explicitly says to push.

## Files that must not be committed by default

Check carefully that these are not staged:

- `.env`
- `.env.local`
- `node_modules/`
- `venv/`
- `.venv/`
- `output/`
- `outputs/`
- `dist/`
- `build/`
- `.DS_Store`
- `__pycache__/`
- `.pytest_cache/`
- private key files
- generated credential files
- temporary files

## Instructions

1. Run or review `git status`.
2. Run or review `git diff --stat`.
3. Confirm the changed files match `TASK.md`.
4. Confirm no secrets are included.
5. Confirm no unnecessary generated folders are included.
6. Confirm tests or checks were attempted.
7. If verification failed, report the failure clearly.
8. If verification was not run, explain why.
9. Suggest a concise commit message.
10. Ask for user approval before committing if there is any risk.
11. After commit, report the commit result.
12. Push only if approved or explicitly requested.

## Suggested terminal flow

Run these commands in order:

    git status
    git diff --stat

If the changed files look correct:

    git add .
    git status

If no secrets or unwanted files are staged:

    git commit -m "Describe the completed task"

If push is approved:

    git push

## Commit message rules

Use a short message that explains what changed.

Good examples:

    git commit -m "Add reusable AI development harness"
    git commit -m "Add Claude and Codex workflow rules"
    git commit -m "Add verification scripts for harness setup"
    git commit -m "Update workflow documentation"

Avoid vague messages:

    git commit -m "fix"
    git commit -m "update"
    git commit -m "changes"
    git commit -m "stuff"

## Review checklist before commit

Confirm:

- [ ] `TASK.md` was followed.
- [ ] Changed files are relevant.
- [ ] Diff is small enough to review.
- [ ] `.env` is not included.
- [ ] API keys are not included.
- [ ] Tokens are not included.
- [ ] Passwords are not included.
- [ ] Private keys are not included.
- [ ] `node_modules/` is not included.
- [ ] `venv/` or `.venv/` is not included.
- [ ] `output/`, `dist/`, or `build/` are not included unless explicitly required.
- [ ] Verification was attempted.
- [ ] Risks are documented.
- [ ] Commit message is clear.

## If unwanted files are staged

Do not commit.

First report the issue.

Then suggest removing them from staging.

Example commands:

    git restore --staged .env
    git restore --staged node_modules
    git restore --staged output

If the file should never be committed, update `.gitignore`.

## If verification failed

Do not say the task is complete.

Report:

- which command failed
- the exact error
- likely cause
- whether the commit should wait
- what should be fixed next

## If everything is safe

Report that the commit is ready.

Then provide:

- files to commit
- verification result
- suggested commit message
- whether push is recommended

## Final report format

### Commit readiness

Ready or not ready.

### Files to commit

List relevant files.

### Verification

Commands or checks run and their results.

### Risks / Notes

Any remaining risk or unclear point.

### Commit message

Suggested commit message.

### Push status

Say whether push was done or still pending.