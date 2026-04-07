# Templates

Ready-to-use project starters. Copy and customize — don't start from scratch.

## Available Templates

| Template | Description | Time to First Run |
|---|---|---|
| [chrome-extension/](chrome-extension/) | Manifest V3 popup extension | 5 minutes |
| [web-tool/](web-tool/) | Privacy-first single-file tool | 2 minutes |
| [saas/](saas/) | Next.js + Supabase + Stripe | 30 minutes |

---

## Chrome Extension

Manifest V3 extension with popup, background service worker, options page, and clean CSS.

```bash
# Copy to your project
cp -r templates/chrome-extension/ my-extension/

# Load in Chrome
# chrome://extensions → Developer mode → Load unpacked → select my-extension/
```

See [chrome-extension/README.md](chrome-extension/README.md) for details.

---

## Web Tool

Single HTML file with drag-and-drop, progress bar, output display, copy/download buttons, and zero dependencies.

```bash
# Copy to your project
cp templates/web-tool/index.html my-tool/index.html

# Open in browser
open my-tool/index.html
```

See [web-tool/README.md](web-tool/README.md) for details.

---

## SaaS Starter

Production-ready Next.js SaaS with auth, Stripe subscriptions, billing portal, and webhooks.

```bash
# Start a new Next.js project
npx create-next-app@latest my-saas --typescript --tailwind --app
cd my-saas

# Copy template files
cp -r templates/saas/src/ ./src/
cp templates/saas/middleware.ts ./middleware.ts
cp templates/saas/.env.example .env.local

# Install dependencies
npm install @supabase/supabase-js @supabase/auth-helpers-nextjs stripe
```

See [saas/README.md](saas/README.md) for full setup.

---

## Using Templates with AI

Reference templates in your AI prompts to build on top of them:

```
Using the template at templates/chrome-extension/ as a base,
build an extension that highlights prices on Amazon
```

```
Start from templates/saas/ and add a team workspace feature
with multiple users per account
```
