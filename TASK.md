# TASK

## Current task

- Title: 既存note毎日配信レーンを守りながら2日おきThreads誘導レーンを追加する
- Owner: AI agents with user review
- Priority: High
- Due date: Today

## Context

- Problem statement:
  既存の毎日note自動配信は今まで通り継続し、壊さない。その横に、2日おきにThreadsへ悩み予告を配信し、その悩みへの答えをnote下書き・予約投稿候補として自動生成する新しい誘導レーンを追加する。

- Expected outcome:
  最強ハーネスの `TASK.md`、`prompts/`、`docs/`、`templates/`、`samples/`、`scripts/`、`.ai/task_history/` を活かし、既存レーンと新誘導レーンを分離して運用できる。Threads悩み予告、note回答下書き、確認・リライト、予約配信判断までの流れが再利用できる。

- Non-goals:
  - 既存の毎日note自動配信レーンを変更・停止しない。
  - Threadsまたはnoteへの直接自動投稿はこの変更では実装しない。
  - 有料API連携、スクレイピング、外部サービス連携は行わない。
  - noteプロフィールや実績を捏造しない。
  - 既存のハーネス構成や安全ルールを壊さない。
  - git commit は行わない。

## Build scope

- `prompts/`:
  - Threads投稿1本生成用プロンプト
  - 7日分の投稿導線生成用プロンプト
  - note CTA生成用プロンプト
  - 2日おきThreads悩み予告生成用プロンプト
  - Threadsの悩みに対するnote下書き生成用プロンプト
- `docs/`:
  - 既存note毎日配信レーンと新しいThreads誘導レーンの分離設計
  - 勝ち筋、読者、テーマ、note導線の戦略
  - 毎日の運用手順
  - 口調、文体、避ける表現、投稿の型
- `templates/`:
  - 共感フック、自分の失敗談、今日の学び、読者への置き換え、自然なCTAを含む投稿テンプレート
  - 2日おき連動レーンの運用テンプレート
- `samples/`:
  - 「57歳からAIを実務で使いながら前に進んでいる人」の立ち位置で作るThreads投稿7本
  - Threads悩み予告とnote下書きテーマの連動サンプル
- `scripts/`:
  - 必要Markdown、テンプレ、サンプル、プロンプトの存在確認
- `.ai/task_history/`:
  - 今回の作業結果を記録

## Operating method

1. 既存の毎日note自動配信レーンはそのまま継続する。
2. 新しい誘導レーンでは、2日おきに `prompts/threads_problem_preview_generator.md` で悩み予告Threadsを作る。
3. Threadsで「次回、こんな悩みありませんか？」と問いを投げる。
4. その問いへの答えを `prompts/note_draft_from_threads_problem.md` でnote下書き化する。
5. 自分が確認し、事実、口調、経験談、CTAをリライトする。
6. 問題なければ既存の予約投稿フローに渡す。
7. Threads投稿とnote記事の対応関係、反応、改善点を記録する。

## Acceptance criteria

- [ ] `TASK.md` が今回の目的、作るもの、運用方法、未実装課題を説明している。
- [ ] `prompts/threads_post_generator.md` が存在し、1投稿生成に使える。
- [ ] `prompts/threads_7day_plan.md` が存在し、7日分の導線設計に使える。
- [ ] `prompts/note_cta_generator.md` が存在し、自然なCTA生成に使える。
- [ ] `prompts/threads_problem_preview_generator.md` が存在し、2日おきの悩み予告投稿に使える。
- [ ] `prompts/note_draft_from_threads_problem.md` が存在し、悩みへの回答note下書きに使える。
- [ ] `docs/LANES.md` が既存レーンと新誘導レーンの分離を説明している。
- [ ] `docs/STRATEGY.md` が勝ち筋、刺さる読者、投稿テーマ、note導線を整理している。
- [ ] `docs/WORKFLOW.md` が毎日の運用手順を説明している。
- [ ] `docs/CONTENT_RULES.md` が口調、文体、避ける表現、刺さる型を説明している。
- [ ] 投稿テンプレートが再利用できる形で保存されている。
- [ ] 2日おき連動レーンのテンプレートが保存されている。
- [ ] Threads用サンプル投稿7本が完成形で保存されている。
- [ ] `README.md` がプロジェクトの目的と使い方を説明している。
- [ ] `.ai/task_history/` に今回の作業記録がある。
- [ ] `bash scripts/test.sh` が成功する。
- [ ] `bash scripts/doctor.sh` が成功する。

## Unimplemented backlog

- noteプロフィール本文と実際の記事URLを入力として管理する設定ファイル。
- 既存のnote毎日配信システムとの実接続点の明文化。
- note予約投稿APIまたは外部予約機能への接続。
- Threads予約投稿APIまたは外部予約機能への接続。
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
