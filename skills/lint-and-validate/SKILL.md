---
name: lint-and-validate
description: "Quality gate before committing. Zero lint errors, zero TypeScript any, no unused imports."
risk: safe
source: upstream (sickn33/antigravity-awesome-skills) + local adaptation
imported_on: "2026-04-14"
local_adaptation: true
category: quality
---

# Lint and Validate

Apply before any commit or PR. This is the minimum quality bar — no exceptions.

## Use this skill when

- Finishing a `/vibe-apply` phase
- Before committing any code
- Before opening a PR
- After a refactoring session

---

## Validation Checklist

### TypeScript
- [ ] Zero `any` types (explicit or implicit)
- [ ] All function parameters have types
- [ ] All return types declared (for exported functions)
- [ ] No `@ts-ignore` without a documented reason
- [ ] No `as unknown as X` casts without strong justification

### Imports
- [ ] No unused imports
- [ ] No duplicate imports
- [ ] Absolute imports over relative where configured
- [ ] No circular dependencies

### React / JSX
- [ ] All hooks follow hooks rules (no conditional hooks)
- [ ] `useEffect` dependencies arrays are complete
- [ ] No missing key props in lists
- [ ] No console.log left in production code (use structured logging)

### Code Quality
- [ ] No dead code (commented-out code blocks removed)
- [ ] Functions are focused (single responsibility)
- [ ] No TODOs left without a tracking issue
- [ ] Variable names are clear and descriptive

### Supabase Specific
- [ ] No hardcoded connection strings or API keys
- [ ] All `supabase.from()` calls handle errors (`.error` check)
- [ ] Types match the `database.types.ts` schema
- [ ] RLS implications considered for all new queries

---

## How to run lint

```bash
# TypeScript check
npx tsc --noEmit

# ESLint (if configured)
npx eslint src/ --ext .ts,.tsx

# Or combined (Vite projects)
npm run build  # catches TS errors
```

## Common Fixes

### Removing `any`
```typescript
// Before
function process(data: any) { ... }

// After
function process(data: ContactRecord) { ... }
// Or if truly unknown:
function process(data: unknown) { ... }
```

### Fixing unused imports
```typescript
// Before
import { useState, useEffect, useCallback } from 'react';
// useCallback is unused

// After
import { useState, useEffect } from 'react';
```

### Handling Supabase errors
```typescript
// Before (missing error handling)
const { data } = await supabase.from('contacts').select('*');

// After
const { data, error } = await supabase.from('contacts').select('*');
if (error) throw new Error(`Failed to fetch contacts: ${error.message}`);
```

---

## Exit Criteria
This skill is complete when:
- [ ] `npm run build` (or `tsc --noEmit`) exits with 0 errors
- [ ] Zero `any` visible in the diff
- [ ] No unused imports in changed files
- [ ] PR diff is clean and intentional

## Limitations
- This is a code quality gate, not a functional review.
- Combine with `code-review` for a complete pre-PR check.
