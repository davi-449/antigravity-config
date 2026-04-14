---
name: create-pr
description: "Structure a clean Pull Request with conventional commits, clear description, and testing notes."
risk: safe
source: upstream (sickn33/antigravity-awesome-skills) + local adaptation
imported_on: "2026-04-14"
local_adaptation: true
category: devops
---

# Create PR

Package finished work into a well-structured Pull Request with conventional commits and clear description.

## Use this skill when

- Finishing a `/vibe-apply` spec
- Preparing code for review
- Merging a feature branch
- Activating `/ship-pr` workflow

---

## Conventional Commit Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types
| Type | When to use |
|------|-------------|
| `feat` | New feature or user-facing addition |
| `fix` | Bug fix |
| `docs` | Documentation only changes |
| `chore` | Maintenance tasks with no production impact |
| `refactor` | Refactoring without behavior change |
| `test` | Adding or fixing tests |
| `perf` | Performance improvements |
| `ci` | CI/CD configuration |

### Scope (optional, lowercase)
Use the feature area: `auth`, `crm`, `leads`, `dashboard`, `api`, `db`, `config`

### Examples
```bash
feat(leads): add status filter to leads table
fix(auth): resolve redirect loop after logout
docs(readme): update installation instructions
chore(deps): update supabase-js to v2.39
refactor(api): consolidate contact creation logic
feat(db): add automation_rules table with RLS policies
```

---

## PR Description Template

```markdown
## Context
<!-- Why this change? What problem does it solve? -->

## Changes
<!-- What was changed? Be specific. -->
- 
- 
- 

## Database Changes
<!-- List any migrations, new tables, or RLS changes -->
- [ ] No database changes
- [ ] Migration: `YYYYMMDD_description.sql`
- [ ] RLS policies updated for: `table_name`

## Testing
<!-- How was this tested? -->
- [ ] Tested locally
- [ ] No regressions in existing flows
- [ ] Relevant spec: `specs/<id>/`

## Screenshots
<!-- If UI changed, add before/after screenshots -->

## Checklist
- [ ] `npm run build` passes
- [ ] No `any` TypeScript types
- [ ] No unused imports
- [ ] RLS reviewed (if DB change)
- [ ] Spec archived (if applicable)
```

---

## Git Workflow

```bash
# 1. Make sure you're on the right branch
git status

# 2. Stage only intentional changes
git add -p  # interactive staging (preferred over git add .)

# 3. Commit with conventional commit message
git commit -m "feat(crm): add lead status filter"

# 4. Push and open PR
git push origin feature/your-branch

# 5. Create PR via GitHub UI or CLI
gh pr create --title "feat(crm): add lead status filter" --body "$(cat .pr-template.md)"
```

## Commit Hygiene Rules
- One logical change per commit
- Don't mix refactoring with features in the same commit
- If a commit message needs "and", split it into two commits
- Never commit: `.env`, `node_modules/`, API keys, passwords

## Limitations
- This skill covers PR structure. For security review, use `security-auditor`.
- For code quality, run `lint-and-validate` first.
