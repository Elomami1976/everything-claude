<![CDATA[# Git Rules

Consistent Git practices make collaboration easier and maintain project history.

## 1. Conventional Commits Format

**Every commit message must follow this format:**
```
<type>(<scope>): <short description>

<optional body>

<optional footer>
```

**Types:**
| Type | When to Use |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Code style (formatting, semicolons) |
| `refactor` | Code change that doesn't fix or add |
| `perf` | Performance improvement |
| `test` | Adding or fixing tests |
| `chore` | Build process, deps, tooling |
| `ci` | CI/CD configuration |

**Examples:**
```bash
# Feature
git commit -m "feat(auth): add Google OAuth login"

# Bug fix
git commit -m "fix(cart): prevent negative quantities"

# Documentation
git commit -m "docs(readme): add installation instructions"

# Breaking change (use footer)
git commit -m "feat(api): change user endpoint response format

BREAKING CHANGE: user endpoint now returns nested profile object"

# Scope is optional but helpful
git commit -m "fix: resolve memory leak in worker"
```

**Rules:**
- Type is REQUIRED and lowercase
- Description MUST be present and start lowercase
- Max 72 characters for first line
- Use imperative mood ("add" not "added" or "adds")
- Don't end with period

---

## 2. Branch Naming Conventions

**Format:** `<type>/<ticket-number>-<short-description>`

**Branch types:**
| Prefix | Purpose |
|--------|---------|
| `feature/` | New features |
| `fix/` | Bug fixes |
| `hotfix/` | Urgent production fixes |
| `docs/` | Documentation updates |
| `refactor/` | Code refactoring |
| `test/` | Test additions |
| `chore/` | Maintenance tasks |

**Examples:**
```bash
# Feature with ticket number
git checkout -b feature/PROJ-123-user-authentication

# Bug fix
git checkout -b fix/PROJ-456-login-redirect

# Hotfix (no ticket needed for urgent)
git checkout -b hotfix/payment-gateway-down

# No ticket system? Use descriptive names
git checkout -b feature/add-dark-mode
git checkout -b fix/memory-leak-worker
```

**Rules:**
- Use lowercase
- Use hyphens between words (not underscores)
- Keep descriptions short (2-4 words)
- Include ticket number when available
- Delete branches after merge

---

## 3. PR Checklist Before Merging

**Every pull request MUST pass this checklist:**

### Code Quality
- [ ] Code follows project style guidelines
- [ ] No console.log/print debugging statements left
- [ ] No commented-out code
- [ ] No TODO comments without linked issues
- [ ] Functions have clear names and purposes
- [ ] No hardcoded values that should be config

### Testing
- [ ] All existing tests pass
- [ ] New tests added for new functionality
- [ ] Edge cases considered and tested
- [ ] Manual testing completed

### Security
- [ ] No secrets/API keys in code
- [ ] User input is validated
- [ ] SQL queries are parameterized
- [ ] No known vulnerabilities introduced

### Documentation
- [ ] README updated if needed
- [ ] API documentation updated
- [ ] Code comments for complex logic
- [ ] CHANGELOG updated (if applicable)

### Git
- [ ] Branch is up to date with main/master
- [ ] Commits follow conventional format
- [ ] No merge commits (rebased if needed)
- [ ] Single logical change per PR

### Review
- [ ] Self-reviewed changes
- [ ] Requested review from team member
- [ ] All review comments addressed

---

## 4. Git Workflow

**Main branches:**
- `main` or `master` — Production-ready code
- `develop` — Integration branch (optional)

**Workflow:**
```bash
# Start new feature
git checkout main
git pull origin main
git checkout -b feature/add-user-profile

# Work on feature, commit often
git add .
git commit -m "feat(profile): add profile page layout"
git commit -m "feat(profile): add avatar upload"

# Keep up to date with main
git fetch origin
git rebase origin/main

# Push and create PR
git push origin feature/add-user-profile
# Create PR on GitHub/GitLab

# After PR approved and merged
git checkout main
git pull origin main
git branch -d feature/add-user-profile
```

---

## 5. Commit Best Practices

**Commit often, but logically:**
- Each commit should be one logical change
- Should be able to revert without breaking things
- Work in progress? Use `git stash` instead of WIP commits

**Atomic commits:**
```bash
# Good: Separate concerns
git commit -m "feat(ui): add button component"
git commit -m "test(ui): add button component tests"

# Bad: Mixed concerns
git commit -m "add button component and fix unrelated bug and update deps"
```

**Amending commits:**
```bash
# Fix last commit (before push)
git add forgotten-file.js
git commit --amend --no-edit

# Fix commit message
git commit --amend -m "feat(auth): add OAuth (fixed typo)"
```

**Interactive rebase (cleaning up before PR):**
```bash
# Squash last 3 commits into one
git rebase -i HEAD~3
```

---

## 6. Gitignore Essentials

**Must-ignore files:**
```gitignore
# Dependencies
node_modules/
vendor/
venv/
__pycache__/

# Environment
.env
.env.local
.env.*.local

# Build outputs
dist/
build/
*.pyc

# IDE
.idea/
.vscode/
*.swp

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Test coverage
coverage/
.nyc_output/
```

---

## 7. Handling Sensitive Data

**If you accidentally commit secrets:**
```bash
# Remove from last commit (before push)
git reset HEAD~1

# Already pushed? Rewrite history (coordinate with team!)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/secret-file" \
  --prune-empty --tag-name-filter cat -- --all

# Force push (requires coordination!)
git push origin --force --all
```

**Better: Use pre-commit hooks to prevent this:**
```bash
# Install pre-commit
pip install pre-commit

# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
```

---

## Quick Reference

```bash
# Common commands
git status                    # Check status
git diff                      # See unstaged changes
git log --oneline -10        # Recent commits
git branch -a                # All branches
git stash                    # Stash changes
git stash pop               # Restore stash

# Undo commands
git checkout -- file.js     # Discard changes to file
git reset HEAD file.js      # Unstage file
git reset --soft HEAD~1     # Undo last commit, keep changes
git reset --hard HEAD~1     # Undo last commit, discard changes (careful!)
```
]]>