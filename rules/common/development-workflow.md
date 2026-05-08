# Development Workflow

## Feature Implementation Workflow

0. **Research & Reuse** _(mandatory before any new implementation)_
   - GitHub code search → library docs (Context7 or vendor) → Exa for broader discovery.
   - Check package registries (npm, PyPI, crates.io) before writing utility code.
   - For new projects, find a battle-tested skeleton. Prefer adopting over net-new.

1. **Plan First**: PRD, architecture, system design, tech doc, task list. Identify dependencies, risks, and key edge cases.

2. **Hypothesis Verification** _(bug fixes only)_: Before writing any code, explicitly state "Why it failed" and "How the fix addresses it". Never patch without understanding the root cause.

3. **TDD**: Write tests first → implement → refactor. Target 80%+ coverage.

4. **Code Review**: Invoke appropriate reviewer agent after writing. Address CRITICAL and HIGH issues.

5. **Documentation Sync**: When modifying core logic, API handlers, or database schemas, proactively check and update related docs (README, specs, AGENTS.md).

6. **Commit & Push**: Conventional commits — `<type>(<scope>): <subject>`.

7. **Pre-Review Checks**: CI passing, conflicts resolved, branch up to date.
