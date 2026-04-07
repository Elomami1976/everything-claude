<![CDATA[# Security Audit Skill

Perform comprehensive security audits to identify vulnerabilities before they become breaches.

## When to Use

Use this skill when:
- Before launching to production
- After major code changes
- Handling sensitive user data
- Processing payments
- Preparing for compliance audits
- Responding to security incidents

---

## How It Works

### Audit Framework

```
┌────────────────────────────────────────────────────────┐
│                   SECURITY AUDIT                        │
├────────────────────────────────────────────────────────┤
│                                                         │
│  1. SECRET EXPOSURE    → API keys, passwords, tokens   │
│  2. INJECTION ATTACKS  → SQL, XSS, command injection  │
│  3. AUTHENTICATION     → Session, JWT, password policy │
│  4. AUTHORIZATION      → Access control, permissions   │
│  5. DATA PROTECTION    → Encryption, PII handling      │
│  6. DEPENDENCIES       → Vulnerable packages           │
│  7. CONFIGURATION      → CORS, CSP, headers           │
│  8. API SECURITY       → Rate limiting, validation    │
│                                                         │
└────────────────────────────────────────────────────────┘
```

---

## Audit Checklist

### 1. Secret Exposure

```bash
# Scan for secrets in code
grep -r "sk_live\|sk_test\|api_key\|password\|secret" --include="*.js" --include="*.ts" --include="*.py"

# Check for exposed .env files
git log --all --full-history -- "*.env*"

# Verify .gitignore
cat .gitignore | grep -E "\.env|secret|key"
```

**Common patterns to find:**
- Hardcoded API keys: `const apiKey = "sk_live_..."`
- Inline passwords: `password: "admin123"`
- Connection strings: `postgres://user:pass@host`
- JWT secrets: `const JWT_SECRET = "..."`

**Remediation:**
```javascript
// BAD
const apiKey = "sk_live_abc123";

// GOOD
const apiKey = process.env.API_KEY;
```

---

### 2. Injection Attacks

**SQL Injection:**
```javascript
// VULNERABLE
db.query(`SELECT * FROM users WHERE id = '${userId}'`);

// SAFE
db.query('SELECT * FROM users WHERE id = $1', [userId]);
```

**XSS (Cross-Site Scripting):**
```javascript
// VULNERABLE
element.innerHTML = userInput;

// SAFE
element.textContent = userInput;
// Or with sanitization:
element.innerHTML = DOMPurify.sanitize(userInput);
```

**Command Injection:**
```javascript
// VULNERABLE
exec(`convert ${userFile} output.png`);

// SAFE
execFile('convert', [userFile, 'output.png']);
```

---

### 3. Authentication Audit

**Password Hashing:**
```javascript
// Check for proper hashing
import bcrypt from 'bcrypt';
const hash = await bcrypt.hash(password, 10);

// NEVER store plain text
users.password = password; // CRITICAL VULNERABILITY
```

**Session Security:**
```javascript
// Check session configuration
app.use(session({
  secret: process.env.SESSION_SECRET, // ✓ From env
  name: 'sessionId',                   // ✓ Custom name
  cookie: {
    httpOnly: true,                    // ✓ No JS access
    secure: true,                      // ✓ HTTPS only
    sameSite: 'strict',               // ✓ CSRF protection
    maxAge: 3600000                   // ✓ Reasonable timeout
  },
  resave: false,
  saveUninitialized: false
}));
```

**JWT Verification:**
```javascript
// Verify proper JWT handling
const token = jwt.sign(payload, process.env.JWT_SECRET, {
  expiresIn: '15m',  // ✓ Short expiration
  algorithm: 'HS256' // ✓ Explicit algorithm
});

jwt.verify(token, process.env.JWT_SECRET, {
  algorithms: ['HS256']  // ✓ Prevent algorithm confusion
});
```

---

### 4. Authorization Audit

**Access Control Check:**
```javascript
// Verify resource ownership
async function updateProject(projectId, userId, data) {
  const project = await Project.findById(projectId);
  
  // ✓ Check ownership
  if (project.ownerId !== userId) {
    throw new ForbiddenError('Not authorized');
  }
  
  // ✓ Check permissions
  if (!user.permissions.includes('project:update')) {
    throw new ForbiddenError('Missing permission');
  }
  
  return project.update(data);
}
```

**Common Issues:**
- Missing ownership checks
- Insecure direct object references (IDOR)
- Privilege escalation paths
- Missing role verification

---

### 5. Data Protection

**Encryption:**
```javascript
// Data at rest
const encryptedData = crypto.createCipheriv('aes-256-gcm', key, iv);

// Data in transit
// Verify HTTPS: Check all fetch/API calls use https://

// PII handling
const sanitizedUser = {
  id: user.id,
  name: user.name,
  email: maskEmail(user.email), // partial@***.com
  // Never expose: SSN, full card numbers, passwords
};
```

---

### 6. Dependency Audit

```bash
# NPM audit
npm audit
npm audit fix

# Check for vulnerabilities
npx snyk test

# Python
pip-audit
safety check

# Update outdated packages
npm outdated
npm update
```

**Severity Levels:**
- 🔴 Critical: Known exploits available
- 🟠 High: Significant risk
- 🟡 Moderate: Limited exposure
- 🟢 Low: Minimal risk

---

### 7. Configuration Audit

**CORS Check:**
```javascript
// Verify restrictive CORS
app.use(cors({
  origin: ['https://yourdomain.com'], // ✓ Whitelist only
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  credentials: true
}));

// DANGEROUS
app.use(cors({ origin: '*' })); // ✗ Allows all origins
```

**Security Headers:**
```javascript
import helmet from 'helmet';
app.use(helmet()); // Adds security headers

// Verify headers present:
// - X-Content-Type-Options: nosniff
// - X-Frame-Options: DENY
// - Content-Security-Policy: ...
// - Strict-Transport-Security: max-age=...
```

**CSP Check:**
```html
<meta http-equiv="Content-Security-Policy" content="
  default-src 'self';
  script-src 'self';
  style-src 'self' 'unsafe-inline';
  img-src 'self' https: data:;
  connect-src 'self' https://api.yourdomain.com;
  frame-ancestors 'none';
">
```

---

### 8. API Security

**Rate Limiting:**
```javascript
import rateLimit from 'express-rate-limit';

app.use('/api', rateLimit({
  windowMs: 60000,  // 1 minute
  max: 100,         // 100 requests per window
  message: 'Rate limit exceeded'
}));

// Stricter for auth endpoints
app.use('/api/auth', rateLimit({
  windowMs: 900000, // 15 minutes
  max: 5            // 5 attempts
}));
```

**Input Validation:**
```javascript
// Validate ALL inputs
const schema = z.object({
  email: z.string().email().max(254),
  password: z.string().min(8).max(100),
  name: z.string().min(1).max(100)
});

const validated = schema.parse(req.body);
```

---

## Audit Report Template

```markdown
# Security Audit Report

## Summary
- **Application**: [App Name]
- **Version**: [Version]
- **Audit Date**: [Date]
- **Auditor**: [Name]

## Executive Summary
[1-2 paragraph overview of findings]

## Risk Score: [HIGH/MEDIUM/LOW]

## Critical Findings (X)
| # | Issue | Location | Status |
|---|-------|----------|--------|
| 1 | API key in source | src/config.js:12 | Open |

## High Priority (X)
| # | Issue | Location | Status |
|---|-------|----------|--------|
| 1 | SQL injection risk | src/db.js:45 | Open |

## Medium Priority (X)
[Table]

## Low Priority (X)
[Table]

## Passed Checks ✅
- [ ] No secrets in repository
- [ ] Dependencies up to date
- [ ] HTTPS enforced
- [ ] Authentication secure
- [ ] Rate limiting enabled

## Recommendations
1. [Specific action 1]
2. [Specific action 2]
3. [Specific action 3]

## Next Steps
- [ ] Fix critical issues within 24 hours
- [ ] Fix high priority within 1 week
- [ ] Schedule follow-up audit
```

---

## Output

Deliverables:
1. Categorized vulnerability list
2. Risk severity assessment
3. Specific remediation steps
4. Security checklist results
5. Executive summary for stakeholders
]]>