<![CDATA[# Code Review Skill

Perform comprehensive code reviews with actionable feedback and severity-based issue reporting.

## When to Use

Use this skill when:
- Reviewing pull requests
- Auditing existing code
- Before major refactoring
- Onboarding to new codebase
- Pre-launch quality check

---

## How It Works

### Review Framework

```
┌────────────────────────────────────────────────────────┐
│                    CODE REVIEW                          │
├────────────────────────────────────────────────────────┤
│                                                         │
│  1. SECURITY       → Vulnerabilities, data exposure    │
│  2. BUGS           → Logic errors, edge cases          │
│  3. PERFORMANCE    → Inefficiencies, memory leaks      │
│  4. MAINTAINABILITY→ Complexity, technical debt        │
│  5. STYLE          → Conventions, formatting           │
│                                                         │
└────────────────────────────────────────────────────────┘
```

### Severity Levels

| Level | Icon | Action Required | Examples |
|-------|------|-----------------|----------|
| **Critical** | 🔴 | Must fix before merge | Security vulnerability, data loss risk |
| **High** | 🟠 | Should fix before merge | Logic bugs, performance issues |
| **Medium** | 🟡 | Fix soon, can merge | Code smells, missing tests |
| **Low** | 🟢 | Nice to have | Style preferences, minor optimizations |

---

## Review Process

### Step 1: Security Check

```markdown
## Security Review

### 🔴 Critical Issues

- **Line 45**: API key hardcoded in source
  ```javascript
  const API_KEY = 'sk_live_abc123'; // CRITICAL: Move to env
  ```
  **Fix**: Use `process.env.API_KEY`

### 🟠 High Issues

- **Line 78**: SQL query vulnerable to injection
  ```javascript
  db.query(`SELECT * FROM users WHERE id = '${userId}'`);
  ```
  **Fix**: Use parameterized query: `db.query('SELECT * FROM users WHERE id = $1', [userId])`

### ✅ Passed Checks
- No eval() usage
- Input validation present
- CORS properly configured
```

### Step 2: Bug Detection

```markdown
## Bug Analysis

### 🔴 Critical Bugs

- **Line 123**: Null pointer exception
  ```javascript
  const name = user.profile.name; // user.profile can be null
  ```
  **Fix**: `const name = user?.profile?.name ?? 'Unknown';`

### 🟠 High Bugs

- **Line 89**: Race condition in state update
  ```javascript
  setCount(count + 1); // Uses stale state in async
  setCount(count + 1);
  ```
  **Fix**: `setCount(prev => prev + 2);`

### 🟡 Medium Bugs

- **Line 156**: Error not handled
  ```javascript
  const data = await fetch(url); // No try-catch
  ```
  **Fix**: Wrap in try-catch with appropriate error handling
```

### Step 3: Performance Review

```markdown
## Performance Analysis

### 🟠 High Issues

- **Line 34**: N+1 query problem
  ```javascript
  const users = await getUsers();
  for (const user of users) {
    user.orders = await getOrdersForUser(user.id); // N queries!
  }
  ```
  **Fix**: Batch fetch with `getOrdersForUsers(userIds)`

### 🟡 Medium Issues

- **Line 67**: Expensive computation in render
  ```javascript
  function Component({ items }) {
    const sorted = items.sort((a, b) => a.date - b.date); // Every render!
  ```
  **Fix**: Use `useMemo(() => items.sort(...), [items])`

### 🟢 Low Issues

- **Line 99**: Could use more efficient algorithm
  - Current: O(n²) nested loops
  - Suggested: O(n) with hash map lookup
```

### Step 4: Maintainability

```markdown
## Maintainability Review

### 🟡 Medium Issues

- **Lines 45-120**: Function too long (75 lines)
  - **Recommendation**: Split into smaller functions
  - Suggested breakdown:
    - `validateInput()` (lines 45-65)
    - `processData()` (lines 66-95)
    - `formatOutput()` (lines 96-120)

- **Line 34**: Magic number
  ```javascript
  if (users.length > 100) { // What is 100?
  ```
  **Fix**: `const MAX_USERS = 100; if (users.length > MAX_USERS)`

### 🟢 Low Issues

- **Line 89**: Consider extracting to constant
- **Line 145**: Comment could be clearer
```

### Step 5: Style & Conventions

```markdown
## Style Review

### 🟢 Suggestions

- **Line 12**: Prefer `const` over `let` (value never reassigned)
- **Line 45**: Inconsistent naming: `user_data` vs `userData`
- **Line 78**: Missing trailing comma in object
- **Line 99**: Line exceeds 100 characters

### ✅ Conventions Followed
- Consistent indentation (2 spaces)
- Proper semicolon usage
- Meaningful variable names
- Small function sizes (mostly)
```

---

## Review Output Template

```markdown
# Code Review: [File/PR Name]

## Summary
- **Files Reviewed**: 5
- **Lines Changed**: 234
- **Issues Found**: 12
- **Tests**: 3 new, 2 modified

## Verdict: 🟡 CHANGES REQUESTED

The code is generally well-structured but has several issues that should be addressed before merging.

## Critical Issues (1)
- 🔴 API key exposed in frontend code [security.ts:45]

## High Priority (3)
- 🟠 SQL injection vulnerability [db.ts:78]
- 🟠 Race condition in payment handler [checkout.ts:123]
- 🟠 N+1 query in user loading [users.ts:34]

## Medium Priority (5)
- 🟡 Missing error handling [api.ts:89]
- 🟡 Function too complex (cyclomatic complexity: 15) [process.ts:45]
- 🟡 Missing unit tests for edge cases
- 🟡 Magic numbers should be constants
- 🟡 Inconsistent async/await patterns

## Low Priority (3)
- 🟢 Could use more descriptive variable names
- 🟢 Consider extracting reusable utility
- 🟢 Minor style inconsistencies

## Positive Observations ✨
- Good separation of concerns
- Comprehensive input validation
- Clear function naming
- Well-documented public APIs

## Recommended Actions
1. [ ] Fix critical security issue immediately
2. [ ] Address high-priority bugs before merge
3. [ ] Add tests for uncovered edge cases
4. [ ] Consider refactoring large functions

---
Reviewed by: [Your Name]
Date: [Date]
```

---

## Checklist for Reviewers

```markdown
### Before Starting
- [ ] Understand the purpose of the changes
- [ ] Check related issues/tickets
- [ ] Review test coverage report

### During Review
- [ ] Check all modified files
- [ ] Run tests locally if possible
- [ ] Look for security issues
- [ ] Verify error handling
- [ ] Check edge cases
- [ ] Assess performance impact
- [ ] Review test quality

### After Review
- [ ] Summarize findings clearly
- [ ] Prioritize issues by severity
- [ ] Suggest specific fixes
- [ ] Acknowledge good work
- [ ] Be constructive and respectful
```

---

## Output

Deliverables:
1. Severity-categorized issue list
2. Specific fix recommendations
3. Line-by-line annotations
4. Overall verdict with action items
5. Positive feedback on good practices
]]>