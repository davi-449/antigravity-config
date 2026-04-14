# 🪐 antigravity-config

> Repositório de configuração de skills, workflows e regras de orquestração para **Gemini CLI / Antigravity**.  
> Curado, modular, com roteamento por tipo de tarefa e baixo acoplamento.

---

## Proposta de valor

Este repositório resolve um problema real: **agentes de coding com contexto sobrecarregado, regras inconsistentes e sem guidance sobre quando usar cada ferramenta**.

**O que você ganha:**
- ✅ **17 skills curadas** — não 1400+ genéricas sem curadoria
- ✅ **5 bundles** — agrupamentos por tipo de tarefa (planning, fullstack, stitch, ship)
- ✅ **8 workflows** — slash commands para todo o ciclo de desenvolvimento
- ✅ **Roteamento inteligente** — skill certa para cada momento
- ✅ **Budget de contexto** — máximo 5 skills ativas, sem sobrecarga
- ✅ **Filosofia spec-first** — anti-vibe-coding-puro, planejamento antes de código

---

## Instalação

### Windows (PowerShell)
```powershell
.\setup\install.ps1
```

### Linux / macOS
```bash
bash setup/install.sh
```

### Alternativa: usar diretamente no workspace
Clone este repo e use os arquivos de `.agent/`, `.antigravity/` e `skills/` no seu projeto.

---

## Estrutura

```
.agent/
├── rules/
│   └── ia.md                   ← Regras de orquestração v2 (FONTE DA VERDADE)
├── workflows/
│   ├── vibe-proposal.md        ← /vibe-proposal — planejamento sem código
│   ├── vibe-apply.md           ← /vibe-apply — implementação guiada
│   ├── vibe-archive.md         ← /vibe-archive — arquivar spec concluída
│   ├── route-task.md           ← /route-task — roteador de skills por tarefa
│   ├── ship-pr.md              ← /ship-pr — quality gate + commit + PR
│   ├── skill-audit.md          ← /skill-audit — auditoria de contexto
│   ├── bundle-activate.md      ← /bundle-activate — ativação de bundle
│   └── crm-test.md             ← /crm-test — teste do CRM no browser
├── manifests/
│   └── skill-manifest.yaml     ← Catálogo central (metadados de todas as skills)
├── bundles/
│   ├── core.md                 ← Essencial para qualquer tarefa
│   ├── planning-mode.md        ← Antes de implementar
│   ├── fullstack-dev.md        ← Desenvolvimento React + Supabase
│   ├── stitch-visual.md        ← UI visual com Stitch MCP
│   └── ship-mode.md            ← Quality gate + commit + PR
├── catalog/
│   └── README.md               ← Índice navegável de skills
└── policies/
    ├── context-budget.md       ← Limites de contexto e ativação seletiva
    ├── activation-rules.md     ← Quando ativar/desativar cada skill
    └── sync-upstream.md        ← Como sincronizar com upstream sickn33

.antigravity/
└── rules.md                    ← Espelho sincronizado de ia.md

skills/                         ← 17 skills organizadas
├── [6 skills Stitch oficiais]  ← design-md, enhance-prompt, react-components...
├── [11 skills curadas]         ← brainstorming, debugging-strategies, TDD...
└── [1 skill custom]            ← supabase-best-practices

docs/                           ← Documentação
setup/                          ← Scripts de instalação
```

---

## Bundles disponíveis

| Bundle | Skills | Quando usar |
|--------|--------|-------------|
| `core` | brainstorming, lint-and-validate, debugging-strategies | Qualquer tarefa |
| `planning-mode` | brainstorming, architecture-review, api-design-principles | Antes de implementar |
| `fullstack-dev` | brainstorming, lint-and-validate, frontend-design, shadcn-ui, react-components, supabase-best-practices | Feature completa React+Supabase |
| `stitch-visual` | design-md, enhance-prompt, stitch-loop, react-components, remotion | UI visual com Stitch MCP |
| `ship-mode` | create-pr, lint-and-validate, code-review | Antes de commitar/PR |

---

## Fluxo de desenvolvimento

```
/route-task            → identifica o tipo de tarefa e recomenda bundle
/vibe-proposal "feat"  → spec completo (proposal + design + tasks)
/bundle-activate X     → ativa o bundle correto
/vibe-apply <id>       → implementação guiada pelo spec
/ship-pr               → quality gate + commit semântico + PR
/vibe-archive <id>     → arquiva spec, limpa contexto
```

### Exemplos de uso rápido

```
Use brainstorming para planejar esta mudança de schema.
Ative o bundle fullstack-dev para implementar esta spec.
Use debugging-strategies para investigar este erro de RLS.
Ative o bundle ship-mode antes de commitar.
/route-task — qual skill devo usar para este bug?
/skill-audit — estou com contexto pesado, o que posso desativar?
```

---

## Skills curadas

### 🎨 Frontend / Stitch (6 skills)
- `design-md` — Gera DESIGN.md para Stitch MCP
- `enhance-prompt` — Otimiza prompts do Stitch
- `react-components` — Converte screens Stitch → React
- `shadcn-ui` — Expert guidance shadcn/ui
- `stitch-loop` — Gera apps multi-página
- `remotion` — Vídeos de walkthrough

### 📋 Planning (3 skills)
- `brainstorming` — Design facilitator spec-first
- `architecture-review` — Decisões com trade-offs documentados
- `api-design-principles` — REST/API consistency

### 🔍 Debugging + Quality (4 skills)
- `debugging-strategies` — Debugging sistemático
- `test-driven-development` — Red/Green/Refactor
- `lint-and-validate` — Gate de qualidade
- `code-review` — Self-review antes de merge

### 🔒 Security (1 skill)
- `security-auditor` — RLS + auth + endpoints

### 🎨 UI/UX (1 skill)
- `frontend-design` — Padrões React/shadcn premium

### 🗄️ Backend (1 skill)
- `supabase-best-practices` — Migrations, RLS, Edge Functions

### 🚀 Release (1 skill)
- `create-pr` — PR description + conventional commits

---

## Roteamento por tarefa

| Tarefa | Recomendação |
|--------|-------------|
| Planejar feature nova | `planning-mode` → `/vibe-proposal` |
| Implementar spec | `fullstack-dev` → `/vibe-apply` |
| Criar tela do zero (>200 linhas) | `stitch-visual` |
| Debugar bug misterioso | `debugging-strategies` |
| Auditoria de segurança | `security-auditor` |
| Criar endpoint/API | `planning-mode` + `api-design-principles` |
| Preparar commit/PR | `ship-mode` → `/ship-pr` |

Ver guia completo: [docs/router-guide.md](docs/router-guide.md)

---

## Manutenção e sync com upstream

**Upstream de referência**: [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills)

Sync é **manual e semestral** — nunca automático.  
Processo: `.agent/policies/sync-upstream.md`

### Adicionando uma nova skill
```
1. Criar skills/<nome>/SKILL.md
2. Adicionar ao .agent/manifests/skill-manifest.yaml
3. Atualizar .agent/catalog/README.md
4. Se do upstream: seguir sync-upstream.md para atribuição
```

---

## Troubleshooting

| Problema | Solução |
|----------|---------|
| Agente esquece as regras no meio da tarefa | Contexto sobrecarregado → `/skill-audit` |
| "Não sei qual skill usar" | `/route-task` + descreva a tarefa |
| Agent travado em loop de planejamento | Verifique se spec está aprovado, use `/vibe-apply` |
| Skills conflitantes ativas | `/skill-audit` → desativar as não relevantes |
| Contexto estourou no Windows | Reduzir skills ativas para 2-3; ver `context-budget.md` |

---

## Documentação

- [Getting Started](docs/getting-started.md) — fluxo completo do zero
- [Bundles](docs/bundles.md) — guia de todos os bundles
- [Router Guide](docs/router-guide.md) — como decidir qual skill usar
- [Skills Usage](docs/skills-usage.md) — como ativar e criar skills
- [Catálogo](/.agent/catalog/README.md) — todas as skills por categoria

---

## Fontes e Atribuição

| Fonte | Skills |
|-------|--------|
| [google-labs-code/stitch-skills](https://github.com/google-labs-code/stitch-skills) | design-md, enhance-prompt, react-components, shadcn-ui, stitch-loop, remotion |
| [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) | brainstorming, debugging-strategies, TDD, security-auditor, api-design-principles, create-pr, lint-and-validate, frontend-design, code-review, architecture-review |
| Original (este repo) | supabase-best-practices, todos os workflows e bundles |

---

## License

MIT — ver [LICENSE](LICENSE)
