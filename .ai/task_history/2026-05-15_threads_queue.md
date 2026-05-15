# Task History

## Date

2026-05-15

## Task

2日おきThreads誘導レーンに、本人確認付きのThreads投稿予約キューと将来のThreads API投稿スタブを追加した。

## Changed files

- docs/THREADS_QUEUE.md
- data/threads_queue/2026-05-15_cycle_001_ai_request.json
- scripts/threads_queue_check.py
- scripts/threads_queue_check.sh
- scripts/threads_post_api_stub.py
- docs/WORKFLOW.md
- docs/LANES.md
- scripts/test.sh
- scripts/doctor.sh
- .ai/task_history/2026-05-15_threads_queue.md

## Outcomes

- Threads投稿キューの設計文書を追加。
- 1サイクル目のThreads悩み予告を `review_required` でキュー登録。
- 投稿キュー確認スクリプトを追加。
- 将来のThreads API投稿スタブを追加。
- DRY RUNを初期値にして誤投稿を防ぐ。

## Verification

### Commands

- `bash scripts/threads_queue_check.sh`
- `bash scripts/test.sh`
- `bash scripts/doctor.sh`

### Result

- `bash scripts/threads_queue_check.sh`: OK
- `bash scripts/test.sh`: OK
- `bash scripts/doctor.sh`: OK

## Risks / Notes

- 既存の毎日note自動配信レーンは変更しない。
- `review_required` の投稿は自動投稿対象外。
- `THREADS_ACCESS_TOKEN` と `THREADS_USER_ID` は環境変数で読み、コードには直書きしない。
- git commit は行わない。

## Next actions

- 本人が `data/threads_queue/2026-05-15_cycle_001_ai_request.json` を確認する。
- 問題なければ `status` を `approved` に変更する。
- Threads API仕様確定後に `scripts/threads_post_api_stub.py` のTODOへ実投稿処理を追加する。
