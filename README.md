# Threads -> note導線生成システム

最強ハーネスの構成を使って、Threads投稿からnote記事へ自然に誘導するための再利用可能なコンテンツ運用システムです。

noteプロフィールと記事テーマをもとに、Threads投稿、7日分の導線、note CTA、投稿テンプレ、運用手順、検証スクリプトをこのリポジトリ内で管理します。

既存の毎日note自動配信レーンはそのまま継続し、別レーンとして2日おきのThreads悩み予告からnote下書き・予約投稿候補を作る流れを追加します。

## Structure

- `.cursor/rules/`: persistent Cursor rules.
- `docs/`: strategy, workflow, content rules, requirements, architecture, logs.
- `prompts/`: reusable prompts for Threads posts, 7-day planning, note CTA, implementation/debug/review/commit.
- `templates/`: reusable Threads -> note post templates.
- `samples/`: ready-to-post examples.
- `scripts/`: repeatable project checks and local automation.
- `.ai/`: generated reports, plans, reviews, and task history.

## Quick start

1. Read `TASK.md`.
2. Read `docs/STRATEGY.md`, `docs/WORKFLOW.md`, and `docs/CONTENT_RULES.md`.
3. Read `docs/LANES.md` before touching anything related to existing note automation.
4. Pick today's note theme and reader pain.
5. Use `templates/threads_note_post_template.md` to draft the structure.
6. Use `prompts/threads_post_generator.md` to create one Threads post.
7. Use `prompts/note_cta_generator.md` when the CTA needs variants.
8. Run `bash scripts/test.sh` and `bash scripts/doctor.sh` before saving a larger change.

## Daily operation

1. Decide today's theme from the note article.
2. Generate one Threads post with a soft note CTA.
3. Post manually to Threads.
4. Record reactions, clicks, and note results.
5. Use the result to improve tomorrow's hook and CTA.

For weekly planning, use `prompts/threads_7day_plan.md`.

## Two-lane operation

- Existing lane: daily note auto-delivery continues as-is. Do not change its schedule or reserved posts from the new lane.
- New lane: every other day, publish a Threads problem preview, generate the matching note draft, review and rewrite it yourself, then pass it to the existing reservation flow only when it is ready.

Files:

- `docs/LANES.md`
- `prompts/threads_problem_preview_generator.md`
- `prompts/note_draft_from_threads_problem.md`
- `templates/bidaily_threads_note_lane.md`
- `samples/bidaily_threads_note_linked_plan.md`

## Sample output

- 7 ready-to-post Threads examples are saved in `samples/threads_7posts_yonpi.md`.
- The reusable post template is saved in `templates/threads_note_post_template.md`.

## Principles

- Keep changes small and testable.
- Prefer explicit docs over hidden assumptions.
- Never break existing workflows without approval.
- Do not fabricate results, testimonials, urgency, or income claims.
- Do not auto-post to Threads or note from this project.

## Included automation examples

- Threads to note monetization workflow:
  - `bash scripts/threads_note_automation.sh init ...`
  - `bash scripts/threads_note_automation.sh log ...`
  - `bash scripts/threads_note_automation.sh report ...`
  - See `docs/THREADS_NOTE_AUTOMATION.md`

## Harness roles

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
