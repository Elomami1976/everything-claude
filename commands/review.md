<![CDATA[# /review Command

Perform a comprehensive code review with severity-based issue reporting.

## Usage

```
/review <file path or PR link>
/review                        # Reviews current file
/review src/                   # Reviews entire directory
```

## Input

- File path (relative or absolute)
- Directory path (reviews all files)
- GitHub PR link
- No argument = current open file

## Output Format

---

### REVIEW HEADER

```markdown
# Code Review: [File/PR Name]

**Reviewed**: [timestamp]
**Files**: [count]
**Lines**: [total lines reviewed]
**Language(s)**: [detected languages]

## Verdict: [🟢 APPROVED | 🟡 CHANGES REQUESTED | 🔴 BLOCKED]

[1-2 sentence summary]
```

---

### ISSUES BY SEVERITY

```markdown
## 🔴 Critical Issues ([count])

Issues that MUST be fixed before merge. Security vulnerabilities, data loss risks, critical bugs.

### [Issue Title]
**Location**: [file:line]
**Category**: [Security | Bug | Performance]

**Problem**:
\`\`\`[language]
[problematic code snippet]
\`\`\`

**Why it's critical**: [explanation]

**Fix**:
\`\`\`[language]
[corrected code snippet]
\`\`\`

---

## 🟠 High Priority ([count])

Issues that SHOULD be fixed before merge. Logic bugs, performance issues, best practice violations.

### [Issue Title]
**Location**: [file:line]
**Category**: [Bug | Performance | Maintainability]

[Same format as Critical]

---

## 🟡 Medium Priority ([count])

Issues to fix soon. Code smells, missing tests, documentation gaps.

### [Issue Title]
**Location**: [file:line]
**Category**: [Code Quality | Testing | Documentation]

[Same format]

---

## 🟢 Low Priority / Suggestions ([count])

Nice-to-have improvements. Style preferences, minor optimizations.

- **[file:line]**: [Brief suggestion]
- **[file:line]**: [Brief suggestion]
```

---

### POSITIVE OBSERVATIONS

```markdown
## ✨ What's Good

Acknowledge quality code to reinforce good practices.

- [Positive observation 1]
- [Positive observation 2]
- [Positive observation 3]
```

---

### SUMMARY TABLE

```markdown
## Summary

| Category | Critical | High | Medium | Low |
|----------|----------|------|--------|-----|
| Security | 0 | 1 | 0 | 0 |
| Bugs | 1 | 2 | 0 | 0 |
| Performance | 0 | 0 | 1 | 2 |
| Code Quality | 0 | 0 | 3 | 5 |
| Testing | 0 | 0 | 2 | 0 |
| **Total** | **1** | **3** | **6** | **7** |

## Recommended Actions
1. [ ] [Most important action]
2. [ ] [Second most important]
3. [ ] [Third action]
```

---

## Review Checklist (Internal)

The `/review` command checks for:

### Security
- [ ] No hardcoded secrets/keys
- [ ] SQL queries parameterized
- [ ] User input validated
- [ ] XSS prevention (innerHTML, etc.)
- [ ] CSRF protection
- [ ] Auth/authorization checks
- [ ] Sensitive data not logged

### Bugs
- [ ] Null/undefined handling
- [ ] Edge cases covered
- [ ] Error handling complete
- [ ] Race conditions avoided
- [ ] Memory leaks prevented
- [ ] Type safety (if applicable)

### Performance
- [ ] No N+1 queries
- [ ] Expensive operations memoized
- [ ] Large data sets paginated
- [ ] Unnecessary re-renders avoided
- [ ] Async operations used correctly

### Code Quality
- [ ] Functions small and focused
- [ ] Names are descriptive
- [ ] No magic numbers
- [ ] DRY (no excessive duplication)
- [ ] Consistent patterns used

### Testing
- [ ] New code has tests
- [ ] Edge cases tested
- [ ] Tests are meaningful
- [ ] Mocks are appropriate

### Documentation
- [ ] Public APIs documented
- [ ] Complex logic commented
- [ ] README updated if needed

---

## Example Review

### Input
```
/review src/checkout.js
```

### Output
```markdown
# Code Review: src/checkout.js

**Reviewed**: 2024-01-15 10:30 UTC
**Files**: 1
**Lines**: 156
**Language(s)**: JavaScript

## Verdict: 🟡 CHANGES REQUESTED

Generally solid implementation, but has one critical security issue with API key exposure and several high-priority bugs that need attention.

---

## 🔴 Critical Issues (1)

### Stripe Secret Key Exposed in Frontend
**Location**: src/checkout.js:12
**Category**: Security

**Problem**:
\`\`\`javascript
const stripe = Stripe('sk_live_abc123xyz...'); // Secret key in frontend!
\`\`\`

**Why it's critical**: Secret keys must never be in frontend code. Anyone can view source and steal your Stripe key, allowing them to charge any card, issue refunds, or access your entire Stripe account.

**Fix**:
\`\`\`javascript
// Frontend: Use publishable key only
const stripe = Stripe('pk_live_...');

// Move payment creation to your backend
const response = await fetch('/api/create-payment-intent', {
  method: 'POST',
  body: JSON.stringify({ amount, currency })
});
\`\`\`

---

## 🟠 High Priority (2)

### Race Condition in Stock Check
**Location**: src/checkout.js:45-52
**Category**: Bug

**Problem**:
\`\`\`javascript
const stock = await getStock(productId);
if (stock > 0) {
  // Time passes here...
  await reserveItem(productId); // Stock might be gone!
}
\`\`\`

**Why it matters**: Between checking stock and reserving, another request could take the last item, leading to overselling.

**Fix**:
\`\`\`javascript
// Atomic operation or database transaction
const reserved = await db.transaction(async (tx) => {
  const stock = await tx.getStock(productId);
  if (stock <= 0) return false;
  await tx.decrementStock(productId);
  return true;
});

if (!reserved) {
  throw new OutOfStockError(productId);
}
\`\`\`

---

### Unhandled Promise Rejection
**Location**: src/checkout.js:78
**Category**: Bug

**Problem**:
\`\`\`javascript
sendOrderConfirmation(email, orderDetails); // No await, no catch!
\`\`\`

**Fix**:
\`\`\`javascript
try {
  await sendOrderConfirmation(email, orderDetails);
} catch (error) {
  logger.error('Failed to send confirmation', { error, email, orderId });
  // Don't throw - order is complete, email failure shouldn't block
}
\`\`\`

---

## 🟡 Medium Priority (3)

### Missing Input Validation
**Location**: src/checkout.js:25
- Email format not validated
- Quantity not checked for reasonable bounds

### Magic Numbers
**Location**: src/checkout.js:67
- `if (amount > 999999)` - what does this represent?
- Use named constant: `const MAX_ORDER_CENTS = 999999;`

### No Error Boundary for UI
**Location**: src/checkout.js:102
- Cart render could fail, leaving UI broken

---

## 🟢 Low Priority (4)

- **Line 15**: Consider destructuring `const { email, name } = customer`
- **Line 34**: Could use optional chaining: `user?.address?.zip`
- **Line 89**: Variable `x` could be more descriptive
- **Line 120**: Inconsistent quote style (single vs double)

---

## ✨ What's Good

- Clean separation between cart logic and payment processing
- Good use of async/await throughout
- Descriptive function names for main operations
- Error messages are user-friendly

---

## Summary

| Category | Critical | High | Medium | Low |
|----------|----------|------|--------|-----|
| Security | 1 | 0 | 0 | 0 |
| Bugs | 0 | 2 | 0 | 0 |
| Code Quality | 0 | 0 | 2 | 4 |
| Validation | 0 | 0 | 1 | 0 |
| **Total** | **1** | **2** | **3** | **4** |

## Recommended Actions
1. [ ] Move Stripe secret key to backend immediately
2. [ ] Add transaction for stock reservation
3. [ ] Handle email sending failures gracefully
```
]]>