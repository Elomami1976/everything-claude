<![CDATA[# Core Development Rules

These fundamental rules apply to all projects, regardless of language or framework.

## 1. Research Before Coding

**ALWAYS research before implementing:**
- Check if a library/module already exists for your use case
- Review existing patterns in the codebase before adding new ones
- Look at 2-3 similar implementations for inspiration
- Verify your approach works with the target runtime/environment

**DO:**
```bash
# Research first
npm search pdf-parser
pip search pdf-parser
```

**DON'T:**
- Jump straight into writing custom implementations
- Assume your first idea is the best approach
- Reinvent functionality that already exists

---

## 2. Prefer Simple Solutions

**Complexity is the enemy of reliability:**
- Start with the simplest possible implementation
- Add complexity only when requirements demand it
- If it takes more than 50 lines, consider if there's a simpler way
- Avoid premature abstraction

**Signs you're over-engineering:**
- Creating abstractions for single-use cases
- Adding configuration options "just in case"
- Building for hypothetical future requirements
- More than 3 levels of indentation

**The 10-minute rule:** If you can't explain your approach in 10 minutes, it's too complex.

---

## 3. Never Over-Engineer

**Avoid these patterns unless truly needed:**
- Factory factories
- Dependency injection containers (in small projects)
- Complex state machines for simple flows
- Microservices for MVP products
- Event sourcing for basic CRUD

**When to add complexity:**
- After measuring actual performance problems
- When team size requires decoupling
- When requirements explicitly demand it
- When the simple solution has failed

---

## 4. Write Self-Documenting Code

**Code should explain itself:**

**DO:**
```javascript
// Good: Name explains purpose
const activeUsersWithSubscription = users.filter(
  user => user.isActive && user.subscription.status === 'active'
);

// Good: Function name is clear
function calculateMonthlyRevenueForUser(userId, month) { }
```

**DON'T:**
```javascript
// Bad: Cryptic names
const data = users.filter(u => u.a && u.s.st === 'a');

// Bad: Comments explaining obvious code
// Loop through users
for (const user of users) { }
```

**Naming guidelines:**
- Functions: verb + noun (getUserById, validateEmail, sendNotification)
- Booleans: is/has/can/should prefix (isActive, hasPermission, canEdit)
- Arrays: plural nouns (users, orders, items)
- Constants: SCREAMING_SNAKE_CASE (MAX_RETRIES, API_BASE_URL)

---

## 5. Always Handle Errors

**Every operation that can fail should be handled:**

**DO:**
```javascript
// Good: Explicit error handling
try {
  const data = await fetchUserData(userId);
  return data;
} catch (error) {
  logger.error('Failed to fetch user data', { userId, error });
  throw new UserNotFoundError(userId);
}
```

**Error handling checklist:**
- [ ] Network requests (API calls, database queries)
- [ ] File system operations (read, write, delete)
- [ ] JSON parsing
- [ ] User input validation
- [ ] Third-party library calls
- [ ] Type coercion

**Never silently swallow errors:**
```javascript
// NEVER DO THIS
try {
  riskyOperation();
} catch (e) {
  // Silent failure — bugs hide here!
}
```

---

## 6. Keep Functions Small

**Guidelines:**
- Max 20-30 lines per function (ideally under 15)
- Single responsibility — one function, one job
- Max 3 parameters (use objects for more)
- Max 2 levels of nesting

**When to split a function:**
- It does A, then B, then C (split into three functions)
- It has multiple return statements with different logic
- You need comments to explain sections
- Tests require complex mocking

---

## 7. Fail Fast

**Validate inputs early and reject bad data immediately:**

```javascript
// Good: Fail fast
function processOrder(order) {
  if (!order) throw new Error('Order is required');
  if (!order.items?.length) throw new Error('Order must have items');
  if (order.total < 0) throw new Error('Order total cannot be negative');
  
  // Main logic with validated data
  return submitOrder(order);
}

// Bad: Check late
function processOrder(order) {
  const items = order.items; // Might fail here
  for (const item of items) {
    // Or here
    if (item.price < 0) {
      // Or here — now you've done partial work
    }
  }
}
```

---

## 8. Use Early Returns

**Reduce nesting with guard clauses:**

```javascript
// Good: Early returns
function getUserPermissions(user) {
  if (!user) return [];
  if (!user.isActive) return [];
  if (user.isBanned) return [];
  
  return user.permissions;
}

// Bad: Deep nesting
function getUserPermissions(user) {
  if (user) {
    if (user.isActive) {
      if (!user.isBanned) {
        return user.permissions;
      }
    }
  }
  return [];
}
```

---

## Summary Checklist

Before submitting code, verify:
- [ ] Researched existing solutions
- [ ] Chose the simplest approach possible
- [ ] No premature abstractions
- [ ] Names are self-explanatory
- [ ] All failure modes handled
- [ ] Functions are small and focused
- [ ] Inputs validated early
- [ ] Early returns reduce nesting
]]>