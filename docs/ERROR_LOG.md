# ERROR LOG

## 目的

このファイルは、開発中に起きたエラーを記録する場所です。

同じエラーで何度も迷わないように、以下を残します。

- 何が起きたか
- どのコマンドで起きたか
- 原因は何か
- どう直したか
- 次にどう防ぐか

---

## 書き方

新しいエラーほど上に追加します。

---

## Template

## YYYY-MM-DD エラー名

### Environment

- OS:
- Tool:
- Project:
- Branch:

### Symptom

何が起きたかを書く。

### Command

実行したコマンドを書く。

例：

    git status
    bash scripts/doctor.sh

### Error message

表示されたエラー文を書く。

例：

    command not found: claude
    No such file or directory

### Root cause

原因を書く。

### Fix

どう直したかを書く。

### Verification

確認したコマンドや結果を書く。

例：

    bash scripts/doctor.sh
    git status

### Prevention

次に同じエラーを防ぐ方法を書く。

### Related files

- file/path

---

## Entries

まだ記録なし。