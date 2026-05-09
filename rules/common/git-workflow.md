# Git Workflow

> The full dev pipeline (planning → TDD → review → commit) lives in [development-workflow.md](./development-workflow.md). This file covers commit and PR mechanics only.

## Commit Message Format

```
<type>(<scope>): <subject>

<optional body>
```

- **Types**: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `ci`, `build`
- **Scope** _(optional)_: module / package / area touched
- **Subject**: imperative mood, ≤72 chars, no trailing period
- Attribution is disabled globally via `~/.claude/settings.json`

## Pull Request Workflow

1. Analyze the **full** commit history on the branch — not just the latest commit
2. Use `git diff <base>...HEAD` to see every change in the PR
3. Draft summary covering: what changed, why, risk, rollback path
4. Include a **test plan** (checklist of TODOs to verify)
5. Push with `-u` flag if branch is new

## Safety

- Never `--no-verify` without explicit user approval
- Never force-push to `main` / `master`
- Prefer new commits over `--amend` after a hook failure (the commit didn't land — `--amend` would rewrite the wrong commit)
- Stage specific files; avoid `git add -A` / `git add .` (risks committing `.env`, large binaries)
