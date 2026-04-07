<![CDATA[# /audit Command

Perform a comprehensive security audit of the current project.

## Usage

```
/audit              # Audit entire project
/audit src/         # Audit specific directory
/audit --quick      # Fast scan (critical issues only)
/audit --full       # Deep scan (everything)
```

## What It Checks

1. **Exposed Secrets** — API keys, passwords, tokens in source
2. **XSS Vectors** — innerHTML, eval, document.write
3. **SQL Injection** — String concatenation in queries
4. **CORS Misconfiguration** — Overly permissive CORS
5. **Outdated Dependencies** — Known vulnerabilities
6. **Auth Issues** — Weak session config, improper checks
7. **Data Exposure** — Sensitive data in logs, responses
8. **Configuration** — Missing security headers, debug mode

## Output Format

---

```markdown
# 🔒 Security Audit Report

**Project**: [project name]
**Scanned**: [timestamp]
**Files Scanned**: [count]
**Vulnerabilities Found**: [count]

## Overall Risk Level: [🔴 HIGH | 🟠 MEDIUM | 🟢 LOW]

[Brief summary of findings]

---

## 🔴 Critical Vulnerabilities ([count])

### [CVE or Issue Name]
**Severity**: Critical (CVSS: X.X)
**Location**: [file:line]
**Type**: [Category]

**Description**: 
[What the vulnerability is]

**Impact**: 
[What an attacker could do]

**Evidence**:
\`\`\`[language]
[The vulnerable code]
\`\`\`

**Remediation**:
\`\`\`[language]
[The fixed code]
\`\`\`

**References**:
- [Link to CVE/documentation]

---

## 🟠 High Vulnerabilities ([count])

[Same format]

---

## 🟡 Medium Vulnerabilities ([count])

[Same format]

---

## 🟢 Low Vulnerabilities ([count])

[Same format]

---

## 📦 Dependency Audit

| Package | Current | Severity | CVE | Fix Version |
|---------|---------|----------|-----|-------------|
| package1 | 1.0.0 | Critical | CVE-2024-XXXX | 1.2.0 |
| package2 | 2.3.4 | High | CVE-2024-YYYY | 2.4.0 |

**To fix**: Run `npm audit fix` or `pip install --upgrade [package]`

---

## ✅ Passed Checks

- [x] No hardcoded credentials found
- [x] HTTPS enforced
- [x] SQL queries parameterized
- [ ] CORS properly restricted
- [ ] CSP headers configured
- [x] Input validation present

---

## 📋 Recommendations

### Immediate (within 24 hours)
1. [Action 1]
2. [Action 2]

### Short-term (within 1 week)
1. [Action 1]
2. [Action 2]

### Long-term (within 1 month)
1. [Action 1]
2. [Action 2]

---

## 🛠️ Quick Fixes

Run these commands to fix some issues automatically:

\`\`\`bash
# Update vulnerable dependencies
npm audit fix

# Check for exposed secrets
npx secretlint "**/*"

# Add security headers
npm install helmet
\`\`\`
```

---

## Scan Patterns

### Secrets Detection
```regex
# API Keys
/(api[_-]?key|apikey)\s*[:=]\s*['"][a-zA-Z0-9-_]{20,}['"]/i

# AWS
/AKIA[0-9A-Z]{16}/

# Stripe
/sk_live_[a-zA-Z0-9]{24,}/
/rk_live_[a-zA-Z0-9]{24,}/

# Generic secrets
/password\s*[:=]\s*['"][^'"]+['"]/i
/secret\s*[:=]\s*['"][^'"]+['"]/i
```

### XSS Vectors
```regex
/\.innerHTML\s*=(?!.*DOMPurify)/
/document\.write\(/
/eval\(/
/new Function\(/
/setTimeout\(\s*['"`]/
```

### SQL Injection
```regex
/query\(.*\+.*\)/
/query\(`.*\${/
/\.query\(.*'.*\+.*\+.*'/
```

### CORS Issues
```regex
/cors\(\{\s*origin:\s*['"]?\*['"]?/
/Access-Control-Allow-Origin['":\s]+\*/
```

---

## Example Output

```markdown
# 🔒 Security Audit Report

**Project**: my-saas-app
**Scanned**: 2024-01-15 14:30 UTC
**Files Scanned**: 156
**Vulnerabilities Found**: 12

## Overall Risk Level: 🟠 MEDIUM

Found 2 critical issues that need immediate attention: an exposed API key and an SQL injection vulnerability. Several medium-priority issues around CORS and authentication should be addressed before production deployment.

---

## 🔴 Critical Vulnerabilities (2)

### Exposed Stripe Secret Key
**Severity**: Critical (CVSS: 9.8)
**Location**: src/config/stripe.js:3
**Type**: Secret Exposure

**Description**: 
Stripe secret key is hardcoded in source code. This grants full access to your Stripe account.

**Impact**: 
Attackers can:
- Charge or refund any payment
- Access customer data
- Download tax reports
- Delete webhook endpoints

**Evidence**:
\`\`\`javascript
// src/config/stripe.js:3
const stripe = new Stripe('sk_live_4242424242424242424242');
\`\`\`

**Remediation**:
\`\`\`javascript
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
\`\`\`

Also:
- Rotate the exposed key immediately in Stripe dashboard
- Add STRIPE_SECRET_KEY to .env (and .gitignore)
- Check git history for exposure

---

### SQL Injection in User Search
**Severity**: Critical (CVSS: 9.1)
**Location**: src/api/users.js:45
**Type**: Injection

**Description**: 
User input directly concatenated into SQL query.

**Impact**: 
Attackers can:
- Read entire database
- Modify or delete data
- Bypass authentication

**Evidence**:
\`\`\`javascript
// src/api/users.js:45
const query = `SELECT * FROM users WHERE name LIKE '%${search}%'`;
const users = await db.query(query);
\`\`\`

**Remediation**:
\`\`\`javascript
const query = 'SELECT * FROM users WHERE name LIKE $1';
const users = await db.query(query, [`%${search}%`]);
\`\`\`

---

## 📦 Dependency Audit

| Package | Current | Severity | CVE | Fix Version |
|---------|---------|----------|-----|-------------|
| axios | 0.21.1 | High | CVE-2021-3749 | 0.21.2 |
| jsonwebtoken | 8.5.1 | High | CVE-2022-23529 | 9.0.0 |
| lodash | 4.17.15 | Critical | CVE-2021-23337 | 4.17.21 |

---

## ✅ Passed Checks

- [x] HTTPS redirects configured
- [x] Password hashing (bcrypt)
- [x] Rate limiting on auth endpoints
- [x] CSRF protection
- [ ] ❌ No CSP headers
- [ ] ❌ CORS allows all origins

---

## 📋 Recommendations

### Immediate (within 24 hours)
1. Remove and rotate exposed Stripe key
2. Fix SQL injection vulnerability
3. Update lodash to 4.17.21

### Short-term (within 1 week)
1. Configure Content Security Policy
2. Restrict CORS to specific origins
3. Update axios and jsonwebtoken
```

---

## Integration

The `/audit` command integrates with:
- `npm audit` / `pip-audit` for dependency scanning
- Custom regex patterns for code analysis
- `.gitignore` awareness (still scans but flags if might be committed)
- Previous audit results for comparison
]]>