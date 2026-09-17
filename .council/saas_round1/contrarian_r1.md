# CONTRARIAN — Round 1

## STRONG NO-GO (confiança: 0.85)

### FALHA FATAL #1 — O sistema é o Context Bloat
Você quer injetar SKILL.md de 8 repositórios antes de cada geração.
Um único SKILL.md razoável = 2.000-4.000 tokens.
8 fontes = 16.000-32.000 tokens antes de uma linha de código.
Não existe "navegação inteligente" que resolva Context Bloat estrutural.

### FALHA FATAL #2 — KRL vira legado em 60 dias
shadcn/ui muda toda semana. v0 da Vercel muda paradigmas a cada ciclo.
Quem vai monitorar 8 repositórios, extrair mudanças, atualizar SKILL.md e testar?
Ninguém. Em 6 meses o KRL injeta confiança falsa em APIs deprecadas.
KRL estático sobre ecossistemas de rápida evolução = desinformação garantida.

### FALHA FATAL #3 — Diagnóstico errado do problema
O limitante atual NÃO é falta de conhecimento de componentes UI.
Os gargalos reais são:
- Lógica de negócio específica do domínio
- State management correto (useEffect hell, race conditions)
- Segurança e validação de dados
- Integração com sistemas legados
Nenhum SKILL.md de shadcn resolve isso.

### FALHA FATAL #4 — Conflitos de autoridade não gerenciáveis
shadcn diz "use <Button variant='outline'>"
Magic UI diz "prefira <MagicButton glow={true}>"
Qual o agente escolhe? Múltiplas fontes sem árbitro = ruído, não conhecimento.

### FALHA FATAL #5 — Você está reinventando RAG e de forma inferior
O que você descreve é RAG manual e artesanal.
MCP com acesso a repositórios ao vivo, contexto estendido do Gemini,
apontar o agente para docs oficiais em runtime — isso já existe e é dinâmico.
KRL estático vai ser obsoleto no próximo release de contexto longo.

## Tabela resumo
| Promessa | Realidade |
|---|---|
| Evitar Context Bloat | O sistema É o Context Bloat |
| Knowledge sempre atual | Legado desatualizado em 60 dias |
| Agente "Full-Stack Builder" | Problema real não é falta de SKILL.md |
| Camadas bem definidas | Conflitos de autoridade sem árbitro |
| Inovação arquitetural | RAG manual inferior ao que já existe |

## Alternativa (único caminho viável)
IA consumir código vivo via RAG dinâmico que leia src/ diretamente,
ou script que auto-gere AST e metadados em Build-Time.
Sem toque humano nas regras = sem drift.
