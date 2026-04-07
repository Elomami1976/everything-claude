# everything-claude vs GitHub Copilot Instructions

A feature comparison to help you understand when to use each approach.

## Overview

| Feature | everything-claude | Copilot `.github/copilot-instructions.md` |
|---|---|---|
| **Scope** | Any Claude-based assistant | GitHub Copilot only |
| **Portability** | Claude Code, Cursor, OpenCode, Codex | GitHub Copilot (VS Code, JetBrains, web) |
| **Modularity** | Rules per language, skills per task | Single file |
| **Skills system** | Reusable prompt libraries | Not available |
| **Commands** | Slash commands `/build`, `/audit` | Not natively supported |
| **Agents** | Pre-configured agents per task | Not available |
| **Hooks** | Automated lifecycle hooks | Not available |
| **Templates** | Starter code per project type | Not included |
| **Setup** | Shell script install | Drop a file in `.github/` |

---

## Strengths of each

### everything-claude strengths

- **Modular rules** — Apply `rules/python/fastapi.md` only to Python files; keep React rules separate
- **Skills** — Pre-packaged domain knowledge for specific tasks (SaaS building, security audits)
- **Agents** — Specialized agents with focused system prompts per task type
- **Hooks** — Automate checks before/after file writes, session logging
- **Multi-assistant** — Works with any Claude-based tool, not locked to one vendor

### Copilot instructions strengths

- **Zero setup** — One file in `.github/` and it works
- **Deep IDE integration** — Code completions affected, not just chat
- **Part of the repo** — Version controlled, shared across the whole team automatically
- **No install** — No scripts, no configuration

---

## When to use everything-claude

- You use Claude Code, Cursor, or OpenCode as your primary assistant
- You want different rules for different languages/frameworks
- You want reusable skills you can invoke on demand
- You're building a product and want agents tuned for specific tasks

## When to use Copilot instructions

- Your team already uses GitHub Copilot and just wants consistent style
- You want something that works without any setup
- You need inline code completion to follow your conventions, not just chat

---

## Using both

They're not mutually exclusive. You can keep a `.github/copilot-instructions.md` with team-wide standards (naming conventions, preferred libraries) and use everything-claude for deeper AI-assisted workflows.

```
# In .github/copilot-instructions.md — brief universal rules
# In ~/.claude/rules/ — detailed language-specific guidance
```

The two work in different contexts and complement each other.
