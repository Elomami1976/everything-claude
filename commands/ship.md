<![CDATA[# /ship Command

Run a pre-launch checklist to verify your project is ready to ship.

## Usage

```
/ship              # Full checklist
/ship --quick      # Critical items only
/ship --category   # Specific category
```

## Output Format

---

```markdown
# 🚢 Ship Checklist

**Project**: [name]
**Checked**: [timestamp]
**Status**: [✅ Ready to Ship | ⚠️ Issues Found | 🛑 Not Ready]

---

## Summary

| Category | Status | Issues |
|----------|--------|--------|
| Essential Files | ✅ | 0 |
| Security | ⚠️ | 2 |
| Code Quality | ✅ | 0 |
| UI/UX | ⚠️ | 1 |
| Performance | ✅ | 0 |
| SEO | ✅ | 0 |

**Total Issues**: X critical, Y warnings

---

## 📄 Essential Files

### README.md
- [ ] ✅ Exists
- [ ] ✅ Has installation instructions
- [ ] ✅ Has usage examples
- [ ] ⚠️ Missing: Screenshots/demo
- [ ] ✅ Has license info

### LICENSE
- [ ] ✅ Exists (MIT)
- [ ] ✅ Year is current
- [ ] ✅ Name is correct

### .gitignore
- [ ] ✅ Exists
- [ ] ✅ Ignores node_modules/
- [ ] ✅ Ignores .env files
- [ ] ⚠️ Missing: IDE files (.vscode, .idea)

### .env.example
- [ ] ✅ Exists
- [ ] ✅ Documents all required vars
- [ ] ✅ No real secrets

### package.json (or equivalent)
- [ ] ✅ Name is set
- [ ] ✅ Version is set
- [ ] ✅ Description exists
- [ ] ✅ License matches LICENSE file
- [ ] ⚠️ Missing: Repository URL

---

## 🔒 Security Checklist

### Secrets
- [ ] ✅ No API keys in source code
- [ ] ✅ No passwords in source code
- [ ] ✅ .env files are gitignored
- [ ] ❌ Found potential secret in `config.js:12`

### Dependencies
- [ ] ✅ `npm audit` clean (0 vulnerabilities)
- [ ] ⚠️ 3 outdated packages (non-critical)

### Configuration
- [ ] ✅ Debug mode disabled
- [ ] ✅ CORS properly configured
- [ ] ⚠️ Missing: CSP headers

### Authentication (if applicable)
- [ ] ✅ Passwords hashed
- [ ] ✅ Sessions expire
- [ ] ✅ Rate limiting enabled

---

## 💻 Code Quality

### Error Handling
- [ ] ✅ All async operations have try/catch
- [ ] ✅ Errors logged appropriately
- [ ] ✅ User-friendly error messages

### Testing
- [ ] ⚠️ Test coverage: 65% (target: 80%)
- [ ] ✅ All tests passing
- [ ] ⚠️ Missing tests for: `payment.ts`

### Code Style
- [ ] ✅ No linting errors
- [ ] ✅ Consistent formatting
- [ ] ✅ No console.log statements

### Documentation
- [ ] ✅ Public functions documented
- [ ] ⚠️ Complex logic needs comments: `algorithm.ts:45`

---

## 🎨 UI/UX Checklist

### Responsive Design
- [ ] ✅ Works on mobile (320px+)
- [ ] ✅ Works on tablet (768px+)
- [ ] ✅ Works on desktop (1024px+)

### Accessibility
- [ ] ✅ All images have alt text
- [ ] ⚠️ Missing: Skip navigation link
- [ ] ✅ Sufficient color contrast
- [ ] ✅ Keyboard navigable

### User Feedback
- [ ] ✅ Loading states present
- [ ] ✅ Error states handled
- [ ] ✅ Success confirmations shown
- [ ] ⚠️ Missing: Empty states

### Cross-Browser
- [ ] ✅ Chrome
- [ ] ✅ Firefox
- [ ] ✅ Safari
- [ ] ⚠️ Not tested: Edge

---

## ⚡ Performance

### Loading
- [ ] ✅ First Contentful Paint < 1.5s
- [ ] ✅ Largest Contentful Paint < 2.5s
- [ ] ✅ Time to Interactive < 3.5s

### Assets
- [ ] ✅ Images optimized
- [ ] ✅ JS bundled/minified
- [ ] ✅ CSS bundled/minified
- [ ] ✅ Gzip/Brotli enabled

### Caching
- [ ] ✅ Static assets cached
- [ ] ✅ API responses cached (where appropriate)

---

## 🔍 SEO Checklist

### Meta Tags
- [ ] ✅ Title tag present
- [ ] ✅ Meta description present
- [ ] ✅ Open Graph tags
- [ ] ✅ Twitter cards

### Technical
- [ ] ✅ robots.txt exists
- [ ] ✅ sitemap.xml exists
- [ ] ✅ Canonical URLs set
- [ ] ✅ HTTPS enabled

### Content
- [ ] ✅ H1 tag present
- [ ] ✅ Headings hierarchy correct
- [ ] ✅ Alt text on images

---

## 📊 Analytics & Monitoring

### Tracking
- [ ] ⚠️ Analytics not configured
- [ ] ⚠️ Error tracking not set up

### Recommended Services
- Analytics: Plausible, PostHog, Mixpanel
- Error tracking: Sentry
- Uptime: Betterstack, Checkly

---

## ❌ Blockers Found

Issues that MUST be fixed before shipping:

1. **[CRITICAL]** Potential secret in `config.js:12`
   - Fix: Move to environment variable

---

## ⚠️ Warnings

Issues that SHOULD be fixed but won't block launch:

1. **[WARNING]** Missing CSP headers
   - Recommendation: Add helmet middleware

2. **[WARNING]** Test coverage at 65%
   - Recommendation: Add tests for payment module

3. **[WARNING]** Analytics not configured
   - Recommendation: Set up Plausible

---

## ✅ Ready to Ship?

\`\`\`
❌ Not quite — fix 1 critical issue first

After fixing:
✅ All critical issues resolved
✅ Go ahead and ship! 🚀
\`\`\`

---

## 🚀 Deploy Commands

\`\`\`bash
# Vercel
vercel --prod

# Netlify
netlify deploy --prod

# Railway
railway up

# Manual
npm run build
npm start
\`\`\`
```

---

## Checklist Categories

### Essential Files Check
```
README.md:
  - exists
  - has_installation
  - has_usage
  - has_license

LICENSE:
  - exists
  - valid_type

.gitignore:
  - exists
  - ignores_deps
  - ignores_env
  - ignores_build

.env.example:
  - exists
  - documents_vars
  - no_real_values

package.json:
  - has_name
  - has_version
  - has_description
  - has_license
  - has_scripts
```

### Security Check
```
secrets:
  - no_api_keys_in_code
  - no_passwords_in_code
  - env_files_gitignored

dependencies:
  - npm_audit_clean
  - no_critical_vulns

configuration:
  - debug_disabled
  - cors_configured
  - csp_headers
```

### Mobile Responsiveness Check
```
breakpoints:
  - 320px (mobile small)
  - 375px (mobile)
  - 768px (tablet)
  - 1024px (desktop)
  - 1440px (large desktop)

elements:
  - no_horizontal_scroll
  - touch_targets_44px
  - readable_text_size
  - proper_spacing
```

---

## Example Output

```
/ship

# 🚢 Ship Checklist

**Project**: pdf-buddy
**Checked**: 2024-01-15 14:30 UTC
**Status**: ⚠️ Issues Found

## Summary

| Category | Status | Issues |
|----------|--------|--------|
| Essential Files | ✅ | 0 |
| Security | ✅ | 0 |
| Code Quality | ⚠️ | 1 |
| UI/UX | ✅ | 0 |
| Performance | ✅ | 0 |
| SEO | ⚠️ | 1 |

**Total Issues**: 0 critical, 2 warnings

❌ Not quite ready — address warnings

## ⚠️ Warnings

1. **Test coverage at 72%**
   - Add tests for merge.js functions

2. **Missing Twitter card meta tags**
   - Add twitter:card, twitter:title, twitter:description

## ✅ After addressing warnings:
Ready to ship! 🚀
```
]]>