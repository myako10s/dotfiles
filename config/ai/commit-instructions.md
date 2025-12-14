# Commit Message Rules (Conventional Commits v1.0.0)

必ず [Conventional Commits 1.0.0](https://www.conventionalcommits.org/ja/v1.0.0/) に従う。

## 形式
<type>[optional scope]: <description>

- description は日本語、命令形、簡潔に。末尾に句点「。」は付けない。絵文字は禁止。
- 1行目（subject）は必須。本文やフッターは必要なときだけ。
- scope は変更範囲が明確なときのみ付ける（例: api, ui, infra, docs, deps）

## type（許可）
feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert

## Breaking change
破壊的変更は `type(scope)!:` を使う。必要に応じて footer に `BREAKING CHANGE:` を付ける。

## 例
- feat(ui): ログイン画面にパスワード可視化を追加
- fix(api): ユーザー取得で null を返すケースを修正
- chore(deps): axios を 1.7.0 に更新
