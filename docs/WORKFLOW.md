# WORKFLOW

## Threads -> note 毎日運用

このプロジェクトでは、最強ハーネスの流れをコンテンツ運用にも使います。`TASK.md` で目的を固定し、`docs/` で判断基準を確認し、`prompts/` で生成し、`samples/` と `templates/` を再利用し、`.ai/task_history/` に結果を残します。

### 1. 今日のテーマを決める

- note記事のテーマを1つ選ぶ。
- 今日の読者の悩みを1つに絞る。
- `docs/STRATEGY.md` で、よんぴーの立ち位置と読者像に合っているか確認する。

### 2. Threads投稿を生成する

- `templates/threads_note_post_template.md` の型に沿って骨子を書く。
- `prompts/threads_post_generator.md` に、noteプロフィール、記事テーマ、読者の悩み、自分の体験を入れる。
- 200〜350文字程度の完成形に整える。

### 3. note記事へ自然に誘導する

- CTAに迷ったら `prompts/note_cta_generator.md` を使う。
- Threads本文では共感と気づきを出し、noteでは手順、具体例、チェックリストを読める形にする。
- 強い売り込みや煽りは避ける。

### 4. 投稿結果を記録する

- 投稿後に、表示数、いいね、返信、保存、プロフィール閲覧、noteクリック、note閲覧、購入などを記録する。
- キャンペーンとして運用する場合は `scripts/threads_note_automation.sh` の `log` と `report` を使う。

### 5. 翌日の改善に使う

- 反応がよかったフックを次の日の冒頭に反映する。
- クリックされたCTAの言い方を残す。
- 反応が弱かった投稿は、テーマ、読者の悩み、CTAのどれがズレたかを見る。

### 週次運用

- `prompts/threads_7day_plan.md` で7日分の投稿導線を作る。
- 7日後にクリックやnote反応を見て、次週のテーマとCTAを決める。
- 結果は `.ai/task_history/` または `.ai/reports/threads_note/` に残す。

## 目的

このファイルは、最強ハーネスを使って、Cursor・Claude Code・Codex の3つのAIを安全に使い分けながら開発するための手順書です。

目的は、毎回ゼロから迷わずに、

- 要件を書く
- AIに実装させる
- AIにレビューさせる
- 人間が確認する
- GitHubに保存する
- 次回も続きから開発する

という流れを固定することです。

---

## 使うツール

### Cursor

Cursorは、プロジェクト全体を見るための作業場です。

主な役割：

- フォルダを開く
- ファイルを見る
- ファイルを編集する
- 差分を見る
- ターミナルを開く
- AIが作った変更を人間が確認する

### Claude Code / Opus

Claude Codeは、メインの実装担当です。

主な役割：

- `AGENTS.md` を読む
- `CLAUDE.md` を読む
- `TASK.md` を読む
- `docs/` を読む
- 実装計画を出す
- ファイルを修正する
- 確認コマンドを実行する
- 結果を報告する

### Codex

Codexは、レビュー担当です。

主な役割：

- Claude Codeの変更を確認する
- `TASK.md` どおりか確認する
- 既存機能を壊していないか確認する
- `.env` やAPIキーが混ざっていないか確認する
- Gitに保存してよい状態か確認する
- 必要なら最小修正案を出す

---

## 基本の役割分担

```txt
Cursor       = 見る場所・編集画面・差分確認
Claude Code  = 作るAI
Codex        = チェックするAI
GitHub       = 保存場所
あなた       = 最終判断する人
```

重要：

```txt
Claude CodeとCodexに同時に同じファイルを編集させない。
基本は Claude Codeで作る → Codexで確認する → Cursorで見る。
```

---

## 毎回の開発フロー

### 1. Cursorを開く

Cursorを起動します。

次に、

```txt
File → Open Folder
```

から、開発したいプロジェクトフォルダを開きます。

例：

```txt
最強ハーネス
videoslide_ai
note_auto_app
linebot
韓国クーパン自動物販サイト
```

---

### 2. 左側のファイル一覧を確認する

開いたプロジェクトに以下があるか確認します。

```txt
AGENTS.md
CLAUDE.md
TASK.md
README.md
.cursor/
docs/
prompts/
scripts/
.ai/
.env.example
.gitignore
```

なければ、ハーネステンプレートをコピーして使います。

---

### 3. TASK.mdを書く

毎回、最初に `TASK.md` を更新します。

`TASK.md` は「今日AIにやらせる作業」を書く場所です。

書く内容：

```txt
今回やること
なぜやるのか
やらないこと
完了条件
確認方法
戻す方法
```

例：

```md
# TASK

## Current task

- Title: VideoSlide AIのスライド品質改善
- Owner: AI agents with user review
- Priority: High
- Due date: Today

## Context

- Problem statement:
  生成されるスライドの見た目と文章品質が低い。NotebookLMレベル以上の品質を目指す。

- Expected outcome:
  スライド構成、文章、デザイン、出力場所が改善される。

- Non-goals:
  - 既存の動画生成機能は壊さない
  - 大規模な全面作り直しはしない
  - APIキーを表示しない

## Acceptance criteria

- [ ] 既存機能が壊れていない
- [ ] スライド出力の品質が上がっている
- [ ] 出力場所がUIまたはログで分かる
- [ ] 確認コマンドを実行している

## Verification plan

- Commands to run:
  - `git status`
  - `bash scripts/doctor.sh`
  - `bash scripts/test.sh`

- Manual checks:
  - サイトを開いて動作を見る
  - 出力ファイルが作られているか見る

- Rollback plan:
  - 問題があれば `git restore` または `git revert` で戻す
```

---

### 4. Cursorのターミナルを開く

Cursorの上メニューから、

```txt
Terminal → New Terminal
```

を押します。

下にターミナルが出ます。

まず現在地を確認します。

```bash
pwd
```

次にファイルを確認します。

```bash
ls -la
```

---

### 5. Git状態を確認する

作業前に必ず確認します。

```bash
git status
```

差分がある場合は、必要なら確認します。

```bash
git diff --stat
```

注意：

```txt
作業前に知らない変更が大量にある場合は、先に確認する。
そのままAIに作業させると、前の変更と混ざって分からなくなる。
```

---

### 6. Claude Codeを起動する

通常起動：

```bash
claude
```

dangerouslyを使う場合：

```bash
claude --dangerously-skip-permissions
```

dangerouslyを使う時の注意：

```txt
dangerouslyは確認を減らして作業が進みやすくなる。
ただし、間違った指示でも進みやすい。
必ずTASK.mdを明確にしてから使う。
削除系・大規模変更・APIキー表示は禁止。
```

---

### 7. Claude Codeに貼るプロンプト

Claude Codeが起動したら、これを貼ります。

```txt
AGENTS.md、CLAUDE.md、TASK.md、docs/ を読んでください。

以下をまとめてください。

1. 今回の目的
2. 制約
3. 完了条件
4. 影響するファイル
5. 実装前の作業計画

その後、編集前に短い作業計画を出してください。

絶対条件：

- .env の中身やAPIキーは表示しない
- TASK.md に書いていない大規模リファクタはしない
- 既に動いている機能を壊さない
- 変更は小さく分ける
- 実装後に確認コマンドを実行する
- できなかった確認は正直に報告する
- 結果を .ai/task_history/ に記録する
```

dangerously中なら、こちらを使います。

```txt
dangerouslyモードで進めますが、必ずTASK.mdの範囲内だけで作業してください。

絶対に守ること：

- rm -rf は使わない
- .env の中身を表示しない
- APIキーを表示しない
- 既存機能を壊さない
- 削除系の変更は事前に理由を説明する
- Git push は最後に確認してから行う
- TASK.mdにない大規模リファクタはしない
- まずAGENTS.md、CLAUDE.md、TASK.md、docs/を読んで計画を出す
```

---

### 8. Claude Codeの計画を確認する

Claude Codeが計画を出したら、内容を確認します。

良さそうなら：

```txt
その計画で実装してください。
ただし、TASK.mdの範囲だけで進め、既存機能を壊さないでください。
```

余計なことをしそうなら：

```txt
その変更は不要です。
TASK.mdの範囲だけに絞って、最小変更で進めてください。
```

危なそうなら：

```txt
その変更は既存機能を壊す可能性があります。
破壊的変更なしの別案を出してください。
```

---

### 9. Claude Codeに実装させる

Claude Codeが実装します。

実装中に確認が出た場合：

```txt
ファイルを読むだけ        → Yes
ファイルを編集する        → TASK.mdの範囲ならYes
npm install / pip install  → 必要理由が明確ならYes
削除系コマンド            → 基本No。理由を確認
git commit                → 最後の確認後ならYes
.env表示                  → No
APIキー表示               → No
```

---

### 10. Claude Code完了後に確認する

Claude Codeが終わったら、ターミナルで確認します。

```bash
git status
```

変更ファイルの概要を確認します。

```bash
git diff --stat
```

必要なら差分の中身も確認します。

```bash
git diff
```

---

### 11. 確認スクリプトを実行する

ハーネスの基本確認：

```bash
bash scripts/doctor.sh
```

テスト確認：

```bash
bash scripts/test.sh
```

アプリ起動用がある場合：

```bash
bash scripts/run.sh
```

スナップショットを残す場合：

```bash
bash scripts/snapshot.sh
```

注意：

```txt
スクリプトが失敗してもOK。
大事なのは、失敗を隠さず記録すること。
```

---

### 12. Codexを起動する

Claude Codeの作業が終わったら、Codexでレビューします。

ターミナルで起動：

```bash
codex
```

---

### 13. Codexに貼るレビュープロンプト

```txt
AGENTS.md を読んで、現在の変更内容をレビューしてください。

確認してほしいこと：

1. TASK.md の内容どおりか
2. 既存の流れを壊していないか
3. .env やAPIキーが混ざっていないか
4. node_modules、venv、outputなど不要ファイルが混ざっていないか
5. テストや確認コマンドが実行されているか
6. Gitに保存してよい状態か
7. 修正が必要なら最小修正で済むか

勝手に大きな変更はしないでください。
問題がある場合だけ、最小修正案を出してください。
```

---

### 14. Codexレビュー結果への対応

Codexが「問題なし」と言った場合：

```txt
Cursorで差分を見て、Git保存へ進む。
```

Codexが小さい問題を見つけた場合：

```txt
指摘内容をもとに、最小修正だけ行ってください。
TASK.mdの範囲外の変更はしないでください。
```

Codexが大きい問題を見つけた場合：

```txt
Claude Codeに戻して、Codexの指摘をもとに修正させる。
```

---

### 15. Cursorで差分を見る

Cursorの左側にある Source Control を開きます。

確認すること：

```txt
変更されたファイル一覧
意図しないファイルが混ざっていないか
.env が混ざっていないか
node_modules が混ざっていないか
venv が混ざっていないか
output が混ざっていないか
削除されたファイルがないか
```

---

### 16. GitHubに保存する

問題なければ、ターミナルで保存します。

```bash
git status
```

ステージング：

```bash
git add .
```

コミット：

```bash
git commit -m "最強ハーネスを追加"
```

GitHubへ保存：

```bash
git push
```

作業内容に合わせたコミットメッセージ例：

```bash
git commit -m "AI開発ハーネスの基本構成を追加"
git commit -m "Claude CodeとCodexの運用ルールを追加"
git commit -m "検証スクリプトとワークフローを追加"
git commit -m "VideoSlide AIのスライド生成品質を改善"
```

---

## トラブル時の流れ

何か壊れた場合は、慌てずこの順番で進めます。

### 1. エラーを確認する

確認するもの：

```txt
実行したコマンド
表示されたエラー
どの画面で起きたか
どのファイルを触った後か
git status
```

コマンド：

```bash
git status
```

---

### 2. ERROR_LOG.mdに記録する

`docs/ERROR_LOG.md` に記録します。

書く内容：

```md
## YYYY-MM-DD

### Error

何が起きたか。

### Command

実行したコマンド。

### Cause

原因の予想。

### Fix

どう直したか。

### Prevention

次に防ぐ方法。
```

---

### 3. 最小修正する

ルール：

```txt
関係ないファイルは触らない
全部作り直さない
まずエラーの原因だけ直す
修正後に確認コマンドを実行する
```

---

### 4. Codexに確認させる

```txt
AGENTS.mdを読んで、今回のエラー修正が最小修正になっているかレビューしてください。
既存機能を壊していないか、不要な変更がないか確認してください。
```

---

## 戻す方法

### コミット前に戻す

まず状態確認：

```bash
git status
git diff --stat
```

特定のファイルだけ戻す：

```bash
git restore path/to/file
```

全部戻すのは危険なので、基本はやらない。

---

### コミット後に戻す

履歴を壊さず戻す：

```bash
git revert <commit-hash>
```

注意：

```txt
git reset --hard は強力なので、初心者運用では基本使わない。
必要な場合は、必ず理由を確認してから使う。
```

---

## task_historyへの記録

作業が終わったら、`.ai/task_history/` に結果を残します。

ファイル名例：

```txt
2026-05-15_harness_setup.md
2026-05-15_videoslide_quality_fix.md
```

中身の例：

```md
# Task History

## Date

2026-05-15

## Task

最強ハーネスの初期構成を作成。

## Changed files

- AGENTS.md
- CLAUDE.md
- TASK.md
- README.md
- docs/
- prompts/
- scripts/
- .cursor/rules/

## Verification

- git status
- bash scripts/doctor.sh
- bash scripts/test.sh

## Result

完了。

## Risks / Notes

今後は各プロジェクトにコピーして使う。

## Next steps

GitHubに保存し、既存プロジェクトへ展開する。
```

---

## 完了チェックリスト

作業完了前に確認します。

```txt
TASK.mdの内容どおりか
AGENTS.mdのルールを守ったか
CLAUDE.mdのルールを守ったか
既存機能を壊していないか
.envやAPIキーを出していないか
不要ファイルをGitに入れていないか
確認コマンドを実行したか
Codexレビューを行ったか
Cursorで差分を見たか
task_historyに記録したか
git statusを確認したか
GitHubに保存したか
```

---

## 最短手順

慣れてきたら、毎回これだけで進めます。

```txt
1. Cursorを開く
2. TASK.mdを書く
3. Cursor Terminalを開く
4. git status
5. claude --dangerously-skip-permissions
6. ClaudeにAGENTS.md / CLAUDE.md / TASK.mdを読ませる
7. Claudeに計画 → 実装 → 確認させる
8. bash scripts/doctor.sh
9. bash scripts/test.sh
10. codex
11. Codexにレビューさせる
12. Cursorで差分確認
13. git add .
14. git commit -m "作業内容"
15. git push
```
