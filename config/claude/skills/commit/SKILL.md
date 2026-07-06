---
name: commit
description: "Analyze STAGED changes and create one or more atomic commits with English Conventional Commits messages. Use ONLY when the user explicitly invokes /commit or explicitly asks to commit. Flow: git status / git diff --cached → judge type & logical grouping → propose split → confirm via AskUserQuestion → safety-filter sensitive/junk files → git commit (English message, NO Claude footer) → PR-format summary. Never commit unless explicitly invoked."
---

## /commit スキル

`/commit` が呼ばれた時、**ステージング済みの変更**を分析し、Conventional Commits に沿った**英語**のコミットメッセージを生成、必要なら複数のアトミックコミットに分割して、確認のうえコミット作成まで実行する。

コミット規約は Conventional Commits v1.0.0 準拠（`type[optional scope]: description`）。ユーザとの対話（提案・確認・報告）は日本語、**コミットメッセージ本体は英語**で書く。

### 絶対ルール

- **`Co-Authored-By: Claude` などのフッターは絶対に付けない**
- **`git add .` / `git add -A` は使わない** — コミット対象は既にステージ済みのものだけ
- **unstaged / untracked の変更はコミット対象に含めない** — ユーザに質問せず自動的に除外する。対象は `git diff --cached` で確認できるステージ済み変更のみ
- **`--no-verify` は使わない**（フックが失敗したら原因を直す）
- **`git commit --amend` は使わない**（常に新規コミット）
- **失敗時に `git reset` などで自動ロールバックしない** — 状況を報告してユーザに判断を仰ぐ
- **`git push` はしない**（ユーザが明示的に頼まない限り）

### コミットメッセージ規約（英語）

形式: `<type>[optional scope]: <description>`

- description は**英語**・簡潔に。lowercase（固有名詞を除く）、末尾ピリオド無し、emoji 無し
- できるだけ短く、**50 文字以内**を目安
- description にファイル名・ディレクトリ名を列挙しない（そのファイル自体が変更の主題である場合を除く）
- 実装の詳細より、ユーザから見た成果・意図を優先する
- subject は必須。body / footer は必要なときだけ付ける
- scope は影響範囲が明確なときだけ付ける（例: `api`, `ui`, `infra`, `docs`, `deps`）
- 破壊的変更は `type!:` または `type(scope)!:`。追加説明が要る場合は `BREAKING CHANGE:` フッターを付ける

**Allowed types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

| type | 意味 |
|---|---|
| `feat` | 新機能の追加 |
| `fix` | バグ修正 |
| `docs` | ドキュメントのみの変更 |
| `style` | コードの意味に影響しない変更（空白・フォーマット等） |
| `refactor` | バグ修正でも機能追加でもないコード変更 |
| `perf` | パフォーマンス改善 |
| `test` | テストの追加・修正 |
| `build` | ビルドシステム・外部依存の変更 |
| `ci` | CI 設定の変更 |
| `chore` | ビルド補助ツール・雑務（`build` 以外） |
| `revert` | 以前のコミットの取り消し |

例:

- `feat(ui): enable password visibility toggle`
- `fix(api): prevent null response for missing user`
- `chore(deps): update axios to 1.7.0`
- `refactor: reduce configuration complexity`

### 実行フロー

#### Step 1: 現状把握

並列で以下を実行：

- `git status` — ステージング状態の確認用（`-uall` は使わない）
- `git diff --cached` — **staged のみ**。unstaged は対象外なので見ない
- `git log --oneline -10` — リポジトリのコミットスタイル参考用

**ステージ済みの変更が1つも無い場合**は「ステージ済みの変更がありません。`git add` でコミット対象をステージしてください」と伝えて終了する。unstaged / untracked が残っていても**ユーザに質問しない**（自動的に対象外）。

#### Step 2: 安全チェック（ステージ済みファイルのフィルタ）

ステージ済みファイルに以下が含まれていたら、コミット前に**明示して `git restore --staged <file>` でステージから外す**（削除はしない）。外した旨をチャットに表示する。

**クレデンシャル系（必ず外す）**
`.env`, `.env.*`, `*.pem`, `*.key`, `*.p12`, `*.pfx`, `*.ppk`, `credentials.json`, `service-account*.json`, `id_rsa`, `id_ed25519`, `id_ecdsa`, `.netrc`, `secrets.yml`, `secrets.yaml`

**開発環境の副産物**
`.DS_Store`, `Thumbs.db`, `desktop.ini`, `*.swp`, `*.swo`, `*~`, `*.log`, `*.tmp`, `*.bak`, `*.orig`、および `node_modules/`, `vendor/`, `dist/`, `build/`, `out/`, `target/`, `__pycache__/`, `logs/`, `tmp/` 配下

```
以下はステージから外しました（コミットに含めません）：
- .DS_Store
- config/.env
```

外した結果、コミット対象が無くなったら Step 1 の「対象なし」と同様に終了する。

#### Step 3: 変更内容を分析

`git diff --cached` から以下を判定：

**(a) type 判定** — 各変更ファイル群に対して Allowed types から選ぶ。

**(b) 論理的まとまり判定** — 内容（type / scope が変わるか）+ ファイルパスの両方を見て、複数の論理単位に分かれるかを判定する。**関連しない変更が混ざっていたら分割候補**とする。

#### Step 4: ユーザに確認（AskUserQuestion 使用）

**単一まとまりの場合** — 提案メッセージ（英語）をチャット本文に表示してから、`AskUserQuestion` で1問：

- question: 「このコミットメッセージで作成しますか？」
- header: 「コミット確認」
- options: 「OK」（提案通り作成） / 「メッセージ修正」（ユーザに自由入力させる） / 「キャンセル」（中止）

**複数のまとまりが混在する場合** — 分割案を先にチャット本文へ明示してから、`AskUserQuestion` で1問：

```
コミット1: feat: add password visibility toggle
  - src/LoginForm.tsx
コミット2: docs: document login flow
  - README.md
```

- question: 「複数の論理変更が混在しています。どうしますか？」
- header: 「分割確認」
- options: 「提案通り分割」（複数コミットを順に作成） / 「1コミットに統合」（主要 type でまとめる） / 「キャンセル」（中止）

#### Step 5: コミット実行

- **単一コミット**: `git commit -m "<english message>"`（ステージ済み全体）
- **分割**: 各グループごとに、そのグループのファイルだけをパススペック指定でコミットする：
  `git commit -m "<english message>" -- <file1> <file2> ...`
  （パススペック付き commit は `--only` 相当で、指定ファイルのみコミットし残りはステージに残る）

メッセージは前述の規約に従い、**1行の subject のみ**を基本とする（body/footer は必要時のみ）。Co-Authored-By は付けない。

分割時は順に実行し、**途中で失敗したらそこで停止**して `git status` を表示、ユーザに判断を仰ぐ（自動 reset しない）。

#### Step 6: PR フォーマット出力

全コミット成功後、以下を**チャットに表示（ファイル保存はしない）**。本文は日本語で書く。

```markdown
## 概要
<このPRで何を・なぜやったか 2-3文>

## 変更内容
- `path/to/file.ts` — 何をどう変えたか
- `path/to/other.md` — 何をどう変えたか
```

**該当時のみ追加：**

- 関連 Issue（メッセージや diff コメントに `#123` 等の参照があれば）:
  ```markdown
  ## 関連
  - Closes #123
  ```
- 破壊的変更（公開インターフェイスの非互換変更を検知したら）:
  ```markdown
  ## 破壊的変更
  - <何が変わったか・移行方法>
  ```

列挙は主要ファイルのみ（大量なときはディレクトリ単位で要約）。Step 2 で外したファイルは含めない。

### エラー時の対応

- **pre-commit フック失敗** → エラーを表示し、原因を修正してから新規コミットを作る（amend 禁止）
- **複数コミット中に失敗** → そこで停止、`git status` を表示してユーザに判断を仰ぐ
- **コミット対象が無い** → 「コミットする変更がありません」と伝えて終了

### してはいけないこと

- **`/commit` を明示的に呼ばれていないのにコミットを作る**
- `git add .` / `git add -A` / `--no-verify` / `--amend` の使用
- unstaged / untracked を勝手にステージしてコミットに含める
- 機密ファイルをユーザに知らせず処理する（外した旨は必ず明示）
- ユーザ確認を飛ばして自動でコミット作成
- `git push`（明示的な依頼がない限り）
