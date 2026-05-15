cd /Users/macbookprohiraki/threads

cat > TASK.md <<'EOF'
重要な追加修正です。

2日おきThreads誘導レーンで、note下書きは作れましたが、
ユーザー本人がリアルな体験を入れてリライトするための
「返答の雛形」「本人入力シート」が足りません。

目的：
AIが作ったnote下書きに対して、
ユーザーが自分の実体験・失敗談・言葉遣い・具体例を入れやすくする
リライト用の返答テンプレートを追加してください。

重要：
- 既存の毎日note自動配信レーンは絶対に変更しない
- 2日おきThreads誘導レーンの補助機能として追加する
- note下書きをそのまま公開しない
- ユーザー本人のリアルな回答を入れてからリライトする流れにする
- まだ git commit はしないでください

やってほしいこと：

1. 新しいテンプレートを作成してください。

保存先：
templates/human_rewrite_answer_sheet.md

内容：
AIが作ったnote下書きを見たあと、ユーザーが答えるための入力シートにしてください。

必須項目：
- 今回のテーマ
- Threadsで投げた悩み
- 自分が実際につまずいた場面
- その時に何をしたか
- うまくいかなかったこと
- 少し改善したきっかけ
- 今ならどうするか
- 読者に一番伝えたいこと
- 自分の言葉に直したい表現
- 削除したい表現
- 追加したい具体例
- noteに入れてよい実体験
- noteに入れたくない話
- 最後の一言
- 予約配信してよいかの判断

2. 返答しやすい質問形式にしてください。

形式：
- 質問
- 記入例
- 自分の回答欄

3. 1サイクル目用の回答シートも作成してください。

保存先：
.ai/reports/threads_note/bidaily_cycle_001_ai_request/human_answer_sheet.md

テーマ：
AIに何を頼めばいいか分からない

このテーマに合わせて、ユーザーがリアル体験を書き込める質問を入れてください。

質問例：
- ChatGPTを初めて開いた時、何に困りましたか？
- 最初に何を頼もうとして止まりましたか？
- 実際にAIへ頼んで失敗した言葉はありますか？
- 今なら最初に何を頼みますか？
- 同世代の人に一番伝えたいことは何ですか？
- note本文のどこが自分っぽくないですか？
- 逆に、この表現は残したいですか？
- 最後に読者へ何と言いたいですか？

4. 新しいリライト用プロンプトを作ってください。

保存先：
prompts/rewrite_note_with_human_answers.md

目的：
AI下書きと human_answer_sheet.md の回答を元に、
本人らしいnote記事へリライトするためのプロンプト。

Input：
- AI生成note下書き
- human_answer_sheet.md の回答
- よんぴーの口調ルール
- 削除したい表現
- 残したい表現
- 入れてよい実体験
- 入れたくない話

Output：
- リライト済みnote本文
- 変更点
- まだ本人確認が必要な箇所
- 公開前チェックリスト

5. docs/WORKFLOW.md を更新してください。

2日おきレーンの流れに、以下を追加してください。

新しい流れ：
1. Threads悩み予告を作る
2. note下書きを作る
3. human_answer_sheet.md に本人が回答する
4. その回答を元にnote本文をリライトする
5. rewrite_checkpoints.md で確認する
6. 問題なければ予約配信へ回す

6. docs/LANES.md を更新してください。

人間の確認ゲートに、
「本人回答シートに実体験を入れる」
「回答シートなしで予約配信しない」
というルールを追加してください。

7. scripts/test.sh / scripts/doctor.sh を更新してください。

以下の存在確認を追加してください。
- templates/human_rewrite_answer_sheet.md
- prompts/rewrite_note_with_human_answers.md
- .ai/reports/threads_note/bidaily_cycle_001_ai_request/human_answer_sheet.md

8. .ai/task_history に今回の作業記録を追加してください。

保存内容：
- note下書きに本人のリアルを入れるための回答シートを追加
- 1サイクル目専用の human_answer_sheet.md を追加
- 回答を元にリライトするプロンプトを追加
- 回答シートなしで予約配信しないルールを追加

9. 最後に以下を実行してください。

bash scripts/test.sh
bash scripts/doctor.sh

最後に日本語で報告してください。
- 変更したファイル
- 返答の雛形をどこに作ったか
- 1サイクル目で何を記入すればいいか
- 回答後にどうリライトするか
- テスト結果
- 次に必要な作業
EOF