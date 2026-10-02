# ðŸŒ Mapa Global de Features & Componentes CanÃ´nicos

Este arquivo Ã© o registro mestre de tudo o que jÃ¡ existe no ecossistema Antigravity 2.0.
Toda nova spec DEVE consultar este catÃ¡logo para **REUTILIZAR** em vez de duplicar.

---

## 1. Workflows & Ciclo de Vida SDD
- `/sdd-proposal`: Planejamento determinÃ­stico e mapeamento de Blast Radius via Graphify.
- `/sdd-apply`: ImplementaÃ§Ã£o cirÃºrgica com build gate no terminal e reversÃ£o restrita Ã s mudanÃ§as da tarefa.
- `/sdd-archive`: Quality gate, atualizaÃ§Ã£o do grafo topolÃ³gico, preservaÃ§Ã£o de resÃ­duos fora do staging e commit seletivo.
- `/sdd-debug`: DiagnÃ³stico forense com inspeÃ§Ã£o de logs reais e SQL.
- `/council`: DeliberaÃ§Ã£o multi-agente pontual sob demanda explÃ­cita.

---

## 2. Skills CanÃ´nicas Ativas (11 Skills)
1. `frontend-design-pro`: Hub de Design Engineering, Dark UI Zinc-950, 48 guidelines do Rauno e anti-slop.
2. `ui-components`: CatÃ¡logo de componentes Shadcn/Tailwind semÃ¢nticos.
3. `ui-motion`: Micro-interaÃ§Ãµes e animaÃ§Ãµes Magic UI (â‰¤ 200ms).
4. `backend-patterns`: Server Actions tipadas `ActionResult<T>`, Zod e revalidaÃ§Ã£o de cache.
5. `database`: PadrÃµes PostgreSQL/Supabase, multi-tenant RLS e migrations idempotentes.
6. `auth`: AutenticaÃ§Ã£o SSR segura, PKCE, `getUser()` no server.
7. `deploy-production`: 4 camadas de cache App Router, SEO metadata e Core Web Vitals.
8. `security`: AppSec, Taint Analysis (Sentry), Pentest (Cloudflare) e OWASP Top 10.
9. `github-ops`: Git headless e GitHub CLI token-driven.
10. `agy-bridge`: IntegraÃ§Ã£o com agy CLI para workers assÃ­ncronos.
11. `council-debate`: DeliberaÃ§Ã£o multi-agente em 3 rodadas para stress-test arquitetural.

---

## 3. Design System & Theming
- `DESIGN.md`: DicionÃ¡rio de tokens semÃ¢nticos (`bg-background`, `bg-card`, `border-border`, `text-foreground`).
- Controle central de tema dark/preto absoluto via CSS variables no `globals.css`.

---

## 4. Engenharia de Fluxo (GitHub Flow & CI)
- **Issues & PRs**: CriaÃ§Ã£o de issue obrigatÃ³ria (`gh issue create`), branch por tarefa (`feat/id` ou `fix/id`) e PR (`gh pr create`) sempre referenciando `Closes #ID`.
- **PR Template**: `.github/PULL_REQUEST_TEMPLATE.md` padronizando Resumo, Issue, AlteraÃ§Ãµes e Checklist de Testes.
- **CI Quality Gate**: `.github/workflows/quality.yml.example` com lint, typecheck, tests e build verification.

---

## 5. PadrÃµes de Motion & Micro-UX
- **Skeleton Loading**: ObrigatÃ³rio para todos os estados de carregamento assÃ­ncrono (evita layout shift).
- **TransiÃ§Ãµes GPU-accelerated**: Keyframes `slideIn` (240ms ease-out) e saÃ­da suave (`scale(0.96)`, 200ms ease-in). Respeito estrito a `prefers-reduced-motion`.

---

## 6. Observabilidade & Telemetria
- **Sentry Breadcrumbs**: EmissÃ£o de breadcrumbs estruturados antes de qualquer operaÃ§Ã£o crÃ­tica de negÃ³cio (campanhas, pagamentos, mutaÃ§Ãµes).
- **Contextual Capture**: Captura enriquecida com `tags` (feature, entityId) e `extra` seguro (sem PII) em blocos `catch`.

---

## 7. MCPs Instalados & Ativos

| MCP | Tools | Quando Usar |
|---|:---:|---|
| `lazyweb` | 42 | Nova UI, paywall, pricing, dashboard â€” pesquisa competitiva de mercado prÃ©-proposal. |
| `chrome-devtools-mcp` | 29 | ValidaÃ§Ã£o visual pÃ³s-build: Lighthouse, performance trace, console/network errors. |
| `supabase` | 27 | DDL, migrations, Edge Functions, logs, RLS em projetos com `project_id` configurado. |
| `lovable` | 40 | Projetos Lovable: create, send_message, get_diff, set_project_knowledge. |

**Skill dedicada de browser QA:** `skills/browser-qa/SKILL.md`.
**Projeto Lovable/Supabase ativo:** Financeiro/ConciliaÃ§Ã£o (ver `.agent/memory/infra.md`).

---

## 8. Subagentes Especializados de Leitura & GovernanÃ§a (v2.19)

| Subagente | LocalizaÃ§Ã£o | FunÃ§Ã£o | PermissÃµes |
|---|---|---|:---:|
| `codebase-scout` | `.agents/agents/codebase-scout.md` | Varredura profunda de cÃ³digo, rastreamento de tipos e interfaces legadas sem poluir o contexto principal. | ðŸ”’ Leitura (`commandExecutionPolicy: off`) |
| `web-researcher` | `.agents/agents/web-researcher.md` | Pesquisa de documentaÃ§Ãµes na web, bibliotecas e referÃªncias no GitHub. | ðŸ”’ Leitura (`commandExecutionPolicy: off`) |
| `sdd-reviewer` | `.agents/agents/sdd-reviewer.md` | RevisÃ£o preventiva em leitura de propostas e diffs com risco arquitetural ou duplicaÃ§Ã£o. | ðŸ”’ Leitura (`commandExecutionPolicy: off`) |

**PadrÃ£o CanÃ´nico de ConfiguraÃ§Ã£o de Projetos:** `<project>/.gemini/config.json` (gerado a partir de `templates/project-gemini-config.json`).
