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
  <a href="#-features">Features</a> •
  <a href="#-skills">Skills</a> •
  <a href="#-commands">Commands</a> •
  <a href="docs/INSTALL.md">Installation</a>
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

### One-Line Install

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.sh | bash

# Windows (PowerShell)
irm https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.ps1 | iex
```

### Or Clone & Install

```bash
git clone https://github.com/Elomami1976/everything-claude.git
cd everything-claude
./install.sh    # or .\install.ps1 on Windows
```

### Try It Out

```bash
/build A Chrome extension that blocks social media during work hours
/review src/main.ts
/ship
```

<br>

## 🎯 Features

### 📜 Rules — Coding Standards That Stick

Language-specific rules that keep your AI consistent:

```
rules/
├── common/           # Security, git, documentation
├── javascript/       # Modern JS, Chrome extensions, SaaS
├── typescript/       # Type safety, React patterns
└── python/           # FastAPI, scripts, type hints
```

### 🛠️ Skills — Capabilities On Demand

9 specialized skills for different domains:

| Skill | What It Does |
|-------|--------------|
| **web-tool-builder** | Privacy-first single-HTML tools |
| **chrome-extension-builder** | Manifest V3 + BYOK monetization |
| **saas-builder** | Next.js + Supabase + Stripe stack |
| **api-connector** | Third-party API integration |
| **code-review** | Severity-based code review |
| **security-audit** | Vulnerability scanning |
| **seo-optimizer** | SEO + GEO for AI search |
| **product-hunt-launch** | Complete launch kit |
| **monetization-planner** | Pricing strategy |

### ⚡ Commands — Slash Your Workflow

| Command | What You Get |
|---------|--------------|
| `/build <idea>` | Full project scaffold with tech stack |
| `/review <file>` | Issues by severity + fixes |
| `/audit` | Security vulnerabilities + fixes |
| `/plan <feature>` | Implementation plan + risks |
| `/ship` | Pre-launch checklist |
| `/launch` | Product Hunt launch kit |

### 🤖 Agents — Specialized Personas

| Agent | Specialization |
|-------|----------------|
| **chrome-ext-agent** | Chrome extensions with BYOK monetization |
| **saas-agent** | Full-stack SaaS with auth + payments |
| **web-tool-agent** | Privacy-first browser tools |

### 🪝 Hooks — Automated Quality

```json
{
  "PreToolUse": "Block hardcoded secrets",
  "PostToolUse": "Auto-format code",
  "SessionStart": "Load project context",
  "Stop": "Generate session summary"
}
```

<br>

## 📁 Project Structure

```
everything-claude/
├── rules/                    # Coding standards
│   ├── common/              # Universal: security, git, docs
│   ├── javascript/          # JS: general, extensions, SaaS
│   ├── typescript/          # TS: general, React
│   └── python/              # Python: general, FastAPI, scripts
├── skills/                   # 9 capability modules
├── commands/                 # 6 slash commands
├── agents/                   # 3 specialized agents
├── hooks/                    # Lifecycle automation
└── docs/                     # Extended documentation
```

<br>

## 📖 Documentation

| Doc | Description |
|-----|-------------|
| [Installation Guide](docs/INSTALL.md) | All installation methods |
| [Skills Reference](docs/SKILLS.md) | Complete skill documentation |
| [Commands Reference](docs/COMMANDS.md) | Command usage and examples |
| [Hooks Reference](docs/HOOKS.md) | Hook configuration |

<br>

## 🤝 Contributing

We welcome contributions! See our [contribution guide](CONTRIBUTING.md) for details.

```bash
# Fork, clone, branch
git checkout -b feature/amazing-skill

# Make changes, commit with conventional commits
git commit -m "feat: add amazing skill"

# Push and open PR
git push origin feature/amazing-skill
```

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