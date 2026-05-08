# Code Review Standards

## Mandatory Triggers

Before any commit to shared branches, after writing or modifying code, before PRs, and whenever security-sensitive code changes (auth, payments, user data).

Pre-review requirements: CI passing, conflicts resolved, branch up to date.

## Severity Levels

| Level    | Meaning                             | Action                 |
| -------- | ----------------------------------- | ---------------------- |
| CRITICAL | Security vulnerability or data loss | BLOCK — must fix       |
| HIGH     | Bug or significant quality issue    | WARN — should fix      |
| MEDIUM   | Maintainability concern             | INFO — consider fixing |
| LOW      | Style or minor suggestion           | NOTE — optional        |

**Approve**: No CRITICAL or HIGH. **Block**: Any CRITICAL.