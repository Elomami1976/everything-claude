# everything-claude vs Cursor Native Rules

A comparison for developers choosing between Cursor's built-in rules system and everything-claude.

## Overview

| Feature | everything-claude | Cursor `.cursorrules` |
|---|---|---|
| **Portability** | Claude Code, Cursor, OpenCode, Codex | Cursor only |
| **Rule organization** | Modular files per language/framework | Single file or per-directory |
| **Skills system** | Yes — reusable prompt libraries | No |
| **Commands** | Slash commands `/build`, `/audit` | No built-in slash commands |
| **Agents** | Pre-configured specialized agents | No |
| **Hooks** | Lifecycle automation | No |
| **Templates** | Ready-to-copy project starters | No |
| **Sharing** | Install script, GitHub | Copy `.cursorrules` file |
| **Context limit** | Modular — load only what's needed | Single file grows unbounded |

---

## Cursor Rules: What They Are

Cursor supports two rule formats:

1. `.cursorrules` in project root (legacy)
2. `.cursor/rules/*.mdc` files (new format, supports glob matching)

The new format lets you write rules that apply only to matching files:

```markdown
---
globs: ["**/*.py"]
---
Use snake_case for all Python identifiers.
```

---

## Feature Comparison in Depth

### Modularity

**Cursor**: Each `.mdc` file can be scoped to file patterns. Multiple files are supported.

**everything-claude**: Rules are also modular, but organized by language and type. The install script places them in `~/.claude/rules/` for global use or project-specific use.

Both are comparable here.

---

### Skills

**Cursor**: No native skill/library system. You can write detailed rules, but they're always active — you can't invoke a skill on demand.

**everything-claude**: Skills are invoked when needed:
```
Using the security-audit skill, check my auth flow.
```
Skills don't consume context unless referenced.

---

### Context efficiency

**Cursor**: Long `.cursorrules` files consume tokens on every request.

**everything-claude**: Rules and skills are modular — only load what's relevant to the current file or task.

---

### Hooks

**Cursor**: No hook system.

**everything-claude**: Hooks run before/after file writes, on session start, and on session end. Useful for logging, validation, or consistency checks.

---

## When to use Cursor rules

- You only use Cursor
- You want rules that activate automatically based on file type
- Your team shares a `.cursor/rules/` directory in the repo
- Lightweight setup — no install script needed

## When to use everything-claude

- You use Claude Code, Claude.ai, or other Claude-based tools alongside Cursor
- You want deep skills for building products (SaaS, Chrome extensions)
- You want lifecycle hooks for automation
- You want everything versioned in one portable kit

---

## Migration Guide: Cursor rules → everything-claude

If you have existing `.cursorrules` content, you can move it directly:

```bash
# For global Python rules
cp .cursorrules ~/.claude/rules/python/general.md

# For project-specific rules
cp .cursorrules .claude/rules/project.md
```

The format is the same — plain Markdown. everything-claude just adds organization, skills, and hooks on top.
