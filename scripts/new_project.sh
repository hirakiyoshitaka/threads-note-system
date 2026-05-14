#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_REPO="https://github.com/hirakiyoshitaka/saikyo-harness.git"
BASE_DIR="$HOME"

if [[ $# -lt 1 ]]; then
  echo "使い方:"
  echo "  bash scripts/new_project.sh <プロジェクト名>"
  echo ""
  echo "例:"
  echo "  bash scripts/new_project.sh 自動化"
  exit 1
fi

PROJECT_TITLE="$1"
PROJECT_DIR="$BASE_DIR/$PROJECT_TITLE"

echo "====================================="
echo "[new-project] 最強ハーネス新規プロジェクト作成"
echo "====================================="
echo ""
echo "[new-project] title: $PROJECT_TITLE"
echo "[new-project] dir:   $PROJECT_DIR"
echo ""

if [[ -d "$PROJECT_DIR" ]]; then
  echo "[error] 既に同名フォルダがあります:"
  echo "$PROJECT_DIR"
  echo ""
  echo "別名にするか、不要なら既存フォルダを削除してから再実行してください。"
  exit 1
fi

echo "[new-project] templateをコピーします"
git clone "$TEMPLATE_REPO" "$PROJECT_DIR"

cd "$PROJECT_DIR"

echo "[new-project] Git履歴を新規プロジェクト用に切り離します"
rm -rf .git
git init
git branch -M main

echo "[new-project] AI用フォルダを確認します"
mkdir -p .ai/reports .ai/plans .ai/reviews .ai/task_history

echo "[new-project] scriptsに実行権限を付けます"
chmod +x scripts/*.sh || true

echo "[new-project] TASK.md を ${PROJECT_TITLE} 用に書き換えます"

cat > TASK.md <<TASK
# TASK

## Current task

- Title: Build ${PROJECT_TITLE}
- Owner: AI agents with user review
- Priority: High
- Due date: Today

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

## Verification plan

- Commands to run:
  - \`git status\`
  - \`bash scripts/doctor.sh\`
  - \`bash scripts/test.sh\`

- Manual checks:
  - Cursorでファイル構成を見る
  - TASK.md が ${PROJECT_TITLE} 用になっているか確認する
  - Claude CodeがAGENTS.md / CLAUDE.md / TASK.mdを読めるか確認する

- Rollback plan:
  - 問題があれば \`git restore\` で戻す
  - コミット後なら \`git revert\` で戻す
TASK

echo ""
echo "[new-project] doctorを実行します"
bash scripts/doctor.sh || true

echo ""
echo "[new-project] testを実行します"
bash scripts/test.sh || true

echo ""
echo "====================================="
echo "[new-project] 完了"
echo "====================================="
echo ""
echo "作成されたフォルダ:"
echo "$PROJECT_DIR"
echo ""
echo "次にやること:"
echo "1. Cursorでこのフォルダを開く"
echo "   File → Open Folder... → $PROJECT_DIR"
echo ""
echo "2. Cursor TerminalでClaude Codeを起動"
echo "   claude --dangerously-skip-permissions"
echo ""
echo "3. Claude Codeに貼る最初の指示:"
echo ""
echo "AGENTS.md、CLAUDE.md、TASK.md、docs/、.cursor/rules/ を読んでください。"
echo "このプロジェクトは「${PROJECT_TITLE}」です。"
echo "最強ハーネスの構成を壊さず、TASK.md の内容どおりに実装してください。"
echo "まず目的、制約、完了条件、影響ファイル、作業計画を出してください。"