# LANES

## 目的

この文書は、既存の毎日note自動配信レーンを壊さずに、新しい2日おきThreads誘導レーンを追加するための運用設計です。

## レーン1: 既存note毎日自動配信

### 役割

毎日note記事を配信する既存の主レーンです。

### 方針

- 今まで通り継続する。
- このプロジェクトの新しいThreads誘導レーンからは、既存レーンの設定、スケジュール、配信処理を変更しない。
- 既存レーンに渡す場合は、確認済みのnote下書きだけを渡す。
- 自動生成されたままの文章を予約配信しない。

### 守ること

- 既存の毎日配信スケジュールを止めない。
- 既存記事のテーマ、URL、予約状態を勝手に上書きしない。
- 既存の公開済み記事を変更しない。

## レーン2: 2日おきThreads誘導レーン

### 役割

2日おきにThreadsで読者の悩みを予告し、その悩みへの答えをnote下書きとして生成します。Threads投稿とnote記事が連動する状態を作ります。

### 流れ

1. 2日おきに読者の悩みを1つ選ぶ。
2. Threadsへ「次回、こんな悩みありませんか？」という問いを投稿する。
3. Threads投稿を `data/threads_queue/` に `review_required` で保存する。
4. `scripts/threads_queue_check.sh` で投稿キューを確認する。
5. 本人確認後、Threads投稿の `status` を `approved` にする。
6. その問いに対する答えをnote下書きとして生成する。
7. `human_answer_sheet.md` に本人の実体験、失敗談、言葉遣い、公開可否を記入する。
8. 回答シートを元にnote本文をリライトする。
9. `rewrite_checkpoints.md` で確認する。
10. 問題なければ既存の予約投稿フローに渡す。
11. 将来、Threads API投稿スクリプトで `approved` の投稿だけを実行する。
12. Threads投稿とnote記事の対応関係を記録する。

### 投稿の位置づけ

Threadsは答えを全部出す場所ではありません。読者の悩みを言語化し、「この続きが必要ならnoteで読める」と自然に橋をかける場所です。

noteは、Threadsで投げた問いへの答えを、手順、失敗例、具体例、チェックリストとして整理する場所です。

## 連動ルール

- Threads投稿1本につき、note下書き1本を対応させる。
- Threads投稿は `data/threads_queue/` にJSONで保存し、本人確認前は `review_required` にする。
- `review_required` のThreads投稿は自動投稿しない。
- 本人確認済みのThreads投稿だけ `approved` に変更する。
- Threadsの問いとnoteタイトルがズレないようにする。
- note下書きの冒頭に、Threadsで投げた悩みを再掲する。
- note本文では、よんぴー自身の体験、実務での気づき、読者が試せる手順を入れる。
- note末尾には、次のThreads予告につながる小さな問いを置く。

## 人間の確認ゲート

note下書きは、必ず人間が確認してから予約配信します。

確認項目:

- 本人回答シートに実体験を入れているか。
- 回答シートなしで予約配信しようとしていないか。
- Threads投稿キューが `review_required` から本人確認後にだけ `approved` へ進んでいるか。
- `linked_note_draft_path` が存在し、必要なら `linked_note_url` が設定されているか。
- 自分の体験として言える内容か。
- 事実と違う実績や数字が入っていないか。
- 読者を煽りすぎていないか。
- noteで約束した内容が本文にあるか。
- 既存の毎日note配信レーンとテーマが衝突していないか。

## 2日おきスケジュール例

| Day | Threads | note |
| --- | --- | --- |
| Day 1 | 悩み予告を投稿 | 回答note下書きを生成 |
| Day 2 | 反応を見る | 自分でリライト、予約判断 |
| Day 3 | 次の悩み予告を投稿 | 次の回答note下書きを生成 |
| Day 4 | 反応を見る | 自分でリライト、予約判断 |

## 保存先

- Threads悩み予告プロンプト: `prompts/threads_problem_preview_generator.md`
- note回答下書きプロンプト: `prompts/note_draft_from_threads_problem.md`
- 本人回答シートテンプレート: `templates/human_rewrite_answer_sheet.md`
- 回答を元にリライトするプロンプト: `prompts/rewrite_note_with_human_answers.md`
- Threads投稿キュー設計: `docs/THREADS_QUEUE.md`
- Threads投稿キュー: `data/threads_queue/`
- Threads投稿キュー確認: `scripts/threads_queue_check.sh`
- Threads API投稿スタブ: `scripts/threads_post_api_stub.py`
- 2日おき連動テンプレート: `templates/bidaily_threads_note_lane.md`
- 連動サンプル: `samples/bidaily_threads_note_linked_plan.md`
