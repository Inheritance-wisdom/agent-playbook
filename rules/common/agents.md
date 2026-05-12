# Agent Orchestration

## Core Principles

- **Parallel by default**: Run independent agents simultaneously, not sequentially.
- **Proactive**: Don't wait for failures. Invoke before, during, and after writing code.
- **Right scope**: Match agent specificity to the problem (language-specific > general).

## Trigger Rules (Invoke Without Waiting for User)

| Trigger | Agent(s) |
|---------|----------|
| Complex feature or refactor | `planner` |
| Architectural decision | `architect` |
| Code written or modified | `code-reviewer` + language reviewer |
| New feature or bug fix | `tdd-guide` |
| Security-sensitive changes | `security-reviewer` |
| Build failure | language-specific build resolver |
| Dead code / cleanup | `refactor-cleaner` |
| Performance bottleneck | `performance-optimizer` |
| E2E flow change | `e2e-runner` |
| Documentation drift | `doc-updater` |

## Available Agents

Located in `~/.claude/agents/`. Organized by category:

**Core**: `planner`, `architect`, `tdd-guide`, `code-reviewer`, `security-reviewer`, `refactor-cleaner`, `doc-updater`, `performance-optimizer`, `code-simplifier`, `e2e-runner`, `code-explorer`, `code-architect`

**Language reviewers**: `typescript-reviewer`, `go-reviewer`, `python-reviewer`, `kotlin-reviewer`, `rust-reviewer`, `java-reviewer`, `flutter-reviewer`, `database-reviewer`, `cpp-reviewer`, `csharp-reviewer`, `fsharp-reviewer`

**Build resolvers**: `go-build-resolver`, `rust-build-resolver`, `kotlin-build-resolver`, `java-build-resolver`, `cpp-build-resolver`, `dart-build-resolver`, `pytorch-build-resolver`, `harmonyos-app-resolver`, `build-error-resolver`

**Specialists**: `silent-failure-hunter`, `type-design-analyzer`, `comment-analyzer`, `pr-test-analyzer`

## Parallel Task Execution

ALWAYS use parallel Task execution for independent operations:

```markdown
# GOOD: Parallel execution
Launch 3 agents in parallel:
1. Agent 1: Security analysis of auth module
2. Agent 2: Performance review of cache system
3. Agent 3: Type checking of utilities

# BAD: Sequential when unnecessary
First agent 1, then agent 2, then agent 3
```

## Multi-Perspective Analysis

For complex problems, use split role sub-agents:
- Factual reviewer
- Senior engineer
- Security expert
- Consistency reviewer
- Redundancy checker
