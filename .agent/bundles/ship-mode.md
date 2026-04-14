# Bundle: Ship Mode

> **Quando usar**: Antes de commitar, fazer merge ou abrir PR. Garante qualidade e higiene de código.
> **Token weight**: Leve (~3 skills).
> **Regra**: Nenhum `/vibe-apply` deve terminar sem rodar este bundle.

## Skills incluídas

| Skill | Papel no bundle | Quando usar |
|-------|----------------|-------------|
| `lint-and-validate` | Qualidade mínima — sem erros de lint, sem `any` TypeScript | Sempre, primeiro |
| `code-review` | Revisão estruturada do que vai ser commitado | Antes de abrir PR |
| `create-pr` | Estrutura de PR description + conventional commits | Ao criar o PR |

## Checklist de ship

```
[ ] lint-and-validate — zero lint errors, zero TypeScript any
[ ] Sem imports não utilizados
[ ] code-review — revisar diff inteiro antes de commitar
[ ] create-pr — PR description com: context, changes, testing notes
[ ] Conventional commit message (feat/fix/docs/chore/refactor)
[ ] vibe-archive — se spec completada, archivear
```

## Conventional Commits

```
feat(scope): descrição clara da nova feature
fix(scope): descrição do bug que foi corrigido
docs(scope): apenas documentação
chore(scope): tarefas de manutenção sem impacto em produção
refactor(scope): refatoração sem mudança de comportamento
test(scope): adição ou correção de testes
```

## Quando NÃO usar
- Mid-implementation (quando ainda há tasks abertas no spec)
- Para fazer commit de WIP — use `git commit -m "wip: description"` e não abra PR ainda
