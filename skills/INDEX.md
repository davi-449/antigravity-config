# 🧭 Universal SaaS Builder Skills Index (Dispatcher)

Este índice é o ponto de entrada central para o agente. Identifique a intenção da tarefa e carregue **APENAS** as skills correspondentes (respeitando o limite de no máximo 1-2 skills por tarefa / ≤10k tokens).

---

## 🎯 Mapa de Despacho Rápido por Intenção

| Intenção da Tarefa | Skills a Carregar | Referências Específicas (On-Demand) |
|---|---|---|
| **Criar projeto SaaS do zero** | `saas-scaffold/SKILL.md` + `database/SKILL.md` | `saas-scaffold/references/01-project-setup.md`, `03-lovable-compat.md` |
| **Construir Telas / UI / Componentes** | `frontend-design-pro/SKILL.md` + `ui-components/SKILL.md` | `frontend-design-pro/references/ai-slop-catalog.md`, `dark-ui-depth.md`, `ui-components/references/` |
| **Refinar UI / Eliminar AI Slop (/audit, /polish)** | `frontend-design-pro/SKILL.md` | `frontend-design-pro/references/audit-polish-flow.md` |
| **Landing Pages & Animações (≤200ms)** | `ui-components/SKILL.md` + `ui-motion/SKILL.md` | `ui-motion/references/recipes.md`, `cinematic-landing-page.md` |
| **Autenticação & Proteção de Rotas** | `auth/SKILL.md` | `auth/references/auth-patterns.md` |
| **Banco de Dados / Schema / Migrations / RLS** | `database/SKILL.md` | `database/references/rls-patterns.md`, `schema-patterns.md` |
| **Server Actions / APIs / Edge Functions** | `backend-patterns/SKILL.md` | `backend-patterns/references/server-action-templates.md` |
| **Deploy / SEO / Performance / Prod Readiness** | `deploy-production/SKILL.md` | `deploy-production/references/checklist-launch.md` |
| **Cybersecurity & AppSec** | `security/SKILL.md` | `security/references/sentry-taint-analysis.md`, `cloudflare-adversarial.md` |
| **Git Headless / Branches / PRs / CI-CD** | `github-ops/SKILL.md` | `github-ops/SKILL.md` |
| **Integração agy CLI / Workers Headless** | `agy-bridge/SKILL.md` | `scripts/spawn-agy-worker.ps1` |

---

## 🔄 Ciclo de Vida SDD (Antigravity 2.0 Native)

| Fase do Ciclo | Skill Canônica | Ativação Semântica | Slash Command |
|---|---|---|---|
| **Setup & Bootstrap** | `sdd-setup/SKILL.md` | "configurar ambiente", "setup" | `/setup` |
| **Planejamento & Spec (Plan-First)** | `sdd-proposal/SKILL.md` | "planejar feature", "criar spec" | `/sdd-proposal` |
| **Implementação & QA (Surgical)** | `sdd-apply/SKILL.md` | "implementar spec", "executar spec" | `/sdd-apply` |
| **Auditoria & Commit** | `sdd-archive/SKILL.md` | "arquivar spec", "finalizar feature" | `/sdd-archive` |
| **Diagnóstico Forense** | `sdd-debug/SKILL.md` | "corrigir bug", "investigar erro" | `/sdd-debug` |

---

## 🛑 Regras Rígidas de Context Budget

1. **Progressive Disclosure**: Carregue no máximo 1-2 skills simultâneas por turno.
2. **Single-Agent Direct**: Sem despacho em cadeia multi-agente para tarefas de escrita.
3. **Plan-First Mandatório**: Nenhuma edição de código sem mapeamento de Blast Radius e aprovação prévia.