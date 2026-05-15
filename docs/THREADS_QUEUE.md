# Threads 投稿予約キュー設計

## 目的

2日おきThreads誘導レーンのThreads悩み予告を、手作業のコピー貼り付けから、本人確認付きの投稿キュー方式へ移行するための設計です。

この設計では、いきなり完全自動投稿にしません。まずは以下の流れを固定します。

1. Threads悩み予告を生成する。
2. note下書きを生成する。
3. Threads投稿を `data/threads_queue/` に `review_required` で保存する。
4. `scripts/threads_queue_check.sh` でキューを確認する。
5. 本人確認後に `status` を `approved` に変更する。
6. 将来、Threads API投稿スクリプトで `approved` だけを投稿対象にする。
7. 投稿できたら `status` を `posted` にし、`posted_at` を記録する。

## 守ること

- 既存の毎日note自動配信レーンは変更しない。
- 既存のnote配信フロー、予約済み記事、配信スケジュールを変更しない。
- `review_required` の投稿は自動投稿しない。
- `approved` にする前に、本人が本文、リンク先、投稿予定時刻を確認する。
- APIキーやアクセストークンはコード、JSON、Markdownに直書きしない。
- Threads APIの実投稿は、明示的にDRY RUNを解除するまで行わない。

## 保存先

投稿キューは以下にJSONで保存します。

```txt
data/threads_queue/
```

ファイル名は、日付、サイクル番号、テーマ識別子が分かる形にします。

```txt
YYYY-MM-DD_cycle_001_ai_request.json
```

## JSON項目

各キューファイルは、以下の項目を持ちます。

```json
{
  "theme": "AIに何を頼めばいいか分からない",
  "threads_text": "投稿本文",
  "status": "review_required",
  "linked_note_draft_path": ".ai/reports/threads_note/bidaily_cycle_001_ai_request/note_draft.md",
  "linked_note_url": null,
  "scheduled_at": "2026-05-17T09:00:00+09:00",
  "posted_at": null,
  "error_message": null
}
```

## status

- `review_required`: 生成直後。本人確認が必要。自動投稿対象外。
- `approved`: 本人確認済み。将来のThreads API投稿対象。
- `posted`: 投稿済み。`posted_at` を記録する。
- `failed`: 投稿失敗。`error_message` に理由を記録する。

## 本人確認で見ること

- Threads本文が本人の言葉として自然か。
- note下書きとThreadsの悩みが一致しているか。
- noteリンクを入れる場合、`linked_note_url` が正しいか。
- 投稿予定時刻 `scheduled_at` が問題ないか。
- 既存の毎日note自動配信レーンとテーマが衝突していないか。

## 将来のThreads API投稿

将来の投稿スクリプトは `scripts/threads_post_api_stub.py` を土台にします。

- `THREADS_ACCESS_TOKEN` を環境変数から読む。
- `THREADS_USER_ID` を環境変数から読む。
- `approved` 状態のキューだけを投稿対象にする。
- 初期値は `DRY_RUN=true` とし、誤投稿を防ぐ。
- 実投稿処理はThreads APIの仕様確定後にTODO部分へ追加する。
- 投稿成功後は本来 `status` を `posted`、`posted_at` を投稿時刻に更新する。

