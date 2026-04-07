<![CDATA[# Hooks Reference

Complete documentation for lifecycle hooks in the everything-claude toolkit.

## Overview

Hooks are automated actions triggered at specific points in the AI session lifecycle. They enable validation, automation, and quality assurance without manual intervention.

**Configuration File**: `hooks/hooks.json`

## Hook Types

| Hook | Trigger | Purpose |
|------|---------|---------|
| `PreToolUse` | Before tool execution | Validation and blocking |
| `PostToolUse` | After tool execution | Formatting and cleanup |
| `SessionStart` | Session begins | Context loading |
| `Stop` | Session ends | Summarization |
| `BeforeCommit` | Before git commit | Quality gates |
| `OnError` | On error occurrence | Recovery and logging |

---

## PreToolUse Hooks

Triggered before any tool is executed. Can block execution if validation fails.

### security-check

Scans tool arguments for potential security issues.

```json
{
  "name": "security-check",
  "tools": ["write_file", "bash", "run_in_terminal"],
  "action": "validate",
  "rules": [
    {
      "type": "regex-deny",
      "pattern": "(api[_-]?key|password|secret)\\s*[:=]\\s*['\"][^'\"]+['\"]",
      "message": "Detected potential hardcoded secret"
    }
  ]
}
```

**Blocked Patterns**:
- Hardcoded API keys
- Stripe live secret keys (`sk_live_`)
- AWS access keys (`AKIA...`)
- Passwords in code

**Action on Match**: Block tool execution, show warning message.

### file-backup

Creates backup before modifying files.

```json
{
  "name": "file-backup",
  "tools": ["write_file", "replace_string_in_file"],
  "action": "backup",
  "config": {
    "backup_dir": ".claude-backups",
    "max_backups": 5,
    "skip_patterns": ["node_modules/**", ".git/**"]
  }
}
```

**Behavior**:
- Creates timestamped backup before edit
- Keeps last N backups per file
- Skips excluded patterns

---

## PostToolUse Hooks

Triggered after tool execution completes. Used for cleanup and formatting.

### lint-check

Runs linter on modified JavaScript/TypeScript files.

```json
{
  "name": "lint-check",
  "tools": ["write_file", "replace_string_in_file"],
  "action": "run",
  "condition": {
    "file_extensions": [".js", ".ts", ".jsx", ".tsx"]
  },
  "command": "npx eslint {file} --fix --quiet || true"
}
```

**Triggers**: After creating/editing JS/TS files.
**Action**: Auto-fix linting issues.

### format-check

Formats code with Prettier after modifications.

```json
{
  "name": "format-check",
  "tools": ["write_file", "replace_string_in_file"],
  "condition": {
    "file_extensions": [".js", ".ts", ".jsx", ".tsx", ".json", ".css", ".md"]
  },
  "command": "npx prettier --write {file}"
}
```

**Triggers**: After creating/editing supported files.
**Action**: Format with Prettier.

### type-check

Runs TypeScript type checking after TS file changes.

```json
{
  "name": "type-check",
  "condition": {
    "file_extensions": [".ts", ".tsx"]
  },
  "command": "npx tsc --noEmit {file}"
}
```

**Triggers**: After TypeScript file edits.
**Action**: Report type errors (non-blocking).

---

## SessionStart Hooks

Triggered when a new session begins. Used for context setup.

### project-detect

Automatically detects project type and loads relevant rules.

```json
{
  "name": "project-detect",
  "action": "detect",
  "detectors": [
    {
      "files": ["manifest.json"],
      "context": {
        "type": "chrome-extension",
        "rules": ["rules/javascript/chrome-extension.md"],
        "agent": "agents/chrome-ext-agent.md"
      }
    },
    {
      "files": ["next.config.js"],
      "context": {
        "type": "nextjs-app",
        "rules": ["rules/typescript/react.md"],
        "agent": "agents/saas-agent.md"
      }
    }
  ]
}
```

**Detection Logic**:
1. Check for marker files
2. Match to project type
3. Load relevant rules and agent

### load-memory

Loads project-specific context files.

```json
{
  "name": "load-memory",
  "action": "load",
  "files": [
    ".claude/memory.md",
    ".claude/context.md",
    "CLAUDE.md"
  ]
}
```

**Behavior**: Reads and injects context from specified files if they exist.

### check-gitignore

Verifies security-critical files are gitignored.

```json
{
  "name": "check-gitignore",
  "action": "validate",
  "rules": [
    {
      "type": "file-check",
      "file": ".gitignore",
      "contains": [".env", ".env.local"],
      "warning": "Consider adding .env files to .gitignore"
    }
  ]
}
```

---

## Stop Hooks

Triggered when session ends. Used for summarization and cleanup.

### session-summary

Generates a summary of changes made during the session.

```json
{
  "name": "session-summary",
  "action": "summarize",
  "output": {
    "format": "markdown",
    "include": ["files_created", "files_modified", "commands_run"],
    "destination": ".claude/session-{timestamp}.md"
  }
}
```

**Output**: Markdown file with session activity summary.

### commit-reminder

Reminds to commit changes if working directory is dirty.

```json
{
  "name": "commit-reminder",
  "action": "check",
  "condition": "git status --porcelain | grep -q .",
  "message": "You have uncommitted changes..."
}
```

---

## BeforeCommit Hooks

Triggered before git operations. Acts as quality gate.

### secrets-scan

Scans staged files for secrets before commit.

```json
{
  "name": "secrets-scan",
  "action": "run",
  "command": "npx secretlint staged",
  "on_fail": "block"
}
```

**Behavior**: Blocks commit if secrets detected.

### test-run

Runs tests before commit.

```json
{
  "name": "test-run",
  "action": "run",
  "command": "npm test",
  "on_fail": "warn"
}
```

**Behavior**: Warns on test failure but doesn't block.

---

## OnError Hooks

Triggered when errors occur. Used for recovery and debugging.

### error-context

Captures error context for debugging.

```json
{
  "name": "error-context",
  "action": "capture",
  "include": [
    "last_command",
    "exit_code",
    "stderr",
    "recent_files"
  ],
  "output": ".claude/errors/{timestamp}.json"
}
```

### auto-fix-attempt

Attempts automatic fixes for common errors.

```json
{
  "name": "auto-fix-attempt",
  "action": "fix",
  "patterns": [
    {
      "error": "Module not found",
      "fix": "npm install"
    },
    {
      "error": "ENOENT: no such file",
      "fix": "mkdir -p {dirname}"
    }
  ]
}
```

---

## Configuration

Global hook settings in `hooks.json`:

```json
{
  "config": {
    "enabled": true,
    "verbose": false,
    "parallel": false,
    "timeout_ms": 30000,
    "ignore_errors": false,
    "log_file": ".claude/hooks.log"
  }
}
```

| Setting | Default | Description |
|---------|---------|-------------|
| `enabled` | `true` | Enable/disable all hooks |
| `verbose` | `false` | Log detailed hook execution |
| `parallel` | `false` | Run hooks in parallel |
| `timeout_ms` | `30000` | Max hook execution time |
| `ignore_errors` | `false` | Continue on hook errors |
| `log_file` | `.claude/hooks.log` | Hook activity log |

---

## Custom Hooks

Add custom hooks by extending `hooks.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "name": "my-custom-hook",
        "description": "My custom action",
        "tools": ["write_file"],
        "action": "run",
        "condition": {
          "file_extensions": [".py"]
        },
        "command": "black {file}"
      }
    ]
  }
}
```

### Action Types

| Action | Description | Parameters |
|--------|-------------|------------|
| `validate` | Check against rules | `rules` array |
| `run` | Execute command | `command` string |
| `backup` | Create file backup | `config` object |
| `load` | Load files into context | `files` array |
| `summarize` | Generate summary | `output` config |
| `check` | Conditional check | `condition`, `message` |
| `capture` | Capture context | `include` array |
| `fix` | Auto-fix patterns | `patterns` array |

### Variables

Available in commands:
- `{file}` — Full file path
- `{filename}` — File name only
- `{dirname}` — Directory path
- `{ext}` — File extension
- `{timestamp}` — ISO timestamp
]]>