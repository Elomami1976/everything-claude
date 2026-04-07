# everything-claude vs ChatGPT Custom Instructions

A comparison for developers using OpenAI tools vs Claude-based assistants.

## Overview

| Feature | everything-claude | ChatGPT Custom Instructions |
|---|---|---|
| **Platform** | Claude Code, Cursor, OpenCode, Codex | ChatGPT (web + API) |
| **Scope** | Coding rules, skills, agents, hooks | General user preferences |
| **Modularity** | Per-language, per-task modules | Single "about me" + "how to respond" |
| **Skills** | Reusable at-will prompt libraries | No |
| **Commands** | Slash command workflows | No |
| **Agents** | Task-specific agent modes | GPTs (limited) |
| **Code focus** | Strongly coding-oriented | General purpose |
| **Portability** | Installs to any Claude assistant | Tied to ChatGPT account |
| **Version control** | Full Git history | No |
| **Team sharing** | GitHub repo + install script | No |

---

## What ChatGPT Custom Instructions Do

ChatGPT's custom instructions system lets you set two things:

1. **"What would you like ChatGPT to know about you?"** — background, preferences, context
2. **"How would you like ChatGPT to respond?"** — tone, format, length preferences

Example:
```
I'm a senior Python developer building web apps with FastAPI and PostgreSQL.
Always use type annotations, return `dict` for JSON responses, keep explanations brief.
```

This works well for personal preferences, but is a single blob of text with no organization.

---

## What everything-claude Does Differently

### For coding specifically

everything-claude is built for the software development workflow:

- **Rules per language**: Python rules don't pollute your React sessions
- **Skills on demand**: Invoke a security audit or SaaS builder when you need it
- **Commands**: `/build`, `/review`, `/audit`, `/ship` work like IDE commands
- **Templates**: Immediately useful starter code for common project types
- **Hooks**: Automate checks before/after file writes

### For teams

Custom instructions are personal and can't be shared. everything-claude is a Git repository — share it by linking to GitHub, and teammates install with one command.

---

## Migrating Prompts

If you have useful ChatGPT custom instructions, they translate directly to everything-claude rules:

**Before** (ChatGPT custom instructions):
```
I prefer TypeScript over JavaScript. Always use strict types, no `any`.
Use React with functional components and hooks only. Prefer Zod for validation.
```

**After** (everything-claude rules):
```bash
# Add to rules/typescript/general.md
# Add to rules/typescript/react.md
```

The Markdown content is the same. The difference is organization and portability.

---

## Can You Use Both?

Yes. Custom instructions in ChatGPT and rules in everything-claude serve different assistants. Keep ChatGPT instructions for general communication preferences, and use everything-claude for your Claude-based development workflow.
