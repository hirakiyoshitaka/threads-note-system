#!/usr/bin/env bash
set -euo pipefail

echo "====================================="
echo "[run] AI Development Harness"
echo "====================================="
echo ""

echo "[run] This repository is a reusable AI development harness."
echo "[run] It is not a standalone app by default."
echo ""

echo "[run] Standard workflow:"
echo "  1. Open this folder in Cursor"
echo "  2. Edit TASK.md"
echo "  3. Run: bash scripts/doctor.sh"
echo "  4. Run: bash scripts/test.sh"
echo "  5. Start Claude Code: claude"
echo "  6. Review with Codex: codex"
echo "  7. Commit and push when ready"
echo ""

echo "[run] Useful commands:"
echo "  git status"
echo "  git diff --stat"
echo "  bash scripts/doctor.sh"
echo "  bash scripts/test.sh"
echo "  bash scripts/snapshot.sh"
echo ""

if [[ -f "package.json" ]]; then
  echo "[run] package.json found."
  echo "[run] If this is a Node project, you may run:"
  echo "  npm install"
  echo "  npm run dev"
  echo ""
fi

if [[ -f "app.py" ]]; then
  echo "[run] app.py found."
  echo "[run] If this is a Streamlit project, you may run:"
  echo "  streamlit run app.py"
  echo ""
fi

if [[ -f "main.py" ]]; then
  echo "[run] main.py found."
  echo "[run] If this is a Python project, you may run:"
  echo "  python3 main.py"
  echo ""
fi

echo "[run] done"