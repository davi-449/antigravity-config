---
name: architecture-review
description: "Structured review of architectural decisions with explicit trade-off documentation."
risk: safe
source: upstream (sickn33/antigravity-awesome-skills) + local adaptation
imported_on: "2026-04-14"
local_adaptation: true
category: planning
---

# Architecture Review

Use this skill when making significant architectural decisions or reviewing existing architecture for improvement.

## Use this skill when

- Introducing a new major component (new Edge Function cluster, new DB schema domain)
- Evaluating a technology choice (new library, new pattern)
- Refactoring something structural (reorganizing feature boundaries)
- Reviewing a spec before implementation

---

## Decision Framework

For every architectural decision, document:

### 1. Context
What is the problem we're solving? What are the constraints?

### 2. Options Considered
List at least 2-3 alternatives, even if one is "do nothing / keep current".

### 3. Trade-offs Matrix

| Option | Complexity | Scalability | Maintainability | Risk |
|--------|-----------|-------------|-----------------|------|
| Option A | Low | Medium | High | Low |
| Option B | High | High | Medium | Medium |

### 4. Decision + Rationale
What was chosen and **why**. YAGNI applies — don't over-engineer.

### 5. Consequences
What does this decision make easier? What does it make harder?

---

## Architecture Quality Dimensions

### Cohesion
- [ ] Each module/feature has a single clear responsibility
- [ ] Features are organized by domain (Feature-Sliced Design), not by type
- [ ] `src/features/<domain>/` pattern followed

### Coupling
- [ ] Features don't import directly from other features' internals
- [ ] Shared code is in `src/shared/` or `src/lib/`
- [ ] Backend logic not duplicated between Edge Functions

### Testability
- [ ] Business logic is isolated from UI and I/O
- [ ] Dependencies are injectable (not hardcoded)
- [ ] Pure functions where possible

### Evolvability
- [ ] New requirements can be added without changing existing code (Open/Closed)
- [ ] Schema changes are backward compatible where possible
- [ ] API contracts are versioned when breaking

---

## Red Flags to Raise

| Pattern | Risk | Recommendation |
|---------|------|----------------|
| Mega-component (1000+ lines) | Hard to maintain | Split by responsibility |
| Cross-feature imports | Tight coupling | Create shared abstraction |
| Logic in UI components | Can't test without rendering | Extract to hooks/services |
| Supabase calls scattered everywhere | No single source of truth | Centralize in feature hooks |
| God hook (manages 20+ state vars) | Impossible to reason about | Split by concern |

---

## Our Stack Architecture

```
Frontend (React + Vite)
├── src/features/<domain>/     ← Feature-Sliced Design
│   ├── components/            ← UI components
│   ├── hooks/                 ← Logic + data fetching
│   ├── api/                   ← API calls
│   └── types.ts               ← Domain types
├── src/components/ui/         ← shadcn/ui primitives
├── src/lib/                   ← Shared utilities
└── src/types/database.types.ts ← Generated from Supabase

Backend (Supabase)
├── supabase/functions/<name>/ ← Edge Functions
├── supabase/migrations/       ← Schema migrations
└── Postgres RLS Policies      ← Access control
```

## Output

After architecture review, produce a `specs/<id>/design.md` or ADR (Architecture Decision Record) containing:
- Context
- Decision
- Options considered
- Trade-offs
- Consequences

## Limitations
- Architecture review does not replace code review.
- Major decisions should be reviewed by a human before implementation.
