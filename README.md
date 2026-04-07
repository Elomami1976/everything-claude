<![CDATA[<p align="center">
  <img src="https://img.shields.io/badge/v1.0.0-release-blue?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/github/license/Elomami1976/everything-claude?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/github/stars/Elomami1976/everything-claude?style=for-the-badge" alt="Stars">
</p>

<h1 align="center">🧠 everything-claude</h1>

<p align="center">
  <strong>The Ultimate Agent Harness Performance Optimization Kit</strong><br>
  Supercharge your AI coding agents with rules, skills, commands, and hooks.<br>
  Built for <strong>Claude Code</strong> · <strong>Cursor</strong> · <strong>OpenCode</strong> · <strong>Codex</strong>
</p>

<p align="center">
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-whats-inside">What's Inside</a> •
  <a href="#-requirements">Requirements</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-which-agent-should-i-use">Which Agent?</a> •
  <a href="#-faq">FAQ</a>
</p>

---

## ✨ Why everything-claude?

Most AI coding agents are generic. They lack context about **your** stack, **your** patterns, and **your** workflows.

**everything-claude** fixes this by giving your AI:

| Problem | Solution |
|---------|----------|
| AI forgets coding standards | **Rules** enforce consistency across sessions |
| Repetitive setup for new projects | **Skills** provide ready-to-use capabilities |
| Manual workflows slow you down | **Commands** automate common tasks |
| Context switching between domains | **Agents** specialize in specific project types |
| Missing quality checks | **Hooks** run automatically at key moments |

<br>

## 🚀 Quick Start

**Step 1 — Install**
```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.sh | bash

# Windows (PowerShell)
irm https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.ps1 | iex
```

**Step 2 — Open your AI assistant** (Claude Code, Cursor, etc.)

**Step 3 — Start shipping**
```
/build A Chrome extension that blocks social media during work hours
```

That's it. Your AI now has the context, rules, and skills to build production-ready code.

<details>
<summary>More example commands</summary>

```bash
# Review any file for bugs and issues
/review src/main.ts

# Security audit your whole project
/audit

# Plan a new feature step-by-step
/plan Add Stripe subscription billing

# Run pre-launch checklist
/ship

# Generate a full Product Hunt launch kit
/launch
```

</details>

<br>

## 📦 What's Inside

**42 files** across 6 categories:

```
everything-claude/
├── 📜 rules/              (13 files) — Coding standards by language
│   ├── common/            core, security, git, documentation
│   ├── javascript/        general, chrome-extension, saas
│   ├── typescript/        general, react
│   └── python/            general, fastapi, scripts
│
├── 🛠️ skills/             (9 files) — Domain-specific capabilities
│   web-tool-builder, chrome-extension-builder, saas-builder,
│   api-connector, code-review, security-audit,
│   seo-optimizer, product-hunt-launch, monetization-planner
│
├── ⚡ commands/           (6 files) — Slash command definitions
│   /build, /review, /audit, /plan, /ship, /launch
│
├── 🤖 agents/             (3 files) — Specialized agent personas
│   chrome-ext-agent, saas-agent, web-tool-agent
│
├── 🪝 hooks/              (1 file)  — Lifecycle automation
│   hooks.json
│
└── 📖 docs/               (4 files) — Extended documentation
    INSTALL.md, SKILLS.md, COMMANDS.md, HOOKS.md
```

### 📜 Rules

Language-specific coding standards enforced in every session:

| Category | Files | Covers |
|----------|-------|--------|
| Common | 4 | Security, git workflow, documentation, core patterns |
| JavaScript | 3 | Modern JS, Manifest V3 extensions, SaaS patterns |
| TypeScript | 2 | Strict types, React hooks, component patterns |
| Python | 3 | Type hints, FastAPI, CLI scripts |

### 🛠️ Skills

| Skill | What It Does |
|-------|--------------|
| **web-tool-builder** | Privacy-first single-HTML tools — no server, no upload |
| **chrome-extension-builder** | Manifest V3 + BYOK monetization |
| **saas-builder** | Next.js + Supabase + Stripe full stack |
| **api-connector** | Third-party API integration patterns |
| **code-review** | Severity-based review (Critical / High / Medium / Low) |
| **security-audit** | Secrets, XSS, SQLi, CORS, CVE scan |
| **seo-optimizer** | Technical SEO + GEO for AI search engines |
| **product-hunt-launch** | Tagline, copy, social posts, launch schedule |
| **monetization-planner** | Pricing tiers, BYOK models, revenue strategy |

### ⚡ Commands

| Command | Input | Output |
|---------|-------|--------|
| `/build <idea>` | Product description | Tech stack + file structure + build steps |
| `/review <file>` | File or directory | Issues by severity + code fixes |
| `/audit` | Current project | Security report + remediation steps |
| `/plan <feature>` | Feature request | Phased plan + risks + acceptance criteria |
| `/ship` | Current project | Pass/fail checklist across 6 categories |
| `/launch` | Current project | Full Product Hunt kit + social posts |

### 🤖 Agents

| Agent | When to Use |
|-------|-------------|
| **chrome-ext-agent** | Building any Chrome/browser extension |
| **saas-agent** | Building subscription web apps |
| **web-tool-agent** | Building offline/privacy-first browser tools |

### 🪝 Hooks

| Hook | Trigger | Action |
|------|---------|--------|
| `PreToolUse` | Before file write | Block hardcoded secrets |
| `PostToolUse` | After file write | Auto-lint + format |
| `SessionStart` | Session begins | Detect project type, load context |
| `Stop` | Session ends | Generate summary, remind to commit |

<br>

## ✅ Requirements

| Requirement | Details |
|-------------|---------|
| **AI Tool** | Claude Code, Cursor, Windsurf, OpenCode, Codex, or any assistant that reads markdown context |
| **Git** | For installation via clone |
| **Node.js** | v18+ (optional — only for hooks that run `npm` commands) |
| **OS** | macOS, Linux, Windows (WSL or PowerShell) |

> **No Node.js?** You can still use all rules, skills, commands, and agents. Node.js is only needed if you want hooks to run linters/formatters automatically.

<br>

## 📥 Installation

### Method 1 — One-Line Script (Recommended)

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.sh | bash

# Windows
irm https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.ps1 | iex
```

Installs to `~/.claude/` and sets up all rules, skills, commands, and agents globally.

---

### Method 2 — Clone & Run

```bash
git clone https://github.com/Elomami1976/everything-claude.git
cd everything-claude

# macOS/Linux
./install.sh

# Windows
.\install.ps1
```

---

### Method 3 — Per-Project

Clone into your project and reference files directly in your AI prompts:

```bash
cd my-project
git clone https://github.com/Elomami1976/everything-claude.git .claude
```

Then in your prompt:
```
Follow the rules in .claude/rules/typescript/react.md
Use the skill at .claude/skills/saas-builder.md
```

---

### Method 4 — Manual Copy

```bash
cp -r rules/  ~/.claude/rules/
cp -r skills/ ~/.claude/skills/
cp -r commands/ ~/.claude/commands/
cp -r agents/ ~/.claude/agents/
```

---

### Verify Installation

```bash
cat ~/.claude/rules/common/core.md   # Should print the core rules
```

Then test in your AI assistant:
```
/ship
```

<br>

## 🤔 Which Agent Should I Use?

Not sure which agent fits your project? Use this decision tree:

```
What are you building?
│
├── 🌐 A website or web app that runs in the browser?
│   │
│   ├── Needs a server / database / auth?
│   │   └── → saas-agent  (Next.js + Supabase + Stripe)
│   │
│   └── Runs 100% client-side / offline / privacy-first?
│       └── → web-tool-agent  (single HTML file, no server)
│
└── 🧩 A browser extension?
    └── → chrome-ext-agent  (Manifest V3, BYOK, Stripe)
```

### Detailed Comparison

| Feature | web-tool-agent | chrome-ext-agent | saas-agent |
|---------|---------------|-----------------|------------|
| **Server required** | No | No | Yes |
| **Database** | localStorage | chrome.storage | Supabase Postgres |
| **Auth** | None | Optional (Supabase) | Supabase Auth |
| **Payments** | None | Stripe (one-time) | Stripe (subscriptions) |
| **Distribution** | URL / download | Chrome Web Store | Deploy + domain |
| **Best for** | Utilities, converters | Productivity tools | Full products |
| **Time to ship** | Hours | Days | Weeks |

### Example Use Cases

| Project Idea | Recommended Agent |
|--------------|------------------|
| PDF merger that runs in browser | `web-tool-agent` |
| Extension that summarizes articles with AI | `chrome-ext-agent` |
| Habit tracking app with user accounts | `saas-agent` |
| Color palette generator | `web-tool-agent` |
| Tab manager with sync | `chrome-ext-agent` |
| Invoice generator SaaS | `saas-agent` |
| JSON formatter tool | `web-tool-agent` |
| Grammar checker extension | `chrome-ext-agent` |

<br>

## 📖 Documentation

| Doc | Description |
|-----|-------------|
| [Installation Guide](docs/INSTALL.md) | All installation methods + troubleshooting |
| [Skills Reference](docs/SKILLS.md) | Complete skill documentation + examples |
| [Commands Reference](docs/COMMANDS.md) | Command usage, output formats, examples |
| [Hooks Reference](docs/HOOKS.md) | Hook configuration + custom hooks |

<br>

## ❓ FAQ

<details>
<summary><strong>Does this work with Cursor?</strong></summary>

Yes. Copy the `rules/` directory to `~/.cursor/rules/` or add a `.cursorrules` file in your project:

```bash
cat rules/**/*.md > .cursorrules
```

</details>

<details>
<summary><strong>Does this work with GitHub Copilot / VS Code?</strong></summary>

Yes. Copy `CLAUDE.md` to `.github/copilot-instructions.md` in your project, or paste relevant rules into your Copilot instructions.

</details>

<details>
<summary><strong>What's the difference between a skill and an agent?</strong></summary>

- **Skills** are capability modules you call on demand: `"Use the code-review skill to review this file"`
- **Agents** are full personas you activate for a session: `"@saas-agent build a user dashboard"`

Skills are tools. Agents are specialized workers that carry multiple skills and behaviors.

</details>

<details>
<summary><strong>Can I use only some parts?</strong></summary>

Absolutely. Everything is modular. Use only the rules you want, skip agents, ignore hooks. Each file works independently.

</details>

<details>
<summary><strong>Do the hooks actually run automatically?</strong></summary>

Yes, for Claude Code. The `hooks/hooks.json` file is read by Claude Code's hook system to trigger actions at session lifecycle events. For other AI tools, hooks are advisory — you can manually invoke them.

</details>

<details>
<summary><strong>How do I add my own rules?</strong></summary>

Create a new `.md` file in the appropriate `rules/` subdirectory:

```markdown
# My Custom Rules

- Always use X pattern instead of Y
- When working with Z, prefer...
```

Then reference it in your CLAUDE.md or paste into your AI's context.

</details>

<details>
<summary><strong>Will this slow down my AI assistant?</strong></summary>

No. Rules and skills are only loaded when referenced — they don't auto-inject into every prompt. Hooks run in the background and don't affect response time.

</details>

<details>
<summary><strong>Is this free?</strong></summary>

Yes, 100% free and MIT licensed. Use it commercially, fork it, modify it.

</details>

<br>

## 🤝 Contributing

We welcome contributions:

```bash
git checkout -b feature/go-rules     # Add Go language rules
git checkout -b feature/vue-skill    # Add Vue.js skill
git checkout -b fix/hook-pattern     # Fix a hook
```

**Good first contributions:**
- New language rules (Go, Rust, Swift, Kotlin)
- Framework-specific skills (Vue, Django, Rails)
- Improved command output formats
- More FAQ entries based on real questions

Please follow [Conventional Commits](https://www.conventionalcommits.org/) for commit messages.

<br>

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

<br>

---

<p align="center">
  <strong>Built for indie developers who ship fast.</strong><br><br>
  <a href="https://github.com/Elomami1976/everything-claude/issues">Report Bug</a> •
  <a href="https://github.com/Elomami1976/everything-claude/issues">Request Feature</a> •
  <a href="https://github.com/Elomami1976/everything-claude/discussions">Discussions</a>
</p>

<p align="center">
  <sub>If this helps you ship faster, consider giving it a ⭐</sub>
</p>
]]>