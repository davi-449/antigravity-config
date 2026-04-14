---
name: code-review
description: "Structured code review checklist for PR review and self-review before committing."
risk: safe
source: upstream (sickn33/antigravity-awesome-skills) + local adaptation
imported_on: "2026-04-14"
local_adaptation: true
category: quality
---

# Code Review

Apply this skill when reviewing code — either as a self-review before committing, or as a reviewer on a PR.

## Use this skill when

- Reviewing your own diff before opening a PR
- Acting as a reviewer on someone else's PR
- Doing a quality pass after `/vibe-apply`

---

## Review Framework: SOLID+S

| Letter | Area | Key questions |
|--------|------|---------------|
| **S** | Safety | Can this crash? Are inputs validated? Are errors handled? |
| **O** | Obvious | Is the intent clear without reading implementation? |
| **L** | Logic | Does this actually do what the author thinks? |
| **I** | Isolation | Is responsibility properly separated? |
| **D** | Dependencies | Are imports/deps appropriate? No unnecessary coupling? |
| **S** | Security | Any auth bypass, data leak, or injection risk? |

---

## Checklist

### Correctness
- [ ] Does the code do what it claims to do?
- [ ] Are edge cases handled (null, undefined, empty array, empty string)?
- [ ] Are async operations properly awaited?
- [ ] Are errors caught and handled gracefully?

### TypeScript
- [ ] No `any` types
- [ ] Types are accurate, not just castings
- [ ] Return types are explicit for exported functions

### React Specific
- [ ] No hooks rules violations (conditional hooks, hooks in callbacks)
- [ ] `useEffect` cleanup functions present where needed
- [ ] Props are typed with interfaces (not inline types for complex shapes)
- [ ] Keys are stable (not array indices for dynamic lists)

### Supabase Specific
- [ ] All queries handle `.error`
- [ ] RLS implications considered
- [ ] Type assertions match `database.types.ts`
- [ ] No raw SQL concatenation (injection risk)

### Architecture
- [ ] Does this fit the Feature-Sliced Design structure?
- [ ] Is there duplication that should be extracted?
- [ ] Is this component/hook/function reusable or hyper-specific?
- [ ] Are there any timing/race conditions?

### Tests
- [ ] New behavior has tests (or documented reason for exception)
- [ ] Tests cover happy path AND error path
- [ ] Tests don't mock away the thing being tested

---

## Output Format

After review, report as:

```markdown
## Code Review — [PR/Feature name]

### ✅ Approved
[Summary of what looks good]

### 🔴 Must Fix (blocking)
- [file:line] Issue description — suggested fix

### 🟡 Should Fix (non-blocking)
- [file:line] Issue description — recommendation

### 💡 Suggestions (optional)
- [Improvements that are nice-to-have]

### 📋 Summary
[Overall assessment]
```

## Self-Review Protocol
Before opening any PR:
1. Read the diff from top to bottom as if you're the reviewer
2. Check SOLID+S framework for each significant change
3. Run `lint-and-validate` checklist
4. Make sure the PR description is complete

## Limitations
- This review covers code quality and correctness, not product/UX decisions.
- For security-specific review, use `security-auditor`.
