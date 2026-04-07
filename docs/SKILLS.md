<![CDATA[# Skills Reference

Complete documentation for all skills in the everything-claude toolkit.

## Overview

Skills are specialized capability modules that teach the AI how to perform specific tasks. Each skill contains domain knowledge, patterns, and best practices for a particular area.

| Skill | Domain | Use Case |
|-------|--------|----------|
| [web-tool-builder](#web-tool-builder) | Development | Privacy-first single-file web tools |
| [chrome-extension-builder](#chrome-extension-builder) | Development | Chrome extensions with Manifest V3 |
| [saas-builder](#saas-builder) | Development | Full SaaS applications |
| [api-connector](#api-connector) | Development | Third-party API integrations |
| [code-review](#code-review) | Quality | Code review with severity levels |
| [security-audit](#security-audit) | Security | Vulnerability scanning |
| [seo-optimizer](#seo-optimizer) | Marketing | SEO and technical optimization |
| [product-hunt-launch](#product-hunt-launch) | Marketing | Product Hunt launch preparation |
| [monetization-planner](#monetization-planner) | Business | Pricing and monetization strategy |

---

## web-tool-builder

**File**: `skills/web-tool-builder.md`

Creates privacy-first, single-file web tools that run entirely in the browser.

### Capabilities
- Single HTML file architecture
- Client-side processing only
- Web Workers for heavy operations
- File handling with FileReader
- Drag-and-drop interfaces

### Example Tools
- PDF merger/splitter
- Image compressor
- JSON formatter
- Text diff tool

### Key Principles
1. **No data leaves the browser** — All processing happens client-side
2. **No external dependencies** — Everything in one file
3. **Works offline** — After initial load
4. **Mobile responsive** — Works on all devices

---

## chrome-extension-builder

**File**: `skills/chrome-extension-builder.md`

Builds Chrome extensions using Manifest V3 with BYOK monetization.

### Capabilities
- Manifest V3 architecture
- Service workers
- Content scripts
- BYOK (Bring Your Own Key) patterns
- Stripe + Supabase integration

### Key Patterns
- Popup ↔ Background communication
- Storage sync across devices
- API key management
- Cross-browser compatibility

### Monetization Models
1. Pure BYOK (free extension, users provide API keys)
2. Freemium BYOK (premium features + BYOK)
3. Credit system (you manage API calls)
4. Hybrid approach

---

## saas-builder

**File**: `skills/saas-builder.md`

Scaffolds complete SaaS applications with modern stack.

### Stack
- **Frontend**: Next.js 14+ (App Router)
- **Styling**: Tailwind CSS + shadcn/ui
- **Database**: Supabase (Postgres)
- **Auth**: Supabase Auth
- **Payments**: Stripe

### Features
- Authentication (OAuth + Magic Link)
- Subscription billing
- Customer portal
- Webhook handling
- Row Level Security

### Output Structure
```
src/
├── app/
│   ├── (marketing)/
│   ├── (auth)/
│   ├── (dashboard)/
│   └── api/
├── components/
├── lib/
└── types/
```

---

## api-connector

**File**: `skills/api-connector.md`

Integrates third-party APIs with best practices.

### Covered APIs
- OpenAI / Anthropic
- Stripe
- Supabase
- Twilio
- SendGrid
- AWS S3

### Patterns
- Rate limiting
- Error handling
- Retry logic
- Caching
- Webhook verification

### Security Practices
- API key management
- Request signing
- Token refresh
- Scope minimization

---

## code-review

**File**: `skills/code-review.md`

Performs comprehensive code reviews with severity-based reporting.

### Severity Levels
| Level | Description | Action |
|-------|-------------|--------|
| 🔴 Critical | Must fix before merge | Blocking |
| 🟠 High | Should fix before merge | Strongly recommended |
| 🟡 Medium | Fix soon | Recommended |
| 🟢 Low | Nice to have | Optional |

### Check Categories
- Security vulnerabilities
- Logic bugs
- Performance issues
- Code quality
- Testing gaps
- Documentation

### Output Format
```markdown
# Code Review: [file]

## Verdict: [APPROVED | CHANGES REQUESTED | BLOCKED]

## 🔴 Critical Issues (X)
[Details...]

## Summary Table
[Issue counts by category]
```

---

## security-audit

**File**: `skills/security-audit.md`

Performs security audits of codebases and configurations.

### Scan Areas
- Exposed secrets
- XSS vectors
- SQL injection
- CORS misconfiguration
- Outdated dependencies
- Auth issues
- Data exposure

### Detection Patterns
- Regex-based secret detection
- Known vulnerable patterns
- Dependency CVE database
- Configuration analysis

### Output
- Risk level assessment
- Prioritized vulnerability list
- Remediation steps
- Quick fix commands

---

## seo-optimizer

**File**: `skills/seo-optimizer.md`

Optimizes websites for search engines and AI assistants.

### SEO Areas
- Technical SEO (meta tags, sitemap, robots.txt)
- On-page SEO (headings, content, keywords)
- Performance (Core Web Vitals)
- Structured data (Schema.org)

### GEO (Generative Engine Optimization)
- AI-friendly content structure
- Entity optimization
- Source citations
- FAQ markup

### Deliverables
- SEO audit report
- Meta tag templates
- Schema.org implementation
- Sitemap generation

---

## product-hunt-launch

**File**: `skills/product-hunt-launch.md`

Prepares complete Product Hunt launch campaigns.

### Launch Kit Contents
- Tagline options (60 chars max)
- Short description (260 chars max)
- Maker's first comment
- Gallery image specs
- Twitter thread
- LinkedIn post
- Reddit posts
- Email templates

### Launch Day Schedule
Hourly action plan from midnight to midnight PST.

### Checklists
- Pre-launch preparation
- Launch day actions
- Post-launch follow-up

---

## monetization-planner

**File**: `skills/monetization-planner.md`

Designs pricing strategies and tier structures.

### Pricing Models
- Free (open source/donation-based)
- One-time purchase
- Subscription (monthly/yearly)
- Usage-based
- Freemium
- BYOK

### Tier Design
- Feature differentiation
- Price anchoring
- Value metrics
- Upgrade triggers

### Analysis
- Competitor pricing research
- Willingness to pay estimation
- Revenue projections
- Pricing psychology

---

## Using Skills

Skills are automatically invoked based on context, or you can reference them directly:

```
Using the chrome-extension-builder skill, create a tab manager extension...

Apply the code-review skill to src/auth.ts...

Run the security-audit skill on this project...
```

Skills can be combined:
```
Build a Chrome extension (chrome-extension-builder) with premium features (monetization-planner) and prepare for launch (product-hunt-launch).
```
]]>