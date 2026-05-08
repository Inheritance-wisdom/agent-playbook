---
description: Auto commit, sync with remote, create a semver release tag, and push — handles pull-before-release when remote is ahead
---

# Git Release

> Uses `skills/git-workflow` conventions. Handles the full commit → sync → tag → push cycle.

**Input**: $ARGUMENTS (version bump type: `patch`, `minor`, `major`, or `auto`)

---

## Phase 1 — ASSESS

```bash
git status --short
git log --oneline -5
```

If `git status` is empty, skip to **Phase 3** (no commit needed, proceed to sync check).

Show user a brief summary of staged/unstaged changes.

---

## Phase 2 — COMMIT

Stage all changes:

```bash
git add -A
git diff --cached --stat
```

Inspect the staged diff to infer the correct commit type:

| Diff signals              | Type       |
| ------------------------- | ---------- |
| New files, new functions  | `feat`     |
| Bug fix, error handling   | `fix`      |
| Refactor, rename, cleanup | `refactor` |
| Docs, comments only       | `docs`     |
| Tests added/updated       | `test`     |
| Config, deps, build       | `chore`    |
| Performance tuning        | `perf`     |

Draft a commit message following Conventional Commits:

```
<type>(<scope>): <subject>
```

Rules: imperative mood, lowercase after type, no period, under 72 chars.

```bash
git commit -m "<type>(<scope>): <subject>"
```

---

## Phase 3 — SYNC CHECK

Fetch latest from remote without merging:

```bash
git fetch origin
```

Then compare local HEAD vs remote tracking branch:

```bash
git rev-list --count HEAD..@{u} 2>/dev/null || echo "0"
```

**If output > 0** (remote is ahead):

> "Remote has N new commits. Rebasing before release..."

```bash
git rebase origin/$(git branch --show-current)
```

If rebase hits conflicts → stop, report conflicts to user, ask them to resolve before re-running.

**If output = 0** → nothing to sync, continue.

---

## Phase 4 — DETERMINE VERSION

Get the latest tag (if any):

```bash
git tag --sort=-v:refname | head -1
```

If no tags exist, start from `v0.0.0`.

Determine bump type from `$ARGUMENTS`:

| Input           | Bump                               |
| --------------- | ---------------------------------- |
| `major`         | MAJOR version                      |
| `minor`         | MINOR version                      |
| `patch`         | PATCH version                      |
| `auto` or blank | Detect from commits since last tag |

**Auto-detection logic** (inspect `git log <last-tag>..HEAD --oneline`):

| Commit signals                       | Bump    |
| ------------------------------------ | ------- |
| Any `feat:` commit                   | `minor` |
| Any `BREAKING CHANGE` or `!` in type | `major` |
| Only `fix:`, `chore:`, `docs:`, etc. | `patch` |

Calculate next version using SemVer (`MAJOR.MINOR.PATCH`), e.g. `v1.2.0` → `v1.3.0`.

Show the user:

```
Current version : v1.2.0
Bump type       : minor (detected from feat commits)
Next version    : v1.3.0
```

Ask for confirmation before tagging: **"Proceed with v1.3.0?"**

---

## Phase 5 — TAG RELEASE

Collect commit summaries since last tag for the tag message:

```bash
git log <last-tag>..HEAD --oneline --no-merges
```

Create an annotated tag:

```bash
git tag -a v<next> -m "Release v<next>

<commit summaries>"
```

---

## Phase 6 — PUSH

Push commits and the new tag together:

```bash
git push origin $(git branch --show-current)
git push origin v<next>
```

---

## Phase 7 — OUTPUT

Report to user:

```
Released: v<next>
Commits pushed: <N>
Tag: v<next>

Changelog preview:
  <commit summaries>
```

---

## Error Cases

| Situation                          | Action                                                                       |
| ---------------------------------- | ---------------------------------------------------------------------------- |
| Rebase conflict                    | Stop. Report conflicted files. Ask user to resolve and re-run.               |
| Nothing to commit, nothing to push | Report "Already up to date. No release needed."                              |
| Push rejected (non-fast-forward)   | Run sync check again — remote changed during this run. Re-run from Phase 3.  |
| No remote configured               | Report "No remote origin found. Add one with `git remote add origin <url>`." |
