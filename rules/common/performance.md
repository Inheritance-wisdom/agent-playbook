# Performance Optimization

## Model Selection

| Model      | Best For                                                    |
| ---------- | ----------------------------------------------------------- |
| Haiku 4.5  | Lightweight agents, frequent invocation, worker agents      |
| Sonnet 4.6 | Main development, complex coding, multi-agent orchestration |
| Opus 4.7   | Architectural decisions, deep analysis, maximum reasoning   |

## Context Window

Avoid the last 20% of context for multi-file refactoring, large feature implementation, or complex cross-file debugging.

## Context Handoff

When a task spans multiple sessions or becomes complex, maintain a "Mental Model" artifact (e.g. in `task.md`) detailing current assumptions, completed steps, and next logical actions. After reaching a milestone (PR completion, successful refactor), proactively suggest context compaction or a new session.
