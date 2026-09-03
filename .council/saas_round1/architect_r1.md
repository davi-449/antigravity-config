# ARCHITECT — Round 1

## Estrutura atual: Flat Loading = Context Suicide
graphify=70KB é o maior anti-padrão existente. Skills fragmentadas sem dispatcher.

## Proposta: 3 Camadas + Dispatcher

CAMADA 0 — INDEX.md (≤3KB, lido SEMPRE)
- Tabela de despacho: intent → skill correspondente
- Regra: nunca carregar mais de 2 skills simultaneamente

CAMADA 1 — 6-7 SKILL.md por domínio (≤6KB cada)
- ui-primitives (shadcn/ui base)
- ui-blocks (landing, dashboard, forms compostos)  
- motion-patterns (Magic UI)
- design-system (OpenDesign tokens)
- app-scaffold (Dyad-inspired workflows)
- ai-generation (v0 patterns, claude-directory)

CAMADA 2 — references/ (on-demand, ≤12KB cada)
- hero-patterns.md, dashboard-patterns.md, auth-patterns.md
- Lidos SOMENTE quando SKILL.md instrui explicitamente

CAMADA 3 — WORKFLOW.md (contrato de navegação)
- max_skills_simultaneous: 2
- max_total_kb_in_context: 15KB
- overflow_protocol: decompose_task

## Schema de cada SKILL.md
```yaml
---
name: [nome]
domain: [ui-primitives|ui-blocks|motion|design-system|app-scaffold|ai-generation]
sources: [lista das fontes externas]
triggers: [keywords de despacho]
references: [reference files que pode invocar]
max_context_kb: 6
---
```

## Regra de extração das fontes
- Máximo 3 padrões canônicos por fonte (os 80% dos casos de uso)
- Padrões de COMPOSIÇÃO, não de implementação interna

## Métricas target
| Métrica | Atual | Target |
|---|---|---|
| Context overhead por tarefa | ~5KB | ≤15KB |
| Skills lidas por tarefa | 1 (todo) | 1 SKILL + 0-1 reference |
| Arquivos totais KRL | 13 | 18-21 |

## Conclusão: FAVORÁVEL com ressalvas
- A extração das fontes é o gargalo real
- graphify 70KB deve ser refatorado em paralelo
- Mais de 25 arquivos indica falha de curadoria
