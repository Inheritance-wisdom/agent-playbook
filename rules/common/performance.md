# Performance & Resource Strategy

## Model Selection

| Model      | Best For                                                            |
| ---------- | ------------------------------------------------------------------- |
| Haiku 4.5  | Lightweight agents, frequent invocation, worker agents in pipelines |
| Sonnet 4.6 | Main development, complex coding, multi-agent orchestration         |
| Opus 4.7   | Architectural decisions, deepest reasoning, research                |

## Context Window Management

- **High-sensitivity tasks** (avoid the last 20% of context): multi-file refactoring, large feature implementation, complex cross-file debugging.
- **Low-sensitivity tasks** (safe near limits): single-file edits, isolated utilities, doc updates, simple bug fixes.

## Context Handoff

When work spans multiple sessions or grows complex:
- Maintain a **Mental Model** artifact (e.g. `task.md`, `docs/notes/<task>.md`) recording: current assumptions · completed steps · next logical actions.
- After a milestone (PR merged, refactor done, feature shipped), proactively suggest **context compaction** or a new session.
- Do not silently push through context degradation — flag it and hand off cleanly.

## Extended Thinking + Plan Mode

For complex reasoning tasks:
1. Keep extended thinking enabled (default — reserves up to ~32K tokens for internal reasoning)
2. Use **Plan Mode** for structured multi-step work
3. Run multiple critique rounds via split-role sub-agents (factual reviewer, senior engineer, security expert)

**Operator controls** (when the user wants to tune thinking):
- Toggle: `Option+T` (macOS) / `Alt+T` (Windows / Linux)
- Persistent setting: `alwaysThinkingEnabled` in `~/.claude/settings.json`
- Budget cap: `export MAX_THINKING_TOKENS=10000`
- Verbose output: `Ctrl+O` to surface the thinking trace

## Build & Tooling Failures

Delegate to specialized resolvers instead of trial-and-error:
- Generic build → `build-error-resolver`
- Language-specific → `go-build-resolver`, `rust-build-resolver`, `kotlin-build-resolver`, `java-build-resolver`, `cpp-build-resolver`, `dart-build-resolver`, `pytorch-build-resolver`

Fix incrementally; verify after each fix.
