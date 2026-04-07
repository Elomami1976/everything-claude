# Security Audit Skill

Identify and remediate security vulnerabilities across the OWASP Top 10 categories.

## When to Use

Use this skill when:
- Preparing for production launch
- After major code changes to auth, payments, or data access
- Handling sensitive user data or PII
- Processing payments
- Preparing for compliance (SOC 2, GDPR, PCI DSS)
- Responding to a security incident

---

## Audit Categories

Run checks in this order — Critical categories first:

| Priority | Category | What to Look For |
|---|---|---|
| 1 | **Secret Exposure** | API keys, passwords, tokens in source code or git history |
| 2 | **Injection** | SQL, NoSQL, command, LDAP injection via unsanitized inputs |
| 3 | **Authentication** | Weak sessions, no MFA option, insecure password reset |
| 4 | **Authorization** | IDOR, missing ownership checks, privilege escalation |
| 5 | **Data Protection** | PII unencrypted, sensitive data in logs, HTTPS not enforced |
| 6 | **Dependencies** | Known CVEs in npm/pip packages |
| 7 | **Configuration** | CORS too loose, missing security headers, debug mode on |
| 8 | **API Security** | No rate limiting, no input validation, verbose error messages |

---

## Audit Checklist

### 1. Secret Exposure

- [ ] No API keys, passwords, or tokens in source files
- [ ] `.env` files listed in `.gitignore`
- [ ] Git history clean: `git log --all -- "*.env*" "*.pem"`
- [ ] No secrets in client-side JavaScript bundles

Fix: Move secrets to environment variables immediately. Rotate any exposed keys.

### 2. Injection

- [ ] All database queries use parameterized queries or an ORM
- [ ] No string concatenation to build SQL
- [ ] All user input validated and sanitized before use
- [ ] `eval()`, `exec()`, shell commands avoid user input

Fix:
```typescript
// Bad
db.query(`SELECT * FROM users WHERE id = ${userId}`);

// Good
db.query('SELECT * FROM users WHERE id = $1', [userId]);
```

### 3. Authentication

- [ ] Passwords hashed with bcrypt (cost 12+) or Argon2
- [ ] Password reset tokens expire within 1 hour
- [ ] Session tokens are HTTP-only, Secure, and SameSite=Strict
- [ ] JWT secrets are long random strings, not dictionary words
- [ ] Auth endpoints rate-limited (max 5 attempts per 15 min)

### 4. Authorization (IDOR)

- [ ] Every data operation checks: does this user own this resource?
- [ ] Admin endpoints require explicit role check, not just auth
- [ ] Object IDs in URLs are not used to infer permissions

Fix:
```typescript
// Bad
const doc = await getDocument(req.params.id);

// Good
const doc = await getDocument(req.params.id);
if (doc.userId !== req.user.id) return res.status(403).json({ error: 'Forbidden' });
```

### 5. Data Protection

- [ ] HTTPS enforced (redirect HTTP to HTTPS)
- [ ] PII fields encrypted at rest where possible
- [ ] No sensitive data in URLs (use POST body)
- [ ] Logs exclude passwords, tokens, card numbers, SSNs
- [ ] Database backups encrypted

### 6. Dependencies

```bash
# Run these before deploying
npm audit --audit-level=high
pip-audit
```

- [ ] No High or Critical CVEs in production dependencies
- [ ] Pinned versions in `package-lock.json` / `requirements.txt`
- [ ] `node_modules` in `.gitignore`

### 7. Configuration

Security headers to add:

```
Content-Security-Policy: default-src 'self'
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

CORS: Allowlist specific origins — never `Access-Control-Allow-Origin: *` for authenticated APIs.

### 8. API Security

- [ ] Rate limiting on all endpoints (express-rate-limit, slowapi)
- [ ] Request body size limited (prevent payload attacks)
- [ ] Input validation using Zod, Pydantic, or similar
- [ ] Error messages don't expose stack traces or SQL to clients

---

## Audit Report Template

```markdown
# Security Audit: [App Name]

**Date:** [Date]  **Risk Level:** HIGH / MEDIUM / LOW

## Critical Findings
| # | Issue | Location | Status |
|---|---|---|---|
| 1 | API key in source | src/config.js:12 | Open |

## High Priority
...

## Passed Checks
- [x] No secrets in repository
- [x] HTTPS enforced
- [x] Authentication secure

## Next Steps
1. [Fix critical items within 24 hours]
2. [Fix high items within 1 week]
3. [Schedule follow-up audit in 30 days]
```

---

## Output Deliverables

1. Categorized vulnerability list with severity
2. Specific file and line references
3. Concrete fix for each Critical/High issue
4. List of passed checks
5. Prioritized remediation timeline
