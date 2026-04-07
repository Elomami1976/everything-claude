<![CDATA[# Installation Guide

Complete installation instructions for the everything-claude toolkit.

## Quick Install

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.ps1 | iex
```

### npm (All Platforms)

```bash
npm install -g everything-claude
```

---

## Manual Installation

### 1. Clone Repository

```bash
git clone https://github.com/Elomami1976/everything-claude.git
cd everything-claude
```

### 2. Choose Your Setup

<details>
<summary><strong>Claude Code Users</strong></summary>

Copy to your Claude Code instructions directory:

```bash
# macOS/Linux
cp -r . ~/.claude/instructions/everything-claude/

# Windows
xcopy /E /I . %USERPROFILE%\.claude\instructions\everything-claude\
```

Then add to your `~/.claude/INSTRUCTIONS.md`:

```markdown
@include instructions/everything-claude/CLAUDE.md
```

</details>

<details>
<summary><strong>Cursor Users</strong></summary>

Copy to your Cursor rules directory:

```bash
# macOS/Linux
cp -r rules/* ~/.cursor/rules/

# Windows
xcopy /E /I rules %USERPROFILE%\.cursor\rules\
```

Or create `.cursorrules` in your project:

```bash
cat rules/**/*.md > .cursorrules
```

</details>

<details>
<summary><strong>VS Code + Copilot Users</strong></summary>

Copy relevant files to your workspace:

```bash
mkdir -p .github/copilot
cp CLAUDE.md .github/copilot/instructions.md
```

Or use workspace settings:

```json
// .vscode/settings.json
{
  "github.copilot.chat.instructions": "Use the everything-claude toolkit for guidance."
}
```

</details>

<details>
<summary><strong>Codex Users</strong></summary>

Install globally:

```bash
npm install -g everything-claude
```

Then reference in prompts:

```
Using the everything-claude toolkit, build...
```

</details>

---

## Directory Structure

After installation, you'll have:

```
everything-claude/
├── CLAUDE.md           # Main manifest
├── README.md           # Documentation
├── rules/              # Coding standards
│   ├── common/         # Universal rules
│   ├── javascript/     # JS-specific
│   ├── python/         # Python-specific
│   └── typescript/     # TS-specific
├── skills/             # Capability modules
├── commands/           # Action triggers
├── agents/             # Specialized personas
├── hooks/              # Lifecycle automation
└── docs/               # Extended documentation
```

---

## Configuration

### Per-Project Setup

Create a `CLAUDE.md` in your project root to customize behavior:

```markdown
# Project: My App

## Context
- This is a Next.js SaaS application
- Uses Supabase for database and auth
- Stripe for payments

## Rules
@include ../everything-claude/rules/typescript/react.md
@include ../everything-claude/rules/javascript/saas.md

## Priorities
1. Security first
2. Type safety
3. Clean code

## Restrictions
- Never suggest Firebase (we use Supabase)
- Use server components by default
```

### Global Configuration

Create `~/.claude/config.json`:

```json
{
  "everything-claude": {
    "default_language": "typescript",
    "enable_hooks": true,
    "verbose_mode": false,
    "backup_edits": true
  }
}
```

---

## Verification

Verify installation:

```bash
# Check if CLAUDE.md is accessible
cat ~/.claude/instructions/everything-claude/CLAUDE.md

# Or in project
cat CLAUDE.md
```

Test with a command:

```
/ship
```

If configured correctly, you should see the ship checklist output.

---

## Updating

### npm

```bash
npm update -g everything-claude
```

### Git

```bash
cd ~/.claude/instructions/everything-claude
git pull origin main
```

### Manual

Re-run the installation script:

```bash
curl -fsSL https://raw.githubusercontent.com/Elomami1976/everything-claude/main/install.sh | bash
```

---

## Troubleshooting

### Commands not recognized

**Issue**: `/build`, `/ship`, etc. don't work.

**Solution**: Ensure CLAUDE.md is loaded. Check your instructions path:

```bash
# Claude Code
cat ~/.claude/INSTRUCTIONS.md | grep everything-claude

# Cursor
ls ~/.cursor/rules/
```

### Rules not applied

**Issue**: AI isn't following coding rules.

**Solution**: Explicitly reference rules in your prompt:

```
Using the rules from rules/typescript/react.md, review this component...
```

### Hooks not running

**Issue**: Pre/post hooks don't execute.

**Solution**: 
1. Check `hooks/hooks.json` syntax
2. Verify `config.enabled` is `true`
3. Check if the relevant tool is in the `tools` array

### Slow performance

**Issue**: AI responses are slow.

**Solution**: 
1. Use smaller context by loading only needed rules
2. Disable verbose hooks
3. Split large files before review

---

## Uninstalling

### npm

```bash
npm uninstall -g everything-claude
```

### Manual

```bash
rm -rf ~/.claude/instructions/everything-claude
# Remove the @include line from ~/.claude/INSTRUCTIONS.md
```

---

## Platform Notes

### Windows

- Use PowerShell 5.1+ or PowerShell Core
- Some hooks may need Git Bash for Unix commands
- Paths use backslash but forward slash often works

### macOS

- Works out of the box
- Homebrew npm recommended over system npm
- `~/.claude` is in your home directory

### Linux

- Works on all major distributions
- May need `sudo` for global npm install
- Check npm prefix if global install fails

---

## Support

- **Issues**: [GitHub Issues](https://github.com/Elomami1976/everything-claude/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Elomami1976/everything-claude/discussions)
- **Updates**: Watch the repository for releases

---

## What's Next

After installation:

1. **Try a command**: `/ship` to see the checklist
2. **Build something**: `/build a Chrome extension that...`
3. **Customize**: Create a project `CLAUDE.md` with your preferences
4. **Explore skills**: Read `docs/SKILLS.md` for capabilities
5. **Configure hooks**: Customize `hooks/hooks.json` for your workflow
]]>