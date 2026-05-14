#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_REPO="https://github.com/hirakiyoshitaka/saikyo-harness.git"
BASE_DIR="$HOME"

if [[ $# -lt 1 ]]; then
  echo "Usage: bash scripts/new_project.sh <project-title>"
  echo "Example: bash scripts/new_project.sh 占いカレンダー"
  exit 1
fi

PROJECT_TITLE="$1"
PROJECT_DIR="$BASE_DIR/$PROJECT_TITLE"

echo "====================================="
echo "[new-project] 最強ハーネス新規プロジェクト作成"
echo "====================================="
echo "[new-project] title: $PROJECT_TITLE"
echo "[new-project] dir:   $PROJECT_DIR"
echo ""

if [[ -d "$PROJECT_DIR" ]]; then
  echo "[error] 既に同名フォルダがあります: $PROJECT_DIR"
  exit 1
fi

git clone "$TEMPLATE_REPO" "$PROJECT_DIR"

cd "$PROJECT_DIR"

rm -rf .git
git init
git branch -M main

mkdir -p .ai/reports .ai/plans .ai/reviews .ai/task_history
chmod +x scripts/*.sh || true

cat > TASK.md <<TASK
# TASK

## Current task

- Title: Build ${PRdate: Today

## Context

- Problem statement:
  「${PROJECT_TITLE}」という新しいAI開発プロジェクトを作る。
  最強ハーネスの構成を使い、Cursor、Claude Code、Codexで安全に開発する。

- Expected outcome:
  ${PROJECT_TITLE} の初期アプリ構成、README、起動方法、確認方法を整える。
  Claude Codeで実装し、Codexでレビューできる状態にする。

- Non-goals:
  - 最強ハーネス構成を壊さない
  - .env の中身やAPIキーを表示しない
  - 不要な大規模リファクタはしない
  - 課金・本番公開・外部API接続は明示指示があるまで行わない

## Acceptance criteria

- [ ] ${PROJECT_TITLE} 用の基本構成ができている
- [ ] AGENTS.md / CLAUDE.md / docs / prompts / scripts が残っている
- [ ] READMEに起動方法が書かれている
- [ ] scripts/doctor.sh が動く
- [ ] scripts/test.sh が動く
- [ ] Gitに初回コミットできる
- [ ] Codexでレビューできる

## Verifit.sh || true

echo ""
echo "====================================="
echo "[new-project] 完了"
echo "====================================="
echo "作成されたフォルダ:"
echo "$PROJECT_DIR"
echo ""
echo "次にやること:"
echo "1. Cursorで開く: $PROJECT_DIR"
echo "2. Claude起動:"
echo "   claude --dangerously-skip-permissions"
echo ""
echo "Claudeに貼る最初の指示:"
echo "AGENTS.md、CLAUDE.md、TASK.md、docs/、.cursor/rules/ を読んでください。"
echo "このプロジェクトは「${PROJECT_TITLE}」です。"
echo "最強ハーネスの構成を壊さず、TASK.md の内容どおりに実装してください。"
echo "まず目的、制約、完了条件、影響ファイル、作業計画を出してください。"
