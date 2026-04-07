# Code Review Skill

Perform comprehensive code reviews with severity-based issue reporting and actionable fixes.

## When to Use

Use this skill when:
- Reviewing pull requests before merge
- Auditing existing code for quality issues
- Preparing for a major refactor
- Onboarding to an unfamiliar codebase
- Running a pre-launch quality check

---

## Severity Levels

| Level | Icon | Action | Examples |
|---|---|---|---|
| **Critical** | RED | Must fix before merge | Security vulnerability, data loss |
| **High** | ORANGE | Fix before merge | Logic bug, unhandled error path |
| **Medium** | YELLOW | Fix soon | Code smell, missing test |
| **Low** | GREEN | Optional | Style preference, micro-optimization |

---

## Review Process

Run all 5 passes below. Report issues grouped by severity — Critical first.

### Pass 1: Security

Check for vulnerabilities that could be exploited:

- Hardcoded secrets, API keys, or passwords in source
- SQL/NoSQL injection via unsanitized input
- XSS — user input rendered as HTML without escaping
- IDOR — operations on IDs without ownership check
- Missing authentication on protected routes
- Sensitive data logged or returned in responses

### Pass 2: Bugs

Check for code that will fail at runtime or in edge cases:

- Uncaught exceptions and unhandled promise rejections
- Off-by-one errors in loops and array access
- Null/undefined not guarded before property access
- Race conditions in async code
- Incorrect comparison (`==` vs `===`, reference vs value)
- Functions that silently return wrong types

### Pass 3: Performance

Check for code that will be slow or expensive:

- N+1 queries (fetching in a loop — batch instead)
- Missing database indexes on filtered/sorted columns
- Expensive computation in a hot path (move outside loop or memoize)
- Unbounded queries (missing LIMIT)
- Unnecessary re-renders in React components

### Pass 4: Maintainability

Check for code that will be hard to change:

- Functions longer than ~40 lines (split responsibility)
- Magic numbers without explanation (`100` vs `const MAX_RETRIES = 100`)
- Deep nesting (flatten with early returns)
- Duplicate logic that should be extracted
- Missing types on public function signatures

### Pass 5: Style and Conventions

Check for inconsistency with the codebase:

- Naming conventions (`camelCase` vs `snake_case`)
- Import organization
- Inconsistent error handling patterns
- Missing or misleading comments on non-obvious logic

---

## Output Format

Structure the review report as follows:

```
# Code Review: [File or PR Name]

## Summary
- Files reviewed: N
- Issues found: N (X critical, X high, X medium, X low)
- Tests: N new, N modified
- Verdict: APPROVE / REQUEST CHANGES

## Critical Issues
### [Issue title] — Line N
**Problem:** [What is wrong]
**Fix:** [What to change]

## High Issues
...

## Passed Checks
- [x] No hardcoded secrets
- [x] Input validation present
- [x] Error handling covers main paths
```

---

## Output Deliverables

1. Structured report grouped by severity
2. Specific line references for each issue
3. Concrete fix for each Critical and High issue
4. List of passed checks
5. Final verdict: APPROVE or REQUEST CHANGES
