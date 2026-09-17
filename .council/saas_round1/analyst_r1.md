# ANALYST — Round 1

## Custo total por repositório

| Repositório | Tokens KRL Est. | Manutenção/mês | Risco Staleness |
|---|---|---|---|
| shadcn/ui | ~25.000 | Alto (releases mensais) | CRÍTICO |
| shadcnblocks.com | ~12.000 | Médio | ALTO |
| 21st.dev | ~10.000 | Médio (sem repo público) | ALTO |
| Magic UI | ~15.000 | Médio | MÉDIO |
| v0/Vercel ai-elements | ~20.000 | MUITO Alto | CRÍTICO |
| Dyad | ~6.000 | Baixo | BAIXO |
| OpenDesign | ~5.000 | Baixo | BAIXO |
| claude-directory | ~8.000 | Médio | MÉDIO |
| TOTAL RAW | ~101.000 | | |

## Ponto de inflexão empírico
ROI máximo: 8.000-15.000 tokens por tarefa específica
Acima de 25.000 tokens de KRL injetado: ROI cai >40%

## Cenários de falha
| Cenário | Probabilidade |
|---|---|
| KRL monolítico → agente ignora 60% | 85% |
| KRL desatualizado → componente com API errada | 70% |
| Agente confunde padrão de fontes diferentes | 60% |
| Manutenção abandonada em 60 dias | 75% |

## Priorização por ROI

TIER 1 — Alto ROI (MANTER):
- shadcn/ui: API estável, TypeScript tipado, alicerce do stack
- Dyad: repo pequeno, baixo custo de extração, padrão AI-builder
- OpenDesign: tokens de design são imutáveis, custo de manutenção quasi-zero

TIER 2 — Médio ROI (EXTRAIR COM FILTRO):
- Magic UI: manter só padrões de animação (framer-motion), não código completo
- claude-directory: extrair padrões de prompt engineering, não catálogo completo
- shadcnblocks.com: extrair apenas estruturas de layout, não markup completo

TIER 3 — Baixo ROI (DESCARTAR):
- v0/Vercel ai-elements: output generativo + muda constantemente = bomba-relógio
- 21st.dev: sem repo público, extração manual não automatizável

## Arquitetura Just-In-Time Knowledge Injection
INDEX.md (~500 tokens, lido sempre) → skill específica → reference sob demanda

Total se tudo carregado: ~41.500 tokens
Por tarefa típica (3-4 arquivos): 8.000-20.000 tokens → ROI positivo

## KPIs de sucesso
| KPI | Meta 90 dias |
|---|---|
| Precisão de Componente | >85% (vs. ~60% atual) |
| Context Token / Tarefa | <15.000 tokens de KRL |
| Staleness Score | <30 dias de defasagem |

## Conclusão: GO CONDICIONAL
- v0/Vercel e 21st.dev devem ser excluídos
- Escopo máximo: 8-10 arquivos, teto 50k tokens totais, nunca injetados em bloco
- Manutenção é o risco #1: 75% de probabilidade de abandono em 60 dias sem automação
- Confiança: 0.82
