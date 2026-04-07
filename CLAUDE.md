<![CDATA[# everything-claude

A comprehensive agent harness performance optimization kit for Claude Code, Cursor, OpenCode, and Codex.

## Overview

This repository provides a complete system for enhancing AI coding assistants with:
- Coding rules and standards
- Reusable skills for common tasks
- Slash commands for workflows
- Pre-configured agents
- Automated hooks

## Skills

The following skills are available:

### Building Skills
- **web-tool-builder** — Create privacy-first browser tools as single HTML files
- **chrome-extension-builder** — Build Manifest V3 Chrome extensions with BYOK AI, Stripe subscriptions
- **saas-builder** — Full SaaS product scaffolding with Next.js/FastAPI, Supabase, Stripe
- **api-connector** — Integrate third-party APIs (payment, auth, analytics)

### Quality Skills
- **code-review** — Comprehensive code review with severity levels
- **security-audit** — Security vulnerability scanning and fixes

### Launch Skills
- **seo-optimizer** — SEO and GEO optimization for AI search engines
- **product-hunt-launch** — Complete Product Hunt launch preparation
- **monetization-planner** — Revenue strategy and pricing optimization

## Commands

| Command | Description |
|---------|-------------|
| `/build` | Generate a full build prompt from a product description |
| `/review` | Review code with severity-based issue reporting |
| `/audit` | Security audit for exposed secrets, XSS, CORS issues |
| `/plan` | Create implementation plan for a feature |
| `/ship` | Pre-launch checklist verification |
| `/launch` | Generate Product Hunt launch kit |

## Agents

### chrome-ext-agent
End-to-end Chrome extension builder that handles:
- Manifest V3 configuration
- Background service workers
- Popup UI
- Content scripts
- Chrome Web Store packaging

### saas-agent
Full SaaS product scaffolder that handles:
- Database schema design
- Authentication with Supabase
- Stripe payment integration
- Landing page creation
- Deployment configuration

### web-tool-agent
Single-file web tool creator that handles:
- Privacy-first architecture
- No dependencies
- localStorage state management
- Mobile-responsive design
- PWA capabilities

## Hooks

Located in `hooks/hooks.json`:

1. **PreToolUse** — Before writing any file, checks if it already exists
2. **PostToolUse** — After writing a file, logs what was created
3. **SessionStart** — Displays welcome message with available commands
4. **Stop** — Saves session summary to `.claude/session-log.md`

## Rules

### Common Rules
- `core.md` — Research first, simple solutions, error handling
- `git.md` — Conventional commits, branch naming, PR checklists
- `security.md` — API key protection, input validation, CSP
- `documentation.md` — Self-documenting code, README standards

### JavaScript Rules
- `general.md` — Modern JS best practices
- `chrome-extension.md` — Manifest V3, service workers, message passing
- `saas.md` — Stripe, Supabase, freemium architecture

### Python Rules
- `general.md` — Modern Python best practices
- `fastapi.md` — Router organization, Pydantic, async patterns
- `scripts.md` — CLI tools, automation scripts

### TypeScript Rules
- `general.md` — Type safety, generics, utility types
- `react.md` — Hooks, components, state management

## Usage

Reference skills in prompts:
```
Using the chrome-extension-builder skill, create an extension that...
```

Use commands:
```
/build A web tool that converts PDFs to images
/review src/main.js
/ship
```

Activate agents:
```
@chrome-ext-agent Build an extension that blocks social media during work hours
```

## File Locations

After installation, files are located at:
- Rules: `~/.claude/rules/`
- Skills: `~/.claude/skills/`
- Commands: `~/.claude/commands/`
- Agents: `~/.claude/agents/`
- Hooks: `~/.claude/hooks/`
]]>