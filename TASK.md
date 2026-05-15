# TASK

## Current task

- Title: Threads -> note導線生成システムを最強ハーネス上に整理する
- Owner: AI agents with user review
- Priority: High
- Due date: Today

## Context

- Problem statement:
  noteプロフィールと記事テーマをもとに、Threads投稿からnote記事へ自然に誘導する仕組みが必要。単発の戦略メモではなく、毎日使い回せる生成・投稿・記録・改善の運用システムとして、このプロジェクト内に整理する。

- Expected outcome:
  最強ハーネスの `TASK.md`、`prompts/`、`docs/`、`scripts/`、`.ai/task_history/` を活かし、Threads投稿生成、7日導線設計、note CTA生成、投稿テンプレ、サンプル投稿、日次運用手順、最低限の検証スクリプトがそろっている。

- Non-goals:
  - Threadsまたはnoteへの自動投稿は実装しない。
  - 有料API連携、スクレイピング、外部サービス連携は行わない。
  - noteプロフィールや実績を捏造しない。
  - 既存のハーネス構成や安全ルールを壊さない。
  - git commit は行わない。

## Build scope

- `prompts/`:
  - Threads投稿1本生成用プロンプト
  - 7日分の投稿導線生成用プロンプト
  - note CTA生成用プロンプト
- `docs/`:
  - 勝ち筋、読者、テーマ、note導線の戦略
  - 毎日の運用手順
  - 口調、文体、避ける表現、投稿の型
- `templates/`:
  - 共感フック、自分の失敗談、今日の学び、読者への置き換え、自然なCTAを含む投稿テンプレート
- `samples/`:
  - 「57歳からAIを実務で使いながら前に進んでいる人」の立ち位置で作るThreads投稿7本
- `scripts/`:
  - 必要Markdown、テンプレ、サンプル、プロンプトの存在確認
- `.ai/task_history/`:
  - 今回の作業結果を記録

## Operating method

1. `docs/STRATEGY.md` で今回のnote記事テーマと読者を確認する。
2. `templates/threads_note_post_template.md` に沿って投稿の骨子を作る。
3. `prompts/threads_post_generator.md` でThreads投稿を1本作る。
4. 週次では `prompts/threads_7day_plan.md` で7日分の投稿導線を作る。
5. CTAに迷う場合は `prompts/note_cta_generator.md` で自然な誘導文を生成する。
6. 投稿後に表示数、反応、クリック、note閲覧・購入などを記録する。
7. 翌日の投稿テーマとCTAに反映する。

## Acceptance criteria

- [ ] `TASK.md` が今回の目的、作るもの、運用方法、未実装課題を説明している。
- [ ] `prompts/threads_post_generator.md` が存在し、1投稿生成に使える。
- [ ] `prompts/threads_7day_plan.md` が存在し、7日分の導線設計に使える。
- [ ] `prompts/note_cta_generator.md` が存在し、自然なCTA生成に使える。
- [ ] `docs/STRATEGY.md` が勝ち筋、刺さる読者、投稿テーマ、note導線を整理している。
- [ ] `docs/WORKFLOW.md` が毎日の運用手順を説明している。
- [ ] `docs/CONTENT_RULES.md` が口調、文体、避ける表現、刺さる型を説明している。
- [ ] 投稿テンプレートが再利用できる形で保存されている。
- [ ] Threads用サンプル投稿7本が完成形で保存されている。
- [ ] `README.md` がプロジェクトの目的と使い方を説明している。
- [ ] `.ai/task_history/` に今回の作業記録がある。
- [ ] `bash scripts/test.sh` が成功する。
- [ ] `bash scripts/doctor.sh` が成功する。

## Unimplemented backlog

- noteプロフィール本文と実際の記事URLを入力として管理する設定ファイル。
- 日次KPIを1行で記録する運用フォーマットの拡張。
- 投稿別の反応から翌日の改善案を出すレポート。
- 生成した投稿の文字数チェック自動化。
- note記事本文の構成生成とThreads投稿の連動強化。

## Verification plan

- Commands to run:
  - `bash scripts/test.sh`
  - `bash scripts/doctor.sh`

- Manual checks:
  - 7本の投稿が200〜350文字程度で、そのままThreadsに投稿できる完成形になっている。
  - 各投稿の最後にnoteへ自然に誘導するCTAがある。
  - docsとpromptsが日次運用で再利用できる内容になっている。

- Rollback plan:
  - `git status --short` で変更ファイルを確認する。
  - 不要な追加ファイルはユーザー確認後に削除する。
  - 既存ファイルに問題があれば、該当ファイルだけ差分を見て最小修正する。
