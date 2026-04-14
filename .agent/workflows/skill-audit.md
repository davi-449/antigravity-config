---
description: Auditar quais skills estão ativas, identificar conflitos ou sobrecarga de contexto, e recomendar desativações.
---

<!-- AUDIT:START -->

**Guardrails**

- Este workflow é READ-ONLY. Apenas diagnostica, não modifica.
- Seja honesto sobre conflitos — não tente justificar tudo como correto.

**Objetivo**

Garantir que o conjunto de skills ativas está adequado à tarefa atual. Previne:
- Sobrecarga de contexto (>5 skills simultâneas)
- Skills conflitantes ativas ao mesmo tempo
- Skills irrelevantes pesando no contexto

**Steps**

1. **Liste todas as skills possivelmente ativas** na sessão atual:
   - Skills mencionadas explicitamente pelo usuário
   - Skills do bundle ativado via workflow
   - Skills carregadas por padrão (`rules.md`, `ia.md`)

2. **Para cada skill, avalie**:
   - Está sendo usada ativamente nesta tarefa? (sim/não)
   - É relevante para o tipo de tarefa atual? (sim/não)
   - Está em conflito com outra skill ativa? (ex: `brainstorming` conflita com pressão de implementar rápido)

3. **Verifique o orçamento de contexto** (`.agent/policies/context-budget.md`):
   - Total de skills ativas: [ ]
   - Se >5: identifique quais podem ser desativadas

4. **Emita o relatório** neste formato:

```
## 🔍 Skill Audit — Sessão Atual

### Skills ativas identificadas
| Skill | Relevante? | Uso ativo? | Ação recomendada |
|-------|-----------|------------|-----------------|
| [skill] | [sim/não] | [sim/não] | [manter / desativar / não necessária] |

### Diagnóstico
**Total de skills ativas**: [N]
**Dentro do orçamento?**: [sim / não — limite é 5]
**Conflitos detectados**: [lista ou "nenhum"]

### Recomendações
- Desativar: [lista de skills para remover]
- Manter: [skills essenciais para a tarefa atual]
- Ativar: [skills faltantes que seriam úteis]

### Contexto da tarefa atual
**Tipo**: [planejamento / implementação / debugging / ship]
**Bundle ideal**: [nome do bundle]
```

5. **Após o relatório**, perguntar ao usuário:
   > "Deseja que eu continue com o conjunto de skills recomendado?"

**Reference**

- Limites de contexto: `.agent/policies/context-budget.md`
- Regras de ativação: `.agent/policies/activation-rules.md`
- Manifesto: `.agent/manifests/skill-manifest.yaml`

<!-- AUDIT:END -->
