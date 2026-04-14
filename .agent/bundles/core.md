# Bundle: Core

> **Quando usar**: Em qualquer tarefa de desenvolvimento — é o mínimo viável de skills ativas.
> **Token weight**: Leve (~3 skills pequenas)

## Skills incluídas

| Skill | Papel no bundle |
|-------|----------------|
| `brainstorming` | Previne implementação prematura. Ative antes de qualquer decisão de design. |
| `debugging-strategies` | Debugging sistemático quando algo não funciona como esperado. |
| `lint-and-validate` | Qualidade mínima antes de qualquer commit. |

## Como usar

```
Use o bundle core para esta tarefa.
```

Ou ative individualmente:
```
Use brainstorming para planejar esta mudança.
Use debugging-strategies para investigar este erro.
Use lint-and-validate antes de commitar.
```

## Quando NÃO usar
- Tarefas de UI visual pesada → use `stitch-visual`
- Antes de fazer merge → use `ship-mode`
- Feature estrutural nova → use `planning-mode` (superset do core)

## Upgrade paths
- `core` + frontend → `fullstack-dev`
- `core` + specs → `planning-mode`
- `core` + PR → `ship-mode`
