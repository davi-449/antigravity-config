---
description: Ativar um bundle de skills específico para a tarefa atual, com documentação de o que está sendo ativado e por quê.
---

<!-- BUNDLE:START -->

**Guardrails**

- Nunca ativar mais de 5 skills simultaneamente (policy: context-budget.md).
- Se o bundle tiver >5 skills, ativar apenas as mais críticas para a fase atual.
- Documentar explicitamente o que está sendo ativado.

**Bundles disponíveis**:
- `core` — brainstorming + lint-and-validate + debugging-strategies
- `planning-mode` — brainstorming + architecture-review + api-design-principles
- `fullstack-dev` — brainstorming + lint-and-validate + frontend-design + shadcn-ui + react-components + supabase-best-practices
- `stitch-visual` — design-md + enhance-prompt + stitch-loop + react-components + remotion
- `ship-mode` — create-pr + lint-and-validate + code-review

**Steps**

1. **Identificar o bundle solicitado** (parâmetro do usuário).

2. **Verificar orçamento atual** — quantas skills estão ativas?
   - Se já há skills ativas: desativar as irrelevantes primeiro.

3. **Listar as skills do bundle** consultando `.agent/bundles/<bundle-name>.md`.

4. **Confirmar a ativação** com o usuário:

```
## ⚡ Bundle Activation — [bundle-name]

**Skills a ativar**:
- [skill 1]: [por que é necessária nesta tarefa]
- [skill 2]: [por que é necessária nesta tarefa]
- ...

**Skills a desativar** (substituídas ou desnecessárias):
- [skill]: [motivo]

**Contexto após ativação**: [N]/5 skills

Confirma a ativação? (sim/não ou ajuste individual)
```

5. **Após confirmação**, aplicar o modo das skills ativas — operar conforme as regras de cada skill do bundle.

6. **Ao finalizar a tarefa**, sugerir:
   - Desativar as skills do bundle
   - Ativar `ship-mode` para commit (se aplicável)

**Reference**

- Definição dos bundles: `.agent/bundles/`
- Política de orçamento: `.agent/policies/context-budget.md`
- Catálogo: `.agent/catalog/README.md`

<!-- BUNDLE:END -->
