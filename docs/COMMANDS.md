<![CDATA[# Commands Reference

Complete documentation for all commands in the everything-claude toolkit.

## Overview

Commands are action triggers that invoke specific workflows. They provide structured output for common development tasks.

| Command | Purpose | Input |
|---------|---------|-------|
| `/build` | Generate build prompts | Product description |
| `/review` | Code review | File path or PR |
| `/audit` | Security audit | Directory (optional) |
| `/launch` | Product Hunt launch kit | Product details |
| `/plan` | Implementation plan | Feature description |
| `/ship` | Pre-launch checklist | None |

---

## /build

**File**: `commands/build.md`

Generates a complete build prompt from a natural language product description.

### Usage
```
/build <product description>
```

### Examples
```
/build A Chrome extension that highlights all prices on Amazon

/build A web tool that converts PDF files to images

/build A SaaS for tracking daily habits
```

### Output Sections
1. **Project Overview** — Name, type, description, success criteria
2. **Tech Stack** — Recommended technologies with rationale
3. **File Structure** — Complete project scaffold
4. **Implementation Steps** — Phased build plan
5. **Key Implementation Details** — Code snippets for complex features

### How It Works
1. Parses description for product type, features, constraints
2. Selects appropriate template (web tool, extension, SaaS)
3. Generates tech stack based on requirements
4. Creates file structure and implementation plan
5. Includes code examples for key features

---

## /review

**File**: `commands/review.md`

Performs comprehensive code reviews with severity-based issue reporting.

### Usage
```
/review <file path>     # Review specific file
/review src/            # Review entire directory
/review                 # Review current file
```

### Severity Levels

| Level | Icon | Meaning |
|-------|------|---------|
| Critical | 🔴 | Must fix before merge |
| High | 🟠 | Should fix before merge |
| Medium | 🟡 | Fix soon |
| Low | 🟢 | Nice to have |

### Output Format
```markdown
# Code Review: [file]

## Verdict: [APPROVED | CHANGES REQUESTED | BLOCKED]

## 🔴 Critical Issues (X)
### Issue Title
**Location**: file:line
**Problem**: [code snippet]
**Fix**: [corrected code]

## Summary Table
| Category | Critical | High | Medium | Low |
|----------|----------|------|--------|-----|
| Security | 1 | 0 | 0 | 0 |
...
```

### Checklist Categories
- Security (secrets, injection, XSS)
- Bugs (null handling, race conditions)
- Performance (N+1 queries, memoization)
- Code Quality (naming, DRY, functions)
- Testing (coverage, edge cases)
- Documentation (comments, README)

---

## /audit

**File**: `commands/audit.md`

Performs comprehensive security audit of the current project.

### Usage
```
/audit              # Full audit
/audit src/         # Audit specific directory
/audit --quick      # Critical issues only
/audit --full       # Deep scan
```

### What It Checks
- **Secrets** — API keys, passwords, tokens in code
- **XSS** — innerHTML, eval, document.write
- **SQL Injection** — String concatenation in queries
- **CORS** — Overly permissive configurations
- **Dependencies** — Known CVEs in packages
- **Auth** — Session handling, token security
- **Configuration** — Debug mode, security headers

### Output Format
```markdown
# 🔒 Security Audit Report

## Overall Risk Level: [HIGH | MEDIUM | LOW]

## 🔴 Critical Vulnerabilities (X)
### Vulnerability Name
**Severity**: Critical (CVSS: X.X)
**Location**: file:line
**Evidence**: [code snippet]
**Remediation**: [fix]

## 📦 Dependency Audit
| Package | Current | Severity | CVE | Fix Version |
|---------|---------|----------|-----|-------------|
...

## ✅ Passed Checks
- [x] No hardcoded credentials
- [ ] CSP headers configured
```

### Integration
- `npm audit` for Node.js projects
- `pip-audit` for Python projects
- Custom regex patterns for code analysis

---

## /launch

**File**: `commands/launch.md`

Generates a complete Product Hunt launch kit.

### Usage
```
/launch                    # For current project
/launch "Product Name"     # Specific product
```

### Output Contents

1. **Tagline Options** — 3 options (60 chars max each)
2. **Short Description** — Ready to paste (260 chars max)
3. **First Comment** — Maker's comment template
4. **Gallery Images** — Specs and content for each slide
5. **Twitter Thread** — 5-tweet launch thread
6. **LinkedIn Post** — Professional announcement
7. **Reddit Posts** — r/SideProject and relevant subreddits
8. **Outreach Email** — Template for personal network
9. **Launch Schedule** — Hour-by-hour action plan
10. **Checklist** — Pre-launch verification

### Image Specifications
- Gallery: 1270 x 760px
- Logo: 240 x 240px
- Recommended: 6-8 gallery images

### Launch Day Timeline
```
12:01 AM PST - Launch goes live
6:00 AM     - Check ranking
7:00 AM     - Post Twitter thread
7:30 AM     - LinkedIn post
8:00 AM     - Email network
...
```

---

## /plan

**File**: `commands/plan.md`

Generates detailed implementation plans for feature requests.

### Usage
```
/plan <feature description>
```

### Examples
```
/plan Add user authentication with Google OAuth

/plan Implement Stripe subscription billing

/plan Add real-time notifications with WebSockets
```

### Output Sections

1. **Summary**
   - Complexity: Low / Medium / High / Very High
   - Estimated Time
   - Risk Level

2. **Files to Create**
   | File | Purpose | Lines (est) |
   |------|---------|-------------|
   
3. **Files to Modify**
   | File | Changes | Risk |
   |------|---------|------|

4. **Implementation Steps**
   - Phased approach (Setup, Core, Polish)
   - Dependencies between steps
   - Code snippets included

5. **Risks & Mitigations**
   - Identified risks with impact assessment
   - Mitigation strategies

6. **Dependencies**
   - External services
   - NPM packages
   - Environment variables

7. **Testing Plan**
   - Unit tests
   - Integration tests
   - E2E tests

8. **Acceptance Criteria**
   - Checkable completion criteria

---

## /ship

**File**: `commands/ship.md`

Runs a pre-launch checklist to verify project readiness.

### Usage
```
/ship              # Full checklist
/ship --quick      # Critical items only
```

### Checklist Categories

| Category | What It Checks |
|----------|----------------|
| Essential Files | README, LICENSE, .gitignore, .env.example |
| Security | Secrets, dependencies, configuration |
| Code Quality | Error handling, testing, documentation |
| UI/UX | Responsive design, accessibility, feedback |
| Performance | Load time, asset optimization, caching |
| SEO | Meta tags, robots.txt, sitemap |

### Output Format
```markdown
# 🚢 Ship Checklist

**Status**: [✅ Ready | ⚠️ Issues Found | 🛑 Not Ready]

## Summary
| Category | Status | Issues |
|----------|--------|--------|
| Essential Files | ✅ | 0 |
| Security | ⚠️ | 2 |
...

## ❌ Blockers Found
[Critical issues that must be fixed]

## ⚠️ Warnings
[Issues that should be fixed but don't block]

## ✅ Ready to Ship?
[Yes/No with reasoning]
```

### Pass Criteria
- No critical security issues
- Essential files present
- Responsive on mobile
- Core functionality working

---

## Command Chaining

Commands can be used together in workflows:

```
1. /build a habit tracking SaaS
2. [implement the project]
3. /review src/
4. /audit
5. /ship
6. /launch
```

## Custom Commands

Add new commands by creating files in `commands/` directory:

```markdown
# /mycommand

Description of what the command does.

## Usage
/mycommand <arguments>

## Output Format
[Define expected output structure]
```
]]>