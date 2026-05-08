# Agent Orchestration

## Core Principles

- **Parallel by default**: Run independent agents simultaneously, not sequentially.
- **Proactive**: Don't wait for failures. Invoke before, during, and after writing code.
- **Right scope**: Match agent specificity to the problem (language-specific > general).

## Trigger Rules (Invoke Without Waiting for User)

| Trigger                     | Agent(s)                            |
| --------------------------- | ----------------------------------- |
| Complex feature or refactor | `planner`                           |
| Architectural decision      | `architect`                         |
| Code written or modified    | `code-reviewer` + language reviewer |
| New feature or bug fix      | `tdd-guide`                         |
| Security-sensitive changes  | `security-reviewer`                 |
| Build failure               | language-specific build resolver    |
| Dead code / cleanup         | `refactor-cleaner`                  |
| Performance bottleneck      | `performance-optimizer`             |

## Available Agents (Quick Reference)

**Core**: `planner`, `architect`, `tdd-guide`, `code-reviewer`, `security-reviewer`, `refactor-cleaner`, `doc-updater`, `performance-optimizer`, `code-simplifier`, `e2e-runner`, `code-explorer`, `code-architect`

**Language reviewers**: `typescript-reviewer`, `go-reviewer`, `python-reviewer`, `kotlin-reviewer`, `rust-reviewer`, `java-reviewer`, `flutter-reviewer`, `database-reviewer`, `cpp-reviewer`, `csharp-reviewer`

**Build resolvers**: `go-build-resolver`, `rust-build-resolver`, `kotlin-build-resolver`, `java-build-resolver`, `cpp-build-resolver`, `dart-build-resolver`, `pytorch-build-resolver`

**Specialists**: `silent-failure-hunter`, `type-design-analyzer`, `comment-analyzer`, `pr-test-analyzer`

## Parallel Execution

```
// GOOD: launch simultaneously (no dependency between them)
- Agent A: Security review of auth module
- Agent B: Performance review of cache layer
- Agent C: Type safety check on utilities

// BAD: sequential when there's no dependency
```

## Multi-Perspective Analysis

For complex decisions: factual reviewer + senior engineer + security expert + consistency reviewer.