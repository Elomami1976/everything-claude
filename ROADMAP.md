# Roadmap

This is the direction for everything-claude. Items are ordered by planned release.

---

## v1.0 — Complete

The initial release: a full agent harness kit for Claude Code, Cursor, and Codex.

- 13 coding rules (JS, TS, Python)
- 9 reusable skills
- 6 slash commands
- 3 specialized agents
- Lifecycle hooks
- Install scripts for Unix and Windows

---

## v1.1 — In Progress

Competitive improvements and richer starting materials.

- [ ] `templates/` — Ready-to-copy starters (Chrome extension, SaaS, web tool)
- [ ] `comparisons/` — How this compares to Cursor rules, Copilot instructions, ChatGPT prompts
- [ ] `CONTRIBUTING.md` — Guide for external contributors
- [ ] `CHANGELOG.md` — Release history
- [ ] `.github/workflows/ci.yml` — Automated Markdown and JSON validation
- [ ] GitHub topics and description
- [ ] Awesome-list submissions

---

## v1.2 — Planned

Expand language coverage and add more real-world templates.

- [ ] `rules/rust/` — Memory safety, ownership, clippy conventions
- [ ] `rules/go/` — Idiomatic Go, error handling, goroutines
- [ ] `rules/common/testing.md` — Testing philosophy, coverage guidelines, TDD
- [ ] `templates/react-native/` — Cross-platform mobile starter
- [ ] `templates/fastapi/` — Python API with Pydantic, async routes, auth
- [ ] `skills/test-writer.md` — Generate test suites for existing code
- [ ] `skills/database-designer.md` — Schema design for Postgres/SQLite

---

## v2.0 — Planned

Web interface for browsing and customizing the kit.

- [ ] Web UI at a public URL for browsing rules, skills, and commands
- [ ] One-click copy for individual rules
- [ ] Custom kit builder: select which rules/skills to include
- [ ] Rule search and filtering
- [ ] Usage analytics for popular rules (privacy-preserving)

---

## v3.0 — Concept

Community and ecosystem.

- [ ] Community-contributed rules library
- [ ] Verified rules with quality ratings
- [ ] Private kit hosting for teams
- [ ] Integration with VS Code extension marketplace
- [ ] `npx everything-claude` installer with interactive setup

---

## Not Planned

These are explicitly out of scope for this project:

- Supporting non-Claude AI assistants (GPT-4, Gemini) — use system prompts directly
- Replacing the AI assistant itself — this is a harness, not an AI
- Storing conversation history — that's the assistant's job
- Online collaboration features — use Git for version control

---

## Feedback

Have ideas? Open a [GitHub Discussion](https://github.com/Elomami1976/everything-claude/discussions) — especially for v2.0 and v3.0 features. Community priority shapes the roadmap.
