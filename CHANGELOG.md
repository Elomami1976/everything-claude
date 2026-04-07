# Changelog

All notable changes to this project are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.1.0] — Unreleased

### Added
- `templates/` directory with chrome-extension, web-tool, and saas starters
- `CONTRIBUTING.md` — contribution guide
- `CHANGELOG.md` — this file
- `ROADMAP.md` — project direction
- `comparisons/` — side-by-side comparisons with other tools
- `.github/workflows/ci.yml` — automated markdown and JSON validation
- `.github/AWESOME_LISTS.md` — submission templates for awesome-* lists

---

## [1.0.0] — 2025-01-01

### Added

**Rules** (13 files)
- `rules/common/core.md` — Research-first, simple solutions, minimal error handling
- `rules/common/security.md` — OWASP Top 10, API key protection, input validation
- `rules/common/git.md` — Conventional commits, branch naming, PR checklists
- `rules/common/documentation.md` — Self-documenting code, README standards
- `rules/javascript/general.md` — Modern JS best practices (ES2022+)
- `rules/javascript/chrome-extension.md` — Manifest V3, service workers, message passing
- `rules/javascript/saas.md` — Stripe, Supabase, freemium architecture
- `rules/typescript/general.md` — Type safety, generics, utility types
- `rules/typescript/react.md` — Hooks, components, state management patterns
- `rules/python/general.md` — Modern Python best practices (3.10+)
- `rules/python/fastapi.md` — Router organization, Pydantic, async patterns
- `rules/python/scripts.md` — CLI tools, automation scripts

**Skills** (9 files)
- `skills/web-tool-builder.md` — Single-file HTML tool creation
- `skills/chrome-extension-builder.md` — Manifest V3 extension building
- `skills/saas-builder.md` — Full SaaS scaffolding
- `skills/api-connector.md` — Third-party API integration
- `skills/code-review.md` — Comprehensive review with severity levels
- `skills/security-audit.md` — Vulnerability scanning and fixes
- `skills/seo-optimizer.md` — SEO and GEO optimization
- `skills/product-hunt-launch.md` — Product Hunt preparation
- `skills/monetization-planner.md` — Revenue strategy

**Commands** (6 files)
- `commands/build.md` — Generate full build prompts
- `commands/review.md` — Code review with severity levels
- `commands/audit.md` — Security audit
- `commands/plan.md` — Implementation planning
- `commands/ship.md` — Pre-launch verification
- `commands/launch.md` — Product Hunt launch kit

**Agents** (3 files)
- `agents/chrome-ext-agent.md` — End-to-end Chrome extension builder
- `agents/saas-agent.md` — Full SaaS scaffolder
- `agents/web-tool-agent.md` — Single-file web tool creator

**Hooks** (1 file)
- `hooks/hooks.json` — PreToolUse, PostToolUse, SessionStart, Stop

**Docs** (4 files)
- `docs/SKILLS.md` — Skills reference
- `docs/COMMANDS.md` — Commands reference
- `docs/HOOKS.md` — Hooks reference
- `docs/INSTALL.md` — Installation guide

**Root files**
- `README.md`
- `CLAUDE.md`
- `install.sh` — Unix install script
- `install.ps1` — Windows install script
- `package.json`
- `LICENSE` (MIT)
