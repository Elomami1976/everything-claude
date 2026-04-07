<![CDATA[<div align="center">

```
███████╗██╗   ██╗███████╗██████╗ ██╗   ██╗████████╗██╗  ██╗██╗███╗   ██╗ ██████╗ 
██╔════╝██║   ██║██╔════╝██╔══██╗╚██╗ ██╔╝╚══██╔══╝██║  ██║██║████╗  ██║██╔════╝ 
█████╗  ██║   ██║█████╗  ██████╔╝ ╚████╔╝    ██║   ███████║██║██╔██╗ ██║██║  ███╗
██╔══╝  ╚██╗ ██╔╝██╔══╝  ██╔══██╗  ╚██╔╝     ██║   ██╔══██║██║██║╚██╗██║██║   ██║
███████╗ ╚████╔╝ ███████╗██║  ██║   ██║      ██║   ██║  ██║██║██║ ╚████║╚██████╔╝
╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
                           ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗
                          ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝
                          ██║     ██║     ███████║██║   ██║██║  ██║█████╗  
                          ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝  
                          ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗
                           ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝
```

# everything-claude

**The agent harness performance optimization system for Web Tools, Chrome Extensions, and SaaS — built for indie developers**

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![Claude](https://img.shields.io/badge/Claude-Compatible-blueviolet)](https://claude.ai)
[![Cursor](https://img.shields.io/badge/Cursor-Compatible-blue)](https://cursor.sh)
[![OpenCode](https://img.shields.io/badge/OpenCode-Compatible-orange)](https://github.com/opencode)
[![Codex](https://img.shields.io/badge/Codex-Compatible-yellow)](https://openai.com/codex)

</div>

---

## 🚀 What is this?

**everything-claude** is a comprehensive performance optimization kit that supercharges your AI coding agents. It provides:

- **📜 Rules** — Language-specific coding standards that keep your AI on track
- **🛠️ Skills** — Reusable capabilities for building web tools, extensions, and SaaS products
- **⚡ Commands** — Slash commands for common workflows (`/build`, `/review`, `/ship`, `/launch`)
- **🤖 Agents** — Pre-configured agent personas for specialized tasks
- **🪝 Hooks** — Automated behaviors triggered at key moments in your workflow

Whether you're building a Chrome extension, launching a SaaS, or shipping a web tool, this kit gives your AI assistant the context and capabilities to help you ship faster.

---

## 📦 Installation

### Method 1: Plugin Install (Recommended)

```bash
# Clone the repo
git clone https://github.com/Elomami1976/everything-claude.git
cd everything-claude

# Run the installer
# macOS/Linux
./install.sh

# Windows
.\install.ps1
```

### Method 2: Manual Install

```bash
# Copy rules to your home directory
cp -r rules/ ~/.claude/rules/

# Copy skills
cp -r skills/ ~/.claude/skills/

# Copy commands
cp -r commands/ ~/.claude/commands/

# Copy agents
cp -r agents/ ~/.claude/agents/
```

### Method 3: Per-Project

Just clone this repo into your project and reference files directly in your prompts.

---

## ⚡ Quick Start

After installation, try these commands in your AI assistant:

```
# Build a new project
/build A Chrome extension that highlights all prices on Amazon and shows a price history chart

# Review your code
/review src/background.js

# Security audit
/audit

# Plan a feature
/plan Add Stripe subscription with monthly and yearly plans

# Pre-launch checklist
/ship

# Generate Product Hunt launch kit
/launch
```

---

## 🛠️ Skills

| Skill | Description | Use Case |
|-------|-------------|----------|
| [web-tool-builder](skills/web-tool-builder.md) | Build privacy-first browser tools | PDF tools, converters, text utilities |
| [chrome-extension-builder](skills/chrome-extension-builder.md) | Create Manifest V3 Chrome extensions | Productivity tools, AI assistants, scrapers |
| [saas-builder](skills/saas-builder.md) | Full SaaS product scaffolding | Subscription apps, web services |
| [api-connector](skills/api-connector.md) | Integrate third-party APIs | Payment, auth, analytics |
| [code-review](skills/code-review.md) | Comprehensive code reviews | PR reviews, refactoring |
| [security-audit](skills/security-audit.md) | Security vulnerability scanning | Launch prep, compliance |
| [seo-optimizer](skills/seo-optimizer.md) | SEO and GEO optimization | Landing pages, web apps |
| [product-hunt-launch](skills/product-hunt-launch.md) | Product Hunt launch preparation | Marketing, launches |
| [monetization-planner](skills/monetization-planner.md) | Revenue strategy planning | Pricing, tiers, conversion |

---

## ⚡ Commands

| Command | Input | Output |
|---------|-------|--------|
| `/build <description>` | Natural language product description | Full build prompt with tech stack, file structure, steps |
| `/review <file>` | File path or PR link | Issues by severity, suggestions, verdict |
| `/audit` | (current project) | Security report: secrets, XSS, CORS, deps |
| `/plan <feature>` | Feature request | Implementation plan, complexity, risks |
| `/ship` | (current project) | Pre-launch checklist with pass/fail |
| `/launch` | (current project) | Product Hunt kit: tagline, description, social posts |

---

## 🤖 Agents

| Agent | Purpose |
|-------|---------|
| [chrome-ext-agent](agents/chrome-ext-agent.md) | End-to-end Chrome extension builder |
| [saas-agent](agents/saas-agent.md) | Full SaaS product scaffolder |
| [web-tool-agent](agents/web-tool-agent.md) | Single-file web tool creator |

---

## 📁 Project Structure

```
everything-claude/
├── rules/                 # Coding standards by language
│   ├── common/           # Universal rules
│   ├── javascript/       # JS-specific rules
│   ├── python/           # Python-specific rules
│   └── typescript/       # TS-specific rules
├── skills/               # Reusable capabilities
├── commands/            # Slash command definitions
├── agents/              # Agent configurations
├── hooks/               # Automated behaviors
└── docs/                # Documentation
```

---

## 🔧 Configuration

### Customizing Rules

Edit any rule file in `rules/` to match your preferences:

```markdown
<!-- rules/javascript/general.md -->
# JavaScript Rules

- Always use `const` over `let` unless reassignment is needed
- Prefer async/await over raw promises
- Use early returns to reduce nesting
```

### Creating Custom Skills

Add new skills to `skills/`:

```markdown
<!-- skills/my-custom-skill.md -->
# My Custom Skill

## When to Use
Use this skill when building [specific use case].

## How It Works
1. Step one
2. Step two
3. Step three

## Example Output
[Show what the output looks like]
```

---

## 🤝 Contributing

Contributions are welcome! Here's how:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-skill`
3. Commit your changes: `git commit -m 'feat: add amazing skill'`
4. Push to the branch: `git push origin feature/amazing-skill`
5. Open a Pull Request

Please follow [Conventional Commits](https://www.conventionalcommits.org/) for commit messages.

### Ideas for Contributions

- New language rules (Go, Rust, etc.)
- Additional skills for specific frameworks
- Improved commands with better outputs
- Documentation improvements
- Bug fixes

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## ⭐ Star History

If this project helps you ship faster, consider giving it a star!

---

<div align="center">

**Built with ❤️ for indie developers by the community**

[Report Bug](https://github.com/Elomami1976/everything-claude/issues) · [Request Feature](https://github.com/Elomami1976/everything-claude/issues) · [Discussions](https://github.com/Elomami1976/everything-claude/discussions)

</div>
]]>