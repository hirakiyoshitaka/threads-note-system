# Task History

## Date

2026-05-15

## Task

noteプロフィールと記事テーマをもとに、Threads投稿からnote記事へ自然に誘導する「Threads -> note導線生成システム」を最強ハーネス構成に沿って整理した。

## Changed files

- TASK.md
- README.md
- docs/STRATEGY.md
- docs/WORKFLOW.md
- docs/CONTENT_RULES.md
- prompts/threads_post_generator.md
- prompts/threads_7day_plan.md
- prompts/note_cta_generator.md
- templates/threads_note_post_template.md
- samples/threads_7posts_yonpi.md
- scripts/test.sh
- scripts/doctor.sh
- .ai/task_history/2026-05-15_threads_note_route_generation_system.md

## What changed

- `TASK.md` を今回の目的、作るもの、日次運用、未実装課題、検証方法が分かる内容に更新。
- `prompts/` に、1投稿生成、7日分導線生成、note CTA生成の3つの再利用プロンプトを追加。
- `docs/` に、よんぴーの勝ち筋、読者像、導線設計、日次運用、文体ルールを追加・整理。
- `templates/` に、共感フック、失敗談、学び、読者への置き換え、note CTAの投稿テンプレートを追加。
- `samples/` に、57歳からAIを実務で使いながら前に進む立ち位置のThreads投稿7本を追加。
- `scripts/test.sh` と `scripts/doctor.sh` に、今回追加したMarkdownファイルとディレクトリの存在確認を追加。

## Verification

### Commands

- `bash scripts/test.sh`
- `bash scripts/doctor.sh`

### Result

- `bash scripts/test.sh`: OK
- `bash scripts/doctor.sh`: OK

## Risks / Notes

- noteプロフィール本文と実際のnote記事URLはまだ設定ファイル化していない。
- 投稿の文字数は人間が読みやすさを確認する前提。自動文字数チェックは未実装。
- Threads/noteへの直接投稿は行わない。手動投稿と手動記録を前提にする。

## Next actions

- 実際のnoteプロフィール、記事URL、記事テーマを入力として管理する。
- 投稿結果のKPI記録を日次で運用する。
- 反応がよいCTAとフックを次週の7日計画に反映する。
