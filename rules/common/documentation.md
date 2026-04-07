<![CDATA[# Documentation Rules

Good documentation accelerates onboarding and reduces support burden.

## 1. README Essentials

**Every project README must have:**

```markdown
# Project Name

One-line description of what this project does.

## Features

- Feature 1
- Feature 2
- Feature 3

## Installation

\`\`\`bash
# Step-by-step installation commands
npm install
\`\`\`

## Quick Start

\`\`\`bash
# Minimal example to get running
npm start
\`\`\`

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `API_KEY` | Your API key | Required |

## License

MIT
```

**README quality checklist:**
- [ ] Can a new developer get running in under 5 minutes?
- [ ] All configuration options documented?
- [ ] Common errors and solutions included?
- [ ] Screenshots for visual features?
- [ ] Links to detailed docs if available?

---

## 2. Code Comments

**When to comment:**
- Complex algorithms or business logic
- Non-obvious workarounds or hacks
- TODO items (with issue links)
- Regex patterns
- Performance-critical sections

**When NOT to comment:**
```javascript
// Bad: Comment states the obvious
// Increment counter
counter++;

// Bad: Comment describes what, not why
// Loop through users
for (const user of users) { }

// Good: Comment explains WHY
// Using setTimeout(0) to defer execution until after DOM update
setTimeout(() => {
  scrollContainer.scrollTop = scrollContainer.scrollHeight;
}, 0);

// Good: Explain business logic
// Apply 20% discount for annual plans, but cap at $50
const discount = Math.min(yearlyPrice * 0.2, 50);
```

**TODO format:**
```javascript
// TODO(username): description - ISSUE-123
// TODO: Fix race condition when concurrent updates - #456
```

---

## 3. API Documentation

**Document every public function:**

```javascript
/**
 * Creates a new user account and sends welcome email.
 * 
 * @param {Object} userData - User registration data
 * @param {string} userData.email - Valid email address
 * @param {string} userData.password - Min 8 chars, must contain number
 * @param {string} [userData.name] - Display name (optional)
 * @returns {Promise<User>} Created user object without password
 * @throws {ValidationError} If email format invalid
 * @throws {DuplicateError} If email already registered
 * 
 * @example
 * const user = await createUser({
 *   email: 'user@example.com',
 *   password: 'secure123',
 *   name: 'John Doe'
 * });
 */
async function createUser(userData) { }
```

**Python docstrings:**
```python
def create_user(email: str, password: str, name: str = None) -> User:
    """
    Creates a new user account and sends welcome email.
    
    Args:
        email: Valid email address
        password: Min 8 chars, must contain number  
        name: Display name (optional)
    
    Returns:
        Created user object without password field
    
    Raises:
        ValidationError: If email format invalid
        DuplicateError: If email already registered
    
    Example:
        >>> user = create_user("user@example.com", "secure123")
        >>> print(user.email)
        user@example.com
    """
```

---

## 4. Inline Documentation

**Self-documenting code patterns:**

```javascript
// Use descriptive variable names
// Bad
const d = new Date() - startTime;

// Good
const elapsedMilliseconds = new Date() - startTime;

// Use named constants
// Bad
if (user.role === 3) { }

// Good
const ADMIN_ROLE = 3;
if (user.role === ADMIN_ROLE) { }

// Extract complex conditions
// Bad
if (user.age >= 18 && user.verified && !user.banned && user.subscription?.status === 'active') { }

// Good
const isEligibleUser = user.age >= 18 && 
                       user.verified && 
                       !user.banned && 
                       user.subscription?.status === 'active';
if (isEligibleUser) { }
```

---

## 5. Changelog Format

**CHANGELOG.md following Keep a Changelog:**

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- New feature description

## [1.2.0] - 2024-01-15

### Added
- User profile pages
- Dark mode support

### Changed
- Updated pricing structure

### Fixed
- Login redirect bug on mobile

### Security
- Fixed XSS vulnerability in comments

## [1.1.0] - 2024-01-01

### Added
- Initial release
```

---

## 6. Environment Documentation

**Document all environment variables:**

```env
# .env.example

# ===================
# Required Variables
# ===================

# Database connection
# Format: postgres://user:password@host:port/database
DATABASE_URL=

# Stripe API (get from https://dashboard.stripe.com/apikeys)
STRIPE_SECRET_KEY=sk_test_xxx
STRIPE_PUBLISHABLE_KEY=pk_test_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx

# ===================
# Optional Variables
# ===================

# Application
NODE_ENV=development
PORT=3000

# Logging (options: debug, info, warn, error)
LOG_LEVEL=info
```

---

## 7. Architecture Documentation

**For complex systems, document:**

```markdown
# Architecture

## System Overview

Client (React) ---> API (Node) ---> Database (Postgres)
                          |
                          v
                     Redis (Cache)

## Key Decisions

### Why Postgres over MongoDB?
- Need ACID transactions for payments
- Complex relationships between entities
- SQL expertise on team

### Why Redis for caching?
- Session storage with TTL
- Rate limiting
- Job queue for background tasks
```

---

## 8. Error Messages

**Write helpful error messages:**

```javascript
// Bad error
throw new Error('Invalid input');

// Good error
throw new Error(
  `Invalid email format: "${email}". ` +
  `Expected format: user@domain.com`
);

// User-facing vs developer errors
class UserFacingError extends Error {
  constructor(userMessage, technicalDetails) {
    super(technicalDetails);
    this.userMessage = userMessage;
  }
}

throw new UserFacingError(
  'Unable to process payment. Please try again.',
  `Stripe error: ${stripeError.code} - ${stripeError.message}`
);
```

---

## Documentation Checklist

- [ ] README covers installation, usage, configuration
- [ ] Complex functions have docstrings/JSDoc
- [ ] Environment variables documented in .env.example
- [ ] Non-obvious code has explanatory comments
- [ ] API endpoints documented with examples
- [ ] CHANGELOG maintained for releases
- [ ] Architecture documented for complex systems
- [ ] Error messages are actionable
]]>