# Task History

## Date

2026-05-15

## Task

Threadsからnoteへの導線を最適化し、投稿テンプレ作成・CTAテスト・UTM追跡・KPI集計を再利用可能な自動化として追加。

## Changed files

- README.md
- scripts/doctor.sh
- scripts/threads_note_automation.sh
- docs/THREADS_NOTE_AUTOMATION.md
- prompts/threads_note_growth.md
- prompts/implement.md

## Verification

- `bash scripts/threads_note_automation.sh init --campaign "検証キャンペーン" --theme "note販売" --note-url "https://note.com/example/n/abc123" --price "980"`: OK
- `bash scripts/threads_note_automation.sh log --campaign "検証キャンペーン" --date "2026-05-15" --cta-id "cta_c" --impressions 1000 --clicks 50 --sales 3 --revenue 2940`: OK
- `bash scripts/threads_note_automation.sh report --campaign "検証キャンペーン"`: OK
- `bash scripts/threads_note_automation.sh log --campaign "検証キャンペーン" --date "2026-05-15" --cta-id "cta_x" --impressions 100 --clicks 10 --sales 1 --revenue 980`: expected failure (invalid CTA rejected)
- `bash scripts/threads_note_automation.sh log --campaign "検証キャンペーン" --date "2026-05-15" --cta-id "cta_a" --impressions 100 --clicks '1;system("touch /tmp/pwned")' --sales 1 --revenue 980`: expected failure (injection payload rejected)
- `bash scripts/doctor.sh`: OK
- `bash scripts/test.sh`: OK

## Result

完了。Threads→note導線のコンテンツ生成・計測・改善ループをローカルで安全に運用できる状態にした。

## Risks / Notes

- 本実装は投稿文生成と計測の自動化であり、Threads/noteへの直接投稿自動化は含まない（規約・API差異リスク回避）。
- KPIの真値は運用者の入力品質に依存するため、日次入力運用を前提とする。

## Next steps

- 実キャンペーン名と本番note URLで `init` を実行。
- 7日運用後に `report` を生成し、勝ちCTAで次週テンプレを再生成。
