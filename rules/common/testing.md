# Testing Requirements

Minimum coverage: **80%**. Required types: Unit, Integration, E2E.

## TDD Workflow (MANDATORY)

1. Write test → must **FAIL** (RED)
2. Write minimal implementation → must **PASS** (GREEN)
3. Refactor → verify coverage ≥ 80%

## Test Structure (AAA)

```typescript
test("returns empty array when no markets match query", () => {
  // Arrange
  const query = "xyz";

  // Act
  const result = search(query);

  // Assert
  expect(result).toEqual([]);
});
```

Use descriptive names that explain **behavior**, not implementation.