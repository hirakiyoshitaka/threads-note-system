#!/usr/bin/env bash
set -euo pipefail

echo "====================================="
echo "[test] AI Development Harness Tests"
echo "====================================="
echo ""

echo "[test] running doctor check"

if [[ -x "./scripts/doctor.sh" ]]; then
  ./scripts/doctor.sh
else
  bash ./scripts/doctor.sh
fi

echo ""
echo "[test] checking markdown files exist"

required_docs=(
  "README.md"
  "TASK.md"
  "AGENTS.md"
  "CLAUDE.md"
  "docs/REQUIREMENTS.md"
  "docs/ARCHITECTURE.md"
  "docs/SPEC.md"
  "docs/WORKFLOW.md"
  "docs/STRATEGY.md"
  "docs/LANES.md"
  "docs/THREADS_QUEUE.md"
  "docs/CONTENT_RULES.md"
  "docs/ERROR_LOG.md"
  "docs/DECISIONS.md"
  "prompts/threads_post_generator.md"
  "prompts/threads_7day_plan.md"
  "prompts/note_cta_generator.md"
  "prompts/threads_problem_preview_generator.md"
  "prompts/note_draft_from_threads_problem.md"
  "prompts/rewrite_note_with_human_answers.md"
  "templates/threads_note_post_template.md"
  "templates/bidaily_threads_note_lane.md"
  "templates/human_rewrite_answer_sheet.md"
  "samples/threads_7posts_yonpi.md"
  "samples/bidaily_threads_note_linked_plan.md"
  ".ai/reports/threads_note/bidaily_cycle_001_ai_request/human_answer_sheet.md"
  "data/threads_queue/2026-05-15_cycle_001_ai_request.json"
  "scripts/threads_queue_check.py"
  "scripts/threads_queue_check.sh"
  "scripts/threads_post_api_stub.py"
)

for f in "${required_docs[@]}"; do
  if [[ -s "$f" ]]; then
    echo "[ok] $f"
  else
    echo "[fail] missing or empty: $f"
    exit 1
  fi
done

echo ""
echo "[test] project-specific tests"

echo "[test] checking Threads queue"
bash scripts/threads_queue_check.sh

echo "[test] checking Threads API poster dry run"
python3 scripts/threads_post_api_stub.py

echo "[test] compiling Threads scripts"
PYTHONPYCACHEPREFIX="${TMPDIR:-/tmp}/threads_pycache" python3 -m py_compile scripts/threads_queue_check.py scripts/threads_post_api_stub.py

if [[ -f "package.json" ]]; then
  echo "[info] package.json found"
  echo "[info] add npm test here when the project has tests"
fi

if [[ -d "tests" ]]; then
  echo "[info] tests/ directory found"
  echo "[info] add pytest or project-specific test command here"
fi

echo ""
echo "[test] result: OK"
echo "[test] done"
