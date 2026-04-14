# CHANGELOG

All notable changes to `antigravity-config` are documented here.

Format: [Conventional Commits](https://www.conventionalcommits.org/)  
Sync upstream reference: [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills)

---

## [2.0.0] — 2026-04-14

### 🏗️ Architecture
Major evolution from single-purpose Stitch skill repo to a fully modular, routed, curated agent configuration system.

### ✨ Added

#### Skills curadas (11 novas)
- `skills/brainstorming/SKILL.md` — design facilitator, spec-first (upstream: sickn33)
- `skills/debugging-strategies/SKILL.md` — systematic debugging (upstream: sickn33, adapted)
- `skills/test-driven-development/SKILL.md` — Red/Green/Refactor TDD (upstream: sickn33)
- `skills/security-auditor/SKILL.md` — Supabase RLS + auth audit (upstream: sickn33, adapted)
- `skills/api-design-principles/SKILL.md` — REST consistency + Edge Functions (upstream: sickn33, adapted)
- `skills/create-pr/SKILL.md` — conventional commits + PR template (upstream: sickn33, adapted)
- `skills/lint-and-validate/SKILL.md` — TypeScript + Supabase quality gate (upstream: sickn33, adapted)
- `skills/frontend-design/SKILL.md` — React + shadcn/ui UI/UX patterns (upstream: sickn33, adapted)
- `skills/code-review/SKILL.md` — SOLID+S framework self-review (upstream: sickn33, adapted)
- `skills/architecture-review/SKILL.md` — architectural decision records (upstream: sickn33, adapted)
- `skills/supabase-best-practices/SKILL.md` — migrations, RLS, Edge Functions (original)

#### Bundles (5 novos)
- `.agent/bundles/core.md`
- `.agent/bundles/planning-mode.md`
- `.agent/bundles/fullstack-dev.md`
- `.agent/bundles/stitch-visual.md`
- `.agent/bundles/ship-mode.md`

#### Workflows (4 novos)
- `.agent/workflows/route-task.md` — task router
- `.agent/workflows/ship-pr.md` — quality gate + commit + PR
- `.agent/workflows/skill-audit.md` — context overload diagnosis
- `.agent/workflows/bundle-activate.md` — explicit bundle activation

#### Infrastructure
- `.agent/manifests/skill-manifest.yaml` — central skill catalog with full metadata
- `.agent/catalog/README.md` — navigable skill index by category/bundle/risk
- `.agent/policies/context-budget.md` — max 5 skills, selective activation
- `.agent/policies/activation-rules.md` — when to activate/suppress skills
- `.agent/policies/sync-upstream.md` — manual semi-annual sync process
- `docs/getting-started.md`
- `docs/bundles.md`
- `docs/router-guide.md`
- `docs/skills-usage.md`
- `setup/install.sh`
- `setup/install.ps1`
- `CHANGELOG.md`

### 🔄 Changed
- `README.md` — complete rewrite with value proposition, architecture, bundles, routing
- `.antigravity/rules.md` — synced to ia.md v2 (was v1, disconnected)

### 🏷️ Preserved (no breaking changes)
- All 6 original Stitch skills: `design-md`, `enhance-prompt`, `react-components`, `remotion`, `shadcn-ui`, `stitch-loop`
- All existing workflows: `vibe-proposal`, `vibe-apply`, `vibe-archive`, `crm-test`
- `.agent/rules/ia.md` — source of truth, untouched

---

## [1.0.0] — 2025-xx-xx

### Initial release
- 6 Stitch skills from google-labs-code/stitch-skills
- Vibe Coding workflows: vibe-proposal, vibe-apply, vibe-archive
- ia.md orchestration rules v1 and v2
- crm-test workflow
