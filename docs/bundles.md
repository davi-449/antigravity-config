# Guia de Bundles

Bundles são grupos curados de skills para tipos específicos de tarefa.  
**Instale o repo uma vez, ative o bundle certo para cada tarefa.**

---

## Bundles disponíveis

### `core` — Essencial para qualquer tarefa
> **Peso**: Leve | **Pré-requisito**: nenhum

| Skill | Papel |
|-------|-------|
| `brainstorming` | Planejar antes de agir |
| `lint-and-validate` | Gate de qualidade |
| `debugging-strategies` | Problema? Debugging sistemático |

```
Ative o bundle core para esta tarefa.
```

---

### `planning-mode` — Antes de implementar
> **Peso**: Médio | **Pré-requisito**: nenhum | **Invocado por**: `/vibe-proposal`

| Skill | Papel |
|-------|-------|
| `brainstorming` | Facilitação de requisitos e design |
| `architecture-review` | Decisões arquiteturais com trade-offs |
| `api-design-principles` | Quando há APIs ou Edge Functions envolvidas |

```
Ative o bundle planning-mode para planejar esta feature.
```

**Saída esperada**: `specs/<id>/proposal.md` + `design.md` + `tasks.md`

---

### `fullstack-dev` — Implementação completa React + Supabase
> **Peso**: Alto (6 skills) | **Pré-requisito**: spec aprovado

| Skill | Papel |
|-------|-------|
| `brainstorming` | Revisão de abordagem a cada task |
| `lint-and-validate` | Gate de qualidade contínuo |
| `frontend-design` | Padrões UI/UX React |
| `shadcn-ui` | Componentes shadcn/ui |
| `react-components` | Conversão Stitch → React |
| `supabase-best-practices` | Migrations, RLS, Edge Functions |

```
Ative o bundle fullstack-dev para implementar esta spec.
```

> **Dica**: Se o contexto estiver pesado, ative apenas as skills relevantes à fase atual (ex: só `supabase-best-practices` para uma migration).

---

### `stitch-visual` — UI visual pesada com Stitch MCP
> **Peso**: Médio-alto | **Regra**: obrigatório para >200 linhas JSX novo

| Skill | Ordem | Papel |
|-------|-------|-------|
| `enhance-prompt` | 1º | Otimizar prompt antes de enviar ao Stitch |
| `design-md` | 2º | Documentar design system |
| `stitch-loop` | 3º | Gerar screens com Stitch |
| `react-components` | 4º | Converter screens em React |
| `remotion` | 5º | Vídeo de walkthrough (opcional) |

```
Ative o bundle stitch-visual para gerar esta tela.
```

---

### `ship-mode` — Antes de commitar ou abrir PR
> **Peso**: Leve | **Invocado por**: `/ship-pr`

| Skill | Papel |
|-------|-------|
| `lint-and-validate` | Zero erros, zero `any` |
| `code-review` | Self-review do diff |
| `create-pr` | PR description + conventional commits |

```
Ative o bundle ship-mode para preparar o commit.
```

---

## Combinações recomendadas

| Objetivo | Sequência de bundles |
|----------|---------------------|
| Feature nova completa | `planning-mode` → `fullstack-dev` → `ship-mode` |
| UI nova visual | `planning-mode` → `stitch-visual` → `ship-mode` |
| Bug fix | `debugging-strategies` → `ship-mode` |
| Auditoria de segurança | `security-auditor` (skill individual) |
| MVP rápido | `core` → `fullstack-dev` parcial → `ship-mode` |

---

## Criando um bundle customizado

1. Criar arquivo em `.agent/bundles/meu-bundle.md`
2. Adicionar ao `skill-manifest.yaml` na seção `bundles:`
3. Seguir o formato dos bundles existentes

---

## Limitação de contexto

Máximo **5 skills simultâneas**. Se um bundle tiver mais, ative as mais críticas para a fase atual da tarefa.  
Ver detalhes: `.agent/policies/context-budget.md`
