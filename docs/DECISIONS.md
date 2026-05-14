# DECISIONS

## 目的

このファイルは、最強ハーネスの設計判断を記録する場所です。

あとで見返した時に、

- なぜこの構成にしたのか
- なぜこのツールを使うのか
- なぜこの運用にしたのか
- 他の案ではなく、なぜこの案を選んだのか

が分かるようにします。

---

## ADR Template

### ADR-XXX: タイトル

- Date:
- Status:
- Context:
- Decision:
- Alternatives considered:
- Consequences:

---

## Decision Log

### ADR-001: `AGENTS.md` を全AI共通ルールにする

- Date: 2026-05-15
- Status: Accepted

#### Context

Cursor、Claude Code、Codexを併用するため、AIごとに違う動きをされると開発が不安定になる。

#### Decision

`AGENTS.md` を全AI共通のルールブックとして使う。

#### Alternatives considered

- AIごとに別々のルールだけを書く
- 毎回チャットでルールを説明する
- READMEだけにルールを書く

#### Consequences

- すべてのAIが同じ基本ルールを参照できる
- 既存機能を壊さない方針を共有できる
- 秘密情報や危険な操作への注意を統一できる

---

### ADR-002: `TASK.md` を毎回の作業指示ファイルにする

- Date: 2026-05-15
- Status: Accepted

#### Context

AIに毎回口頭だけで指示すると、やること・やらないこと・完了条件が曖昧になりやすい。

#### Decision

毎回の作業内容は `TASK.md` に書く。

#### Alternatives considered

- Cursorチャットだけで指示する
- Claude Codeに直接長文プロンプトを貼る
- READMEに毎回追記する

#### Consequences

- 作業目的が明確になる
- Claude CodeやCodexが同じ作業内容を参照できる
- 後から何をやったか確認しやすい

---

### ADR-003: Claude Codeを実装担当、Codexをレビュー担当にする

- Date: 2026-05-15
- Status: Accepted

#### Context

1つのAIだけに実装とレビューを任せると、ミスに気づきにくい。

#### Decision

Claude Codeをメイン実装担当、Codexをレビュー担当にする。

#### Alternatives considered

- Claude Codeだけで完結する
- Codexだけで実装もレビューも行う
- Cursorチャットだけで開発する

#### Consequences

- 実装とレビューの役割が分かれる
- 変更内容を客観的に確認しやすい
- 危険な変更や不要な変更を見つけやすい

---

### ADR-004: Cursorを人間の確認場所にする

- Date: 2026-05-15
- Status: Accepted

#### Context

AIが修正したファイルを、最終的に人間が目で確認できる場所が必要。

#### Decision

Cursorをプロジェクト全体の確認場所として使う。

#### Alternatives considered

- ターミナルだけで確認する
- Finderだけで確認する
- GitHub上だけで確認する

#### Consequences

- ファイル一覧を見やすい
- 差分を確認しやすい
- ターミナルも同じ画面で使える

---

### ADR-005: `scripts/` に確認コマンドをまとめる

- Date: 2026-05-15
- Status: Accepted

#### Context

毎回コマンドを手入力すると、入力ミスや確認漏れが起きやすい。

#### Decision

`doctor.sh`、`test.sh`、`run.sh`、`snapshot.sh` などを `scripts/` に置く。

#### Alternatives considered

- 毎回手打ちする
- READMEだけにコマンドを書く
- AIに毎回考えさせる

#### Consequences

- 確認作業を繰り返しやすい
- AIにも人間にも分かりやすい
- プロジェクトごとに必要な確認を追加できる

---

### ADR-006: `dangerously` は使うが、`TASK.md` の範囲に制限する

- Date: 2026-05-15
- Status: Accepted

#### Context

`claude --dangerously-skip-permissions` は作業が速くなる一方で、不要な変更や危険な操作も進みやすい。

#### Decision

`dangerously` は使ってよいが、必ず `TASK.md` の範囲内で使う。

#### Alternatives considered

- dangerouslyを一切使わない
- 常にdangerouslyで動かす
- 毎回AIに自由に任せる

#### Consequences

- 作業速度を上げられる
- ただし削除系や秘密情報表示は禁止する
- `AGENTS.md`、`CLAUDE.md`、`TASK.md` の重要性が高くなる