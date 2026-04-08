<p align="center">
  <img src="assets/logo.svg" alt="everything-claude" width="800" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-1.1.0-a78bfa?style=for-the-badge&labelColor=0d1117" alt="Version">
  <img src="https://img.shields.io/github/license/Elomami1976/everything-claude?style=for-the-badge&color=60a5fa&labelColor=0d1117" alt="License">
  <img src="https://img.shields.io/github/stars/Elomami1976/everything-claude?style=for-the-badge&color=fbbf24&labelColor=0d1117" alt="Stars">
  <img src="https://img.shields.io/github/forks/Elomami1976/everything-claude?style=for-the-badge&color=34d399&labelColor=0d1117" alt="Forks">
  <img src="https://img.shields.io/github/actions/workflow/status/Elomami1976/everything-claude/ci.yml?style=for-the-badge&label=CI&labelColor=0d1117" alt="CI">
  <img src="https://img.shields.io/badge/platform-Claude%20%7C%20Cursor%20%7C%20Codex-a78bfa?style=for-the-badge&labelColor=0d1117" alt="Platform">
</p>

<h1 align="center">everything-claude</h1>

<p align="center">
  <strong>The Ultimate Agent Harness Performance Optimization Kit</strong>
  <br />
  Supercharge your AI coding agents with rules, skills, commands, and hooks.
  <br />
  Built for <strong>Claude Code</strong> � <strong>Cursor</strong> � <strong>OpenCode</strong> � <strong>Codex</strong>
</p>

<p align="center">
  <a href="#-quick-start">Quick Start</a> �
  <a href="#-whats-inside">What's Inside</a> �
  <a href="#-requirements">Requirements</a> �
  <a href="#-installation">Installation</a> �
  <a href="#-which-agent-should-i-use">Which Agent?</a> �
  <a href="#-faq">FAQ</a>
</p>

<br />

## Why everything-claude?

Most AI coding agents are generic. **everything-claude** gives your AI the context, standards, and capabilities to produce production-ready code � every time.

| Problem | Solution |
|---|---|
| AI ignores your coding standards | **Rules** � enforce them every session |
| Repetitive project setup | **Skills** � reusable, domain-specific capabilities |
| Manual workflows waste time | **Commands** � `/build`, `/review`, `/ship`, `/launch` |
| Generic AI for every task | **Agents** � specialized personas per project type |
| No quality gates | **Hooks** � automated checks at key moments |

<br />

## ?? Quick Start

**1. Install**

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.sh | bash
```

```powershell
# Windows (PowerShell)
irm https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.ps1 | iex
```

**2. Open your AI assistant** (Claude Code, Cursor, Windsurf...)

**3. Start building**

```
/build A Chrome extension that blocks social media during work hours
```

Your AI now has the rules, skills, and context to ship production code.

<details>
<summary>More commands to try</summary>
<br />

```
/review src/main.ts           # Review code by severity
/audit                        # Scan for security issues
/plan Add Stripe billing      # Get an implementation plan
/ship                         # Run pre-launch checklist
/launch                       # Generate Product Hunt kit
```

</details>

<br />

## ?? What's Inside

**60+ files** across 8 categories:

```
everything-claude/
+-- rules/        (13 files)  Coding standards by language
+-- skills/        (9 files)  Domain-specific capabilities
+-- commands/      (6 files)  Slash command definitions
+-- agents/        (3 files)  Specialized agent personas
+-- hooks/         (1 file)   Lifecycle automation
+-- docs/          (4 files)  Extended documentation
+-- templates/    (14 files)  Ready-to-copy project starters
+-- comparisons/   (3 files)  How this compares to other tools
```

### Rules

| Category | Files | Covers |
|---|---|---|
| `common/` | 4 | Security, git workflow, documentation, core patterns |
| `javascript/` | 3 | Modern JS, Manifest V3 extensions, SaaS patterns |
| `typescript/` | 2 | Strict types, React hooks, component patterns |
| `python/` | 3 | Type hints, FastAPI, CLI scripts |

### Skills

| Skill | What it does |
|---|---|
| `web-tool-builder` | Privacy-first single-HTML tools � no server, no upload |
| `chrome-extension-builder` | Manifest V3 + BYOK monetization |
| `saas-builder` | Next.js + Supabase + Stripe full stack |
| `api-connector` | Third-party API integration patterns |
| `code-review` | Severity-based review: Critical / High / Medium / Low |
| `security-audit` | Secrets, XSS, SQLi, CORS, CVE scanning |
| `seo-optimizer` | Technical SEO + GEO for AI search engines |
| `product-hunt-launch` | Tagline, copy, social posts, launch schedule |
| `monetization-planner` | Pricing tiers, BYOK models, revenue strategy |

### Commands

| Command | Input | Output |
|---|---|---|
| `/build` | Product description | Tech stack + file structure + build steps |
| `/review` | File or directory | Issues by severity with code fixes |
| `/audit` | Current project | Security report + remediation steps |
| `/plan` | Feature request | Phased plan + risks + acceptance criteria |
| `/ship` | Current project | Pass/fail checklist across 6 categories |
| `/launch` | Current project | Full Product Hunt kit + social posts |

### Agents

| Agent | Specialization |
|---|---|
| `chrome-ext-agent` | Chrome extensions with BYOK monetization |
| `saas-agent` | Full-stack SaaS with auth + payments |
| `web-tool-agent` | Privacy-first single-file browser tools |

### Hooks

| Hook | Trigger | Action |
|---|---|---|
| `PreToolUse` | Before file write | Block hardcoded secrets |
| `PostToolUse` | After file write | Auto-lint + format |
| `SessionStart` | Session begins | Detect project type, load context |
| `Stop` | Session ends | Generate summary, remind to commit |

### Templates

| Template | Description | Time to First Run |
|---|---|---|
| `chrome-extension/` | Manifest V3 popup + service worker | 5 minutes |
| `web-tool/` | Privacy-first single-file tool | 2 minutes |
| `saas/` | Next.js + Supabase + Stripe | 30 minutes |

See [templates/README.md](templates/README.md) for usage.

### Comparisons

| File | Topic |
|---|---|
| [vs-cursor-native-rules.md](comparisons/vs-cursor-native-rules.md) | everything-claude vs Cursor `.cursorrules` |
| [vs-github-copilot-instructions.md](comparisons/vs-github-copilot-instructions.md) | everything-claude vs Copilot instructions |
| [vs-chatgpt-prompts.md](comparisons/vs-chatgpt-prompts.md) | everything-claude vs ChatGPT custom instructions |

<br />

## ? Requirements

| Requirement | Details |
|---|---|
| **AI Tool** | Claude Code, Cursor, Windsurf, OpenCode, Codex, or any assistant that reads markdown context |
| **Git** | For installation via clone |
| **Node.js** | v18+ � optional, only needed if you want hooks to auto-run linters |
| **OS** | macOS, Linux, Windows (WSL or PowerShell) |

> No Node.js? You can still use all rules, skills, commands, and agents. Node.js is only needed for hook-triggered formatters.

<br />

## ?? Installation

### Option 1 � One-line script (recommended)

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.sh | bash
```

```powershell
# Windows
irm https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.ps1 | iex
```

Installs to `~/.claude/` and sets up rules, skills, commands, and agents globally.

### Option 2 � Clone and run

```bash
git clone https://github.com/Elomami1976/everything-claude.git
cd everything-claude
./install.sh        # macOS/Linux
.\install.ps1       # Windows
```

### Option 3 � Per-project

```bash
cd my-project
git clone https://github.com/Elomami1976/everything-claude.git .claude
```

Then reference files in your prompts:

```
Follow the rules in .claude/rules/typescript/react.md
Use the skill at .claude/skills/saas-builder.md
```

### Option 4 � Manual copy

```bash
cp -r rules/    ~/.claude/rules/
cp -r skills/   ~/.claude/skills/
cp -r commands/ ~/.claude/commands/
cp -r agents/   ~/.claude/agents/
```

### Verify

```bash
cat ~/.claude/rules/common/core.md
```

<br />

## ?? Which Agent Should I Use?

```
What are you building?
�
+-- A website or web app?
�   +-- Needs server / database / auth? ------? saas-agent
�   +-- Runs 100% client-side / offline? -----? web-tool-agent
�
+-- A browser extension? ----------------------? chrome-ext-agent
```

### Comparison table

| | `web-tool-agent` | `chrome-ext-agent` | `saas-agent` |
|---|---|---|---|
| **Server** | No | No | Yes |
| **Database** | localStorage | chrome.storage | Supabase |
| **Auth** | None | Optional | Supabase Auth |
| **Payments** | None | Stripe one-time | Stripe subscriptions |
| **Distribute via** | URL / download | Chrome Web Store | Domain + hosting |
| **Time to ship** | Hours | Days | Weeks |

### Examples

| What you are building | Use |
|---|---|
| PDF merger in the browser | `web-tool-agent` |
| Extension that summarizes articles with AI | `chrome-ext-agent` |
| Habit tracking app with user accounts | `saas-agent` |
| Color palette generator | `web-tool-agent` |
| Tab manager with cross-device sync | `chrome-ext-agent` |
| Invoice generator SaaS | `saas-agent` |

<br />

## ?? Documentation

| Doc | Description |
|---|---|
| [Installation Guide](docs/INSTALL.md) | All installation methods + troubleshooting |
| [Skills Reference](docs/SKILLS.md) | Complete skill docs + examples |
| [Commands Reference](docs/COMMANDS.md) | Command usage, output formats, examples |
| [Hooks Reference](docs/HOOKS.md) | Hook config + writing custom hooks |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to contribute rules, skills, and templates |
| [CHANGELOG.md](CHANGELOG.md) | Release history |
| [ROADMAP.md](ROADMAP.md) | Planned features and direction |

<br />

## ? FAQ

<details>
<summary>Does this work with Cursor?</summary>
<br />

Yes. Copy `rules/` to `~/.cursor/rules/`, or generate a `.cursorrules` file:

```bash
cat rules/**/*.md > .cursorrules
```

</details>

<details>
<summary>Does this work with GitHub Copilot / VS Code?</summary>
<br />

Yes. Copy `CLAUDE.md` to `.github/copilot-instructions.md` in your project.

</details>

<details>
<summary>What is the difference between a skill and an agent?</summary>
<br />

**Skills** are capabilities you call on demand:

```
Use the code-review skill to review auth.ts
```

**Agents** are full personas you activate for a whole session:

```
@saas-agent build a user dashboard
```

Skills are tools. Agents are specialists that carry multiple skills and behaviors.

</details>

<details>
<summary>Can I use only some parts?</summary>
<br />

Yes � everything is modular. Use only the rules you want, skip agents, ignore hooks. Each file works independently.

</details>

<details>
<summary>Do hooks run automatically?</summary>
<br />

Yes, in Claude Code. The `hooks/hooks.json` file is read by Claude Code's hook system. For other AI tools, hooks are advisory and can be manually invoked.

</details>

<details>
<summary>How do I add my own rules?</summary>
<br />

Create a `.md` file in the appropriate `rules/` folder and reference it in your prompts or `CLAUDE.md`.

</details>

<details>
<summary>Will this slow down my AI assistant?</summary>
<br />

No. Rules and skills are only loaded when referenced. Hooks run in the background and do not affect response time.

</details>

<details>
<summary>Is this free?</summary>
<br />

Yes, 100% free and MIT licensed. Use it commercially, fork it, modify it.

</details>

<br />

## ?? Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide.

Good first contributions:

- New language rules (Go, Rust, Swift, Kotlin)
- Framework skills (Vue, Django, Rails)
- New templates (React Native, Django, FastAPI)

```bash
git checkout -b feat/go-rules
git commit -m "feat: add Go language rules"
git push origin feat/go-rules
```

<br />

## ?? License

MIT � see [LICENSE](LICENSE) for details.

<br />

---

<p align="center">
  Built for indie developers who ship fast.
  <br /><br />
  <a href="https://github.com/Elomami1976/everything-claude/issues">Report Bug</a> �
  <a href="https://github.com/Elomami1976/everything-claude/issues">Request Feature</a> �
  <a href="https://github.com/Elomami1976/everything-claude/discussions">Discussions</a>
  <br /><br />
  <sub>If this helps you ship faster, give it a ?</sub>
</p>
