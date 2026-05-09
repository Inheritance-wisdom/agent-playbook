---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---
# TypeScript/JavaScript Hooks

> This file extends [common/hooks.md](../common/hooks.md) with TypeScript/JavaScript specific content.

Prefer project-local tooling. Do not wire hooks to remote one-off package execution.

## PostToolUse Hooks

### Format on Save (Prettier)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "command": "pnpm prettier --write \"$FILE_PATH\"",
        "description": "Format edited JS/TS files"
      }
    ]
  }
}
```

Equivalent local commands via `yarn prettier` or `npm exec prettier --` are fine when they use repo-owned dependencies.

### Lint Check (ESLint)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "command": "pnpm eslint --fix \"$FILE_PATH\"",
        "description": "Run ESLint on edited JS/TS files"
      }
    ]
  }
}
```

### Type Check (tsc)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "command": "pnpm tsc --noEmit --pretty false",
        "description": "Type-check after JS/TS edits"
      }
    ]
  }
}
```

### console.log Warning

Warn about `console.log` left in edited files. Use proper logging libraries instead.

## Stop Hooks

### console.log Audit

Check all modified files for `console.log` before session ends.

## Ordering

Recommended order:
1. format (Prettier)
2. lint (ESLint)
3. type check (tsc)
