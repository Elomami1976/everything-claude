# Contributing to everything-claude

Thank you for helping make this kit better! Here's how to get started.

## What We're Looking For

| Type | Examples |
|---|---|
| New rules | Rust, Go, Swift, or framework-specific coding standards |
| New skills | Deployment automation, testing frameworks, accessibility audits |
| New commands | Useful workflow shortcuts |
| New templates | Vue, Django, React Native starters |
| Bug fixes | Incorrect guidance, broken hook scripts, typos |
| Docs | Clearer explanations, more examples |

## Quick Contribution (no local setup needed)

For small fixes (typos, adding a rule, tweaking a skill):

1. Fork the repository
2. Edit the file directly on GitHub
3. Submit a pull request with a clear title

## Full Local Setup

```bash
# Fork and clone
git clone https://github.com/YOUR_USERNAME/everything-claude.git
cd everything-claude

# Create a branch
git checkout -b feat/add-rust-rules
```

## Branch Naming

```
feat/add-<thing>      # new file or feature
fix/<what>            # bug fix
docs/<what>           # documentation only
chore/<what>          # maintenance tasks
```

## Adding a New Rule

1. Choose a directory: `rules/common/`, `rules/javascript/`, `rules/typescript/`, `rules/python/`
2. Create a `.md` file (e.g., `rules/python/django.md`)
3. Follow the pattern from existing rules: start with a purpose statement, use numbered sections
4. Add it to `README.md` under the relevant language section

## Adding a New Skill

1. Create `skills/<name>.md`
2. Include:
   - Description of what the skill provides to AI
   - Clear numbered steps or sections
   - Example usage
3. Reference it in `README.md` and `docs/SKILLS.md`
4. Optionally create a matching template in `templates/`

## Adding a New Command

1. Create `commands/<name>.md`
2. Include:
   - Purpose
   - What the AI should do when this command is used
   - Example input/output
3. Add it to `README.md` and `docs/COMMANDS.md`

## Writing Good AI Instructions

Rules and skills are read by AI assistants, so clarity matters:

- **Be explicit**: Say "always" or "never" for hard requirements
- **Be specific**: Give concrete examples, not vague guidelines
- **Be concise**: AI contexts are limited — every word counts
- **Use positive framing**: "Use X" is clearer than "Don't use Y when Z"

## Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org):

```
feat: add django rules  
fix: correct stripe webhook event type  
docs: expand saas skill with billing example  
chore: update package.json version  
```

## Pull Request Checklist

Before submitting a PR:

- [ ] Branch is up-to-date with `main`
- [ ] New files follow the naming conventions of similar existing files
- [ ] README.md updated if adding a new rule, skill, command, or template
- [ ] No API keys, tokens, or personal data in any file
- [ ] Markdown renders correctly (check with GitHub preview)

## PR Title Format

```
feat: add Rust rules for memory safety
fix: correct background service worker pattern
docs: add Django template to templates/
```

## Code of Conduct

- Be constructive and specific in reviews
- AI-generated contributions are welcome — just review them before submitting
- Don't break existing behavior without discussing in an issue first

## Getting Help

Open a [GitHub Discussion](https://github.com/Elomami1976/everything-claude/discussions) for:
- Questions about how things work
- Ideas before implementing them
- Feedback on your draft

Open an [Issue](https://github.com/Elomami1976/everything-claude/issues) for:
- Something is wrong or broken
- A specific missing feature

## Recognition

All contributors are welcome in the README. Include your name in your first PR and we'll add you.
