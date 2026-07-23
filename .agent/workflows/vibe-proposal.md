---
description: Transformação de requisitos em uma Especificação física (SDD) antes de qualquer linha de código, com pesquisa profunda, bloqueio de duplicações e save-state para memória contínua.
---

<!-- OPENSPEC:START -->

> ⛔ **OVERRIDE SUPREMO:** Se o usuário mencionar `/teamwork-preview`, delegar para equipe ou pedir análise conjunta, PARE IMEDIATAMENTE. Acione os subagentes via `invoke_subagent`. NUNCA ignore um pedido de delegação para continuar codando sozinho.

**Guardrails**

- **NÃO ESCREVA CÓDIGO** nesta fase em nenhuma circunstância. Seu único objetivo é estruturar o projeto em arquivos `.md`.
- **DEEP RESEARCH ANTES DE QUALQUER COISA:** Use ferramentas simultâneas (`grep_search` + `list_dir`) para varrer o projeto. ZERO SUPOSIÇÕES sobre arquivos que não estão abertos.
- **Context Budgeting:** Para arquivos muito grandes, leia apenas assinaturas de funções, types/interfaces e exports. Não leia a implementação completa desnecessariamente.

---

**Phase 1: Leitura de Memória e Estado Global**

1. **Ler Memória Modular:** Leia os arquivos relevantes dentro de `.agent/memory/` (ex: `memory/supabase.md`, `memory/ui.md`, `memory/ofx.md`). Se não existirem ainda, leia o `.agent/memory.md` geral.
2. **Varredura da Codebase:** Execute `grep_search` e `list_dir` para mapear o que já existe.
3. **Consulta ao Grafo (Graphify):** Se o `graphify-out/graph.json` existir, execute:
   - `graphify query "<feature ou módulo>"` para listar conexões reais
   - `graphify explain "<Modulo>"` para entender dependências antes de propor mudanças
4. **Criar/Validar `spec/global/`:** Garanta que estes arquivos existem e estão atualizados:
   - `spec/global/overview.md` — Visão geral do projeto
   - `spec/global/architecture.md` — Arquitetura global
   - `spec/global/features.md` — **MAPA DE FEATURES EXISTENTES** (leia isso antes de propor qualquer coisa nova)
   - `spec/global/constraints.md` — Regras imutáveis do projeto

5. **Bloqueio Anti-Duplicação:** Leia `spec/global/features.md`. Se o componente, hook, tabela ou lógica que você planeja criar JÁ EXISTE → **BLOQUEADO**. Use o existente ou crie um wrapper. Nunca duplique.

---

**Phase 2: Criação dos Arquivos de Especificação (A Âncora Física)**

Com base na pesquisa, crie os arquivos da spec para a feature atual:

**`specs/<id>/proposal.md`**
- O problema que estamos resolvendo e por quê
- Limites da API, contratos de dados, mutações de estado
- Features existentes que serão impactadas (ref ao `features.md`)
- Estratégia de integração (Supabase, RLS, Edge Functions, etc.)

**`specs/<id>/design.md`**
- Arquitetura técnica detalhada
- Fluxo de dados ponta a ponta
- Interfaces TypeScript/tipos relevantes
- Se envolver UI: guarda as restrições visuais (Zinc-950, sem glassmorphism, etc.)
- Se envolver Infra/Deploy: topologia explícita (`app.<dominio>`, `api.<dominio>`, etc.)

**`specs/<id>/spec-plan.md`** ← O Save-State da Memória
- Checklist atômico e sequencial de todas as tasks
- Use ESTRITAMENTE os estados: `- [ ] Pending` / `- [/] In Progress` / `- [x] Completed`
- Este arquivo é a âncora de continuidade: se o contexto resetar, a IA relê e retoma aqui

---

**Phase 3: Análise de Risco**

- Use `deciqai-bayesian-reasoning` e `adaptive-reasoning` para fazer um "dry-run" mental da lógica
- Identifique efeitos colaterais: o que pode quebrar? Qual a tabela/rota mais frágil?
- Documente o maior risco no `proposal.md`

---

**Phase 4: Aprovação**

- Apresente o resumo da spec ao usuário
- **NÃO INICIE O `/vibe-apply` SEM APROVAÇÃO EXPLÍCITA**
- Quando aprovado, instrua: *"Rode `/vibe-apply <id>` para implementar."*

## Infra topology proposal

Quando a proposta envolver deploy, domínio ou backend, sempre propor explicitamente:
- Frontend publicado (ex: Lovable)
- Topologia de subdomínios: `app.<dominio>`, `api.<dominio>`, `studio.<dominio>`
- Backend (ex: Supabase self-hosted na VPS)
- Variáveis de ambiente necessárias (`VITE_SUPABASE_URL`, etc.)
- Nunca deixe "deploy" ou "database" implícitos

## Visual QA Planning

Se o projeto for Frontend/Web com rotas protegidas por login, adicione na proposta:
- Exigência de que o usuário forneça credenciais de teste (email/senha)
- Salvar no `.env` isolado da IA para uso no VLM Loop do `/vibe-apply`

<!-- OPENSPEC:END -->
