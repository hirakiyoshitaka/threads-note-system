#!/usr/bin/env bash
set -euo pipefail

ts="$(date +%Y%m%d-%H%M%S)"
out_dir=".ai/task_history"
out_file="$out_dir/$ts.md"

mkdir -p "$out_dir"

git_status="not a git repository"
git_diff_stat="not available"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_status="$(git status --short || true)"
  git_diff_stat="$(git diff --stat || true)"
fi

cat > "$out_file" <<SNAP
# Task Snapshot

## Timestamp

$ts

## Task

- Summary:
- Status:
- Owner:
- Related TASK.md:

## What changed

- 

## Verification

### Commands

- 

### Result

- 

## Git status at snapshot time

\`\`\`txt
$git_status
\`\`\`

## Git diff stat at snapshot time

\`\`\`txt
$git_diff_stat
\`\`\`

## Risks / Notes

- 

## Next actions

- 
SNAP

echo "[snapshot] wrote $out_file"