# Commit Message Rules (Conventional Commits v1.0.0)

Follow the [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) specification.

## Format

<type>[optional scope]: <description>

- Write the description in English and keep it concise. Use lowercase unless a proper noun is required. Do not end with a period. Do not use emoji.
- Keep the description as short as possible; aim for 50 characters or fewer.
- Do not mention file names, directory names, or list changed files in the description, unless the file itself is the subject of the change.
- Prefer the user-visible outcome or intent of the change over implementation details.
- The commit subject is required. Add a body or footer only when necessary.
- Add a scope only when the affected area is clear, such as api, ui, infra, docs, or deps.

## Allowed Types

`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

For breaking changes, use `type!:` or `type(scope)!:`. Add a `BREAKING CHANGE:` footer when additional explanation is necessary.

## Examples

- feat(ui): enable password visibility toggle
- fix(api): prevent null response for missing user
- chore(deps): update axios to 1.7.0
- refactor: reduce configuration complexity
