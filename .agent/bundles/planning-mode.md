# Bundle: Planning Mode

> **Quando usar**: Antes de implementar qualquer feature estrutural, decisão arquitetural ou mudança de schema.
> **Token weight**: Médio (~3 skills de tamanho médio-grande)
> **Regra**: `/vibe-proposal` DEVE ativar este bundle.

## Skills incluídas

| Skill | Papel no bundle |
|-------|----------------|
| `brainstorming` | Facilita design e requisitos antes de qualquer código. Ponto de entrada obrigatório. |
| `architecture-review` | Garante que a decisão arquitetural é sólida e documentada com trade-offs. |
| `api-design-principles` | Quando houver endpoints/APIs envolvidos, garante consistência e boa modelagem. |

## Quando ativar

- `/vibe-proposal "Feature name"` → sempre
- Refatorações estruturais (mudança de schema, reorganização de pastas)
- Proposta de nova tabela ou RPC no Supabase
- Design de nova Edge Function
- Decisão de biblioteca ou framework novo

## Como usar

```
Ative o bundle planning-mode para planejar esta feature.
Use brainstorming para levantarmos os requisitos.
```

## Saída esperada
Ao final do planning-mode, você deve ter:
- `specs/<id>/proposal.md` — requisitos e user stories
- `specs/<id>/design.md` — arquitetura e modelagem
- `specs/<id>/tasks.md` — checklist de implementação

Só então passar para `fullstack-dev` ou bundle de implementação.
