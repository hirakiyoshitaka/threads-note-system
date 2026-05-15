#!/usr/bin/env bash
set -euo pipefail

echo "====================================="
echo "[doctor] AI Development Harness Check"
echo "====================================="
echo ""

echo "[doctor] project root:"
pwd
echo ""

echo "[doctor] required files"

files=(
  "AGENTS.md"
  "CLAUDE.md"
  "TASK.md"
  "README.md"
  ".env.example"
  ".gitignore"
  ".cursor/rules/00_project_core.mdc"
  ".cursor/rules/10_quality_rules.mdc"
  ".cursor/rules/20_git_rules.mdc"
  ".cursor/rules/30_ui_rules.mdc"
  ".cursor/rules/40_no_breaking_existing_flow.mdc"
  "docs/REQUIREMENTS.md"
  "docs/ARCHITECTURE.md"
  "docs/SPEC.md"
  "docs/WORKFLOW.md"
  "docs/STRATEGY.md"
  "docs/CONTENT_RULES.md"
  "docs/ERROR_LOG.md"
  "docs/DECISIONS.md"
  "prompts/implement.md"
  "prompts/debug.md"
  "prompts/review.md"
  "prompts/commit.md"
  "prompts/threads_post_generator.md"
  "prompts/threads_7day_plan.md"
  "prompts/note_cta_generator.md"
  "prompts/threads_note_growth.md"
  "templates/threads_note_post_template.md"
  "samples/threads_7posts_yonpi.md"
  "scripts/doctor.sh"
  "scripts/test.sh"
  "scripts/run.sh"
  "scripts/snapshot.sh"
  "scripts/new_project.sh"
  "scripts/threads_note_automation.sh"
)

missing=0

for f in "${files[@]}"; do
  if [[ -f "$f" ]]; then
    if [[ -s "$f" ]]; then
      echo "[ok] $f"
    else
      echo "[empty] $f"
      missing=1
    fi
  else
    echo "[missing] $f"
    missing=1
  fi
done

echo ""
echo "[doctor] required directories"

dirs=(
  ".cursor/rules"
  "docs"
  "prompts"
  "templates"
  "samples"
  "scripts"
  ".ai"
  ".ai/reports"
  ".ai/plans"
  ".ai/reviews"
  ".ai/task_history"
)

for d in "${dirs[@]}"; do
  if [[ -d "$d" ]]; then
    echo "[ok] $d/"
  else
    echo "[missing] $d/"
    missing=1
  fi
done

echo ""
echo "[doctor] tools"

if command -v git >/dev/null 2>&1; then
  echo "[ok] git: $(git --version)"
else
  echo "[missing] git"
  missing=1
fi

if command -v node >/dev/null 2>&1; then
  echo "[ok] node: $(node -v)"
else
  echo "[info] node not found"
fi

if command -v npm >/dev/null 2>&1; then
  echo "[ok] npm: $(npm -v)"
else
  echo "[info] npm not found"
fi

if command -v python3 >/dev/null 2>&1; then
  echo "[ok] python3: $(python3 --version)"
else
  echo "[info] python3 not found"
fi

if command -v claude >/dev/null 2>&1; then
  echo "[ok] claude found"
else
  echo "[info] claude command not found"
fi

if command -v codex >/dev/null 2>&1; then
  echo "[ok] codex found"
else
  echo "[info] codex command not found"
fi

echo ""
echo "[doctor] git status"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "[ok] inside git repository"
  git status --short
else
  echo "[info] not a git repository yet"
fi

echo ""
echo "[doctor] secret safety check"

if [[ -f ".env" ]]; then
  echo "[ok] .env exists locally"
  if git check-ignore .env >/dev/null 2>&1; then
    echo "[ok] .env is ignored by git"
  else
    echo "[warning] .env is NOT ignored by git"
    missing=1
  fi
else
  echo "[info] .env does not exist yet"
fi

echo ""
if [[ "$missing" -eq 0 ]]; then
  echo "[doctor] result: OK"
else
  echo "[doctor] result: CHECK NEEDED"
fi

echo "[doctor] done"
