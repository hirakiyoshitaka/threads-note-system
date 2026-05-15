# Task History

## Date

2026-05-15

## Task

Threads投稿キューの `approved` 投稿だけを、DRY RUN解除時にThreads APIで実投稿できるようにした。

## Changed files

- scripts/threads_post_api_stub.py
- docs/THREADS_QUEUE.md
- docs/WORKFLOW.md
- scripts/test.sh
- .ai/task_history/2026-05-15_threads_api_posting.md

## Outcomes

- `DRY_RUN=true` では投稿対象確認のみで、API通信もJSON更新もしない。
- `DRY_RUN=false` かつ `approved` の投稿だけ、Threads APIのコンテナ作成とpublish対象にする。
- 投稿成功後は `status=posted`、`posted_at`、取得できた場合は `threads_post_id` を保存する。
- 投稿失敗時は `approved` のまま `error_message` に理由を残す。
- トークンは環境変数から読み、ログには表示しない。

## Verification

### Commands

- `bash scripts/threads_queue_check.sh`
- `python3 scripts/threads_post_api_stub.py`
- `bash scripts/test.sh`
- `bash scripts/doctor.sh`

### Result

- `bash scripts/threads_queue_check.sh`: OK
- `python3 scripts/threads_post_api_stub.py`: OK。DRY RUNで `approved` 1件を投稿対象として認識し、実投稿なし。
- `bash scripts/test.sh`: OK
- `bash scripts/doctor.sh`: OK

## Risks / Notes

- 既存の毎日note自動配信レーンは変更しない。
- `DRY_RUN=false` は実投稿を行うため、本番トークン設定前に必ずキュー確認する。
- git commit は行わない。

## Next actions

- 実投稿する場合は `THREADS_ACCESS_TOKEN` と `THREADS_USER_ID` を環境変数に設定する。
- `bash scripts/threads_queue_check.sh` とDRY RUN確認後に `DRY_RUN=false python3 scripts/threads_post_api_stub.py` を実行する。
