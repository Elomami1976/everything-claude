<![CDATA[# Security Rules

Security must be considered at every stage of development. These rules protect your users and your business.

## 1. Never Expose API Keys in Frontend Code

**API keys in client-side code can be extracted by anyone:**

**NEVER DO THIS:**
```javascript
// BAD: API key in frontend code
const apiKey = 'sk_live_abc123'; // Anyone can see this!
fetch(`https://api.stripe.com/v1/charges`, {
  headers: { 'Authorization': `Bearer ${apiKey}` }
});
```

**DO THIS INSTEAD:**
```javascript
// GOOD: Call your own backend
const response = await fetch('/api/create-charge', {
  method: 'POST',
  body: JSON.stringify({ amount: 1000 })
});
// Backend handles Stripe with server-side key
```

**Types of keys that MUST be server-side only:**
- Stripe secret keys (sk_*)
- Database connection strings
- OAuth client secrets
- API keys with write permissions
- Admin tokens

**Keys that CAN be in frontend (with restrictions):**
- Stripe publishable keys (pk_* — these are designed for frontend)
- Google Maps API keys (with HTTP referrer restrictions)
- Firebase client config (with security rules)

---

## 2. Always Validate User Input

**Never trust ANY input from users:**

**Validation checklist:**
- [ ] Type checking (string vs number vs array)
- [ ] Length limits (max characters, max items)
- [ ] Format validation (email, URL, phone)
- [ ] Range checking (min/max values)
- [ ] Allowed characters (whitelist over blacklist)
- [ ] Business logic validation (is this user allowed to do this?)

**Validation on BOTH sides:**
```javascript
// Frontend: UX validation
function validateEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

// Backend: Security validation (REQUIRED)
function validateEmailSecure(email) {
  if (typeof email !== 'string') return false;
  if (email.length > 254) return false;
  if (!emailRegex.test(email)) return false;
  return true;
}
```

**Common attacks prevented by validation:**
- SQL injection: `'; DROP TABLE users; --`
- XSS: `<script>alert('hacked')</script>`
- Path traversal: `../../../etc/passwd`
- Buffer overflow: Very long strings
- Type confusion: Arrays where strings expected

---

## 3. Use Environment Variables

**Configuration should be external to code:**

**.env file (never commit this):**
```env
DATABASE_URL=postgres://user:pass@localhost:5432/db
STRIPE_SECRET_KEY=sk_live_xxx
JWT_SECRET=your-256-bit-secret
SMTP_PASSWORD=email-password
```

**.env.example file (commit this):**
```env
DATABASE_URL=postgres://user:pass@localhost:5432/db
STRIPE_SECRET_KEY=sk_test_xxx
JWT_SECRET=generate-a-secret
SMTP_PASSWORD=your-smtp-password
```

**Loading environment variables:**
```javascript
// Node.js
import 'dotenv/config';
const stripeKey = process.env.STRIPE_SECRET_KEY;

// Python
from dotenv import load_dotenv
import os
load_dotenv()
stripe_key = os.getenv('STRIPE_SECRET_KEY')
```

**Gitignore MUST include:**
```gitignore
.env
.env.local
.env.*.local
*.pem
*.key
```

---

## 4. CORS Configuration

**Cross-Origin Resource Sharing controls who can call your API:**

**Restrictive CORS (production):**
```javascript
// Express.js
app.use(cors({
  origin: ['https://yourdomain.com', 'https://app.yourdomain.com'],
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));
```

**NEVER in production:**
```javascript
// DANGEROUS: Allows ANY website to call your API
app.use(cors({ origin: '*' }));
```

**CORS checklist:**
- [ ] Whitelist specific origins
- [ ] Limit allowed methods to what's needed
- [ ] Limit allowed headers
- [ ] Set credentials: true only if using cookies
- [ ] Validate Origin header on sensitive endpoints

---

## 5. Content Security Policy (CSP)

**CSP prevents XSS by controlling what resources can load:**

**Basic secure CSP:**
```html
<meta http-equiv="Content-Security-Policy" content="
  default-src 'self';
  script-src 'self';
  style-src 'self' 'unsafe-inline';
  img-src 'self' https: data:;
  font-src 'self';
  connect-src 'self' https://api.yourdomain.com;
  frame-ancestors 'none';
">
```

**CSP directives explained:**
- `default-src 'self'` — Only load from same origin by default
- `script-src 'self'` — Only run scripts from same origin (blocks inline)
- `style-src 'self' 'unsafe-inline'` — Allow inline styles (needed for some frameworks)
- `img-src 'self' https: data:` — Images from same origin, HTTPS, or data URIs
- `connect-src` — Whitelist API endpoints
- `frame-ancestors 'none'` — Prevent clickjacking

**Server-side CSP (preferred):**
```javascript
// Express.js with helmet
import helmet from 'helmet';
app.use(helmet.contentSecurityPolicy({
  directives: {
    defaultSrc: ["'self'"],
    scriptSrc: ["'self'"],
    styleSrc: ["'self'", "'unsafe-inline'"],
  }
}));
```

---

## 6. Authentication Rules

**Password handling:**
- NEVER store plaintext passwords
- Use bcrypt (cost factor 10+) or Argon2
- Minimum 8 characters, check against breached password lists
- Implement rate limiting on login attempts

**Session management:**
```javascript
// Good session settings
app.use(session({
  secret: process.env.SESSION_SECRET,
  name: 'sessionId', // Don't use default 'connect.sid'
  cookie: {
    httpOnly: true,     // Prevents XSS access to cookies
    secure: true,       // HTTPS only
    sameSite: 'strict', // Prevents CSRF
    maxAge: 3600000     // 1 hour
  },
  resave: false,
  saveUninitialized: false
}));
```

**JWT rules:**
- Use strong secrets (256+ bits)
- Set reasonable expiration (15 min for access tokens)
- Include only necessary claims
- Never store sensitive data in JWT payload (it's only base64 encoded)

---

## 7. SQL Injection Prevention

**ALWAYS use parameterized queries:**

```javascript
// GOOD: Parameterized query
const user = await db.query(
  'SELECT * FROM users WHERE id = $1',
  [userId]
);

// BAD: String concatenation
const user = await db.query(
  `SELECT * FROM users WHERE id = '${userId}'`
);
```

**ORM usage:**
```javascript
// Prisma (safe by default)
const user = await prisma.user.findUnique({
  where: { id: userId }
});
```

---

## 8. File Upload Security

**File upload checklist:**
- [ ] Validate file type (check magic bytes, not just extension)
- [ ] Limit file size
- [ ] Generate new random filenames
- [ ] Store outside webroot
- [ ] Scan for malware if possible
- [ ] Set proper Content-Type when serving

```javascript
import fileType from 'file-type';

async function validateUpload(buffer, allowedTypes) {
  const type = await fileType.fromBuffer(buffer);
  if (!type || !allowedTypes.includes(type.mime)) {
    throw new Error('Invalid file type');
  }
  return type;
}
```

---

## Quick Security Checklist

- [ ] No API keys in client-side code
- [ ] All user input validated server-side
- [ ] Secrets in environment variables
- [ ] .env files in .gitignore
- [ ] CORS restricted to known origins
- [ ] CSP headers configured
- [ ] Passwords hashed with bcrypt/Argon2
- [ ] Sessions configured securely
- [ ] SQL queries parameterized
- [ ] File uploads validated
]]>