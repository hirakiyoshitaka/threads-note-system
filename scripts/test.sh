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
  "docs/CONTENT_RULES.md"
  "docs/ERROR_LOG.md"
  "docs/DECISIONS.md"
  "prompts/threads_post_generator.md"
  "prompts/threads_7day_plan.md"
  "prompts/note_cta_generator.md"
  "templates/threads_note_post_template.md"
  "samples/threads_7posts_yonpi.md"
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
