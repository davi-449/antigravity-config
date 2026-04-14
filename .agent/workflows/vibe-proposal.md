---
description: Levantar requisitos e criar uma Master Spec guiada por Spec-Kit sem escrever código.
---

<!-- OPENSPEC:START -->

**Guardrails**

- NÃO escreva código nesta fase. Seu objetivo é apenas gerar documentação de planejamento.
- Pergunte ao usuário sobre regras de negócios ou design (caso não fornecido) antes de fechar o spec.
- Siga as regras de `.agent/rules/ia.md` — ESPECIALMENTE a Regra Anti-Alucinação (seção 2).

**Steps**

1. Crie ou identifique o ID da funcionalidade (ex: `001-auth`).
2. **PESQUISE PRIMEIRO o que já existe no projeto** relacionado à funcionalidade pedida:
   - `grep_search` em componentes, hooks, páginas
   - `list_tables` via Supabase MCP
   - `view_file_outline` nos arquivos relevantes
3. Avalie o contexto atual do projeto, analise pedidos do usuário e identifique lacunas.
4. Crie `specs/<id>/proposal.md` detalhando:
   - Requisitos e User Stories
   - **O que JÁ EXISTE e será REUTILIZADO** (componentes, hooks, tabelas)
   - O que precisa ser CRIADO (apenas o que realmente não existe)
   - Critérios de Aceite
5. Crie `specs/<id>/design.md`:
   - Como a UI será dividida (Stitch MCP para >200 linhas JSX, Antigravity para integração)
   - Como o banco será modelado (Supabase MCP)
   - **Mapa de dependências** — o que novo depende do que existente
6. Crie `specs/<id>/tasks.md` — checklist sequencial de tarefas granulares.
7. Valide a coerência dos documentos e peça aprovação do usuário via `notify_user`.

**Reference**

- Baseie os componentes de UI em Shadcn UI (`src/components/ui/`).
- Baseie as decisões de backend em PostgreSQL (via Supabase MCP).
- Consulte `baseconhecimento/` para contexto adicional.

<!-- OPENSPEC:END -->
