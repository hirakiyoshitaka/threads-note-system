# 2日おき Threads -> note 連動レーンテンプレート

## 目的

Threadsで悩みを予告し、その悩みへの答えをnote下書きにして、確認・リライト後に予約配信へ回すためのテンプレートです。

## 1 cycle

```md
## Cycle: {{cycle_id}}

### Schedule

- Threads予告日: {{threads_date}}
- note下書き生成日: {{draft_date}}
- 自分の確認日: {{review_date}}
- note予約予定日: {{scheduled_publish_date}}

### Problem

- 読者の悩み: {{reader_problem}}
- 悩みが起きる場面: {{situation}}
- 読者が本当は知りたいこと: {{hidden_question}}

### Threads preview

- 生成プロンプト: prompts/threads_problem_preview_generator.md
- 投稿本文:

{{threads_preview_post}}

### note draft

- 生成プロンプト: prompts/note_draft_from_threads_problem.md
- noteタイトル:
{{note_title}}

- note下書きファイル:
{{note_draft_path}}

### Human review

- [ ] 自分の体験として言える
- [ ] 事実と違う実績や数字がない
- [ ] 既存note毎日配信レーンと衝突していない
- [ ] Threadsの問いにnote本文が答えている
- [ ] 予約配信してよい

### Result log

- Threads反応:
- note閲覧:
- noteスキ:
- note購入:
- 次回改善:
```
