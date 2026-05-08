# Coding Style

## Immutability (CRITICAL)

ALWAYS create new objects, NEVER mutate existing ones.

## Core Principles

- **KISS**: Simplest solution that works. Optimize for clarity, not cleverness.
- **DRY**: Extract repeated logic. Abstract when repetition is real, not speculative.
- **YAGNI**: Don't build features before they're needed. Start simple, refactor under real pressure.

## File Organization

Many small files > few large files. 200–400 lines typical, **800 lines max**. Organize by feature/domain, not by type.

## Functions

**50 lines max**. Split large functions into focused pieces with clear responsibilities.

## Scout Rule

Always leave the code cleaner than you found it. Every feature PR should include a small cleanup unrelated to the main task but within the modified scope — fix one piece of technical debt, remove dead code, or improve a confusing name.

## Atomic Change Principle

Each edit should be limited to a single functional module or logical component to ensure reviewability and reduce conflicts. For files over 500 lines, never use full overwrite — always use targeted edits.

## Error Handling

Handle explicitly at every level. Log detailed context server-side. Never swallow silently.

## Input Validation

Validate at all system boundaries. Fail fast with clear messages. Never trust external data.

## Naming Conventions

| Type                          | Convention                                     |
| ----------------------------- | ---------------------------------------------- |
| Variables, functions          | `camelCase`                                    |
| Booleans                      | `is`, `has`, `should`, `can` prefix            |
| Interfaces, types, components | `PascalCase`                                   |
| Constants                     | `UPPER_SNAKE_CASE`                             |
| Custom hooks                  | `camelCase` with `use` prefix (e.g. `useAuth`) |

## Code Smells to Avoid

- Deep nesting (>4 levels): use early returns.
- Magic numbers: use named constants.
- Long functions (>50 lines): split into focused pieces.

## Design Patterns

**Repository Pattern**: Standard interface — `findAll`, `findById`, `create`, `update`, `delete`. Business logic depends on the interface, not storage implementation.

**API Response Envelope**: All responses use a consistent structure.
```json
{ "success": true, "data": {}, "error": null }
```
For paginated responses, add `"meta": { "total": 0, "page": 1, "limit": 20 }`.
