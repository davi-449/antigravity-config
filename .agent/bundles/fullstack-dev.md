# Bundle: Fullstack Dev

> **Quando usar**: Implementação de features full-stack (React + Supabase + TypeScript).
> **Token weight**: Alto (~6 skills). Ative seletivamente se o contexto estiver pesado.
> **Pré-requisito**: Ter um spec aprovado via `planning-mode`.

## Skills incluídas

| Skill | Papel no bundle | Quando ativar |
|-------|----------------|---------------|
| `brainstorming` | Revisão rápida de abordagem antes de codar | Início de cada task do spec |
| `lint-and-validate` | Gate de qualidade obrigatório | Ao fim de cada fase |
| `frontend-design` | Padrões de UX/UI de alta qualidade | Ao criar/modificar componentes |
| `shadcn-ui` | Best practices shadcn/ui | Ao instalar/usar componentes shadcn |
| `react-components` | Conversão Stitch → React com design tokens | Ao processar outputs do Stitch |
| `supabase-best-practices` | Padrões Supabase (migrations, RLS, Edge Functions) | SEMPRE ao tocar banco |

## Quando ativar vs. alternativas

| Situação | Bundle |
|----------|--------|
| Feature nova completa | `fullstack-dev` |
| Só UI visual pesada | `stitch-visual` |
| Só backend/banco | `supabase-best-practices` (skill individual) |
| Bug em produção | `debugging-strategies` (skill individual) |

## Sequência de uso típica

```
1. Confirmar spec aprovado (tasks.md)
2. Ativar fullstack-dev
3. Frontend: frontend-design + shadcn-ui + react-components
4. Backend: supabase-best-practices (migrations → RLS → types)
5. Integração: Antigravity conecta UI ao backend
6. Qualidade: lint-and-validate
7. Encerrar com ship-mode
```

## Redução de contexto
Se o contexto estiver pesado, ative apenas:
- `supabase-best-practices` (backend-only tasks)
- `shadcn-ui` + `frontend-design` (frontend-only tasks)
- `lint-and-validate` (sempre, mas leve)
