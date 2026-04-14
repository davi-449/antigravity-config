---
description: Implementar uma especificação aprovada orquestrando Stitch MCP, Supabase MCP e Antigravity.
---

<!-- OPENSPEC:START -->

**Guardrails**

- Só inicie se houver um diretório `specs/<id>/` válido e aprovado.
- **NUNCA crie componente/tabela/hook novo sem antes pesquisar se já existe** (Regra Anti-Alucinação, ia.md seção 2).
- Se algo der errado, conserte o que existe — NÃO crie workarounds com código novo.
- Siga rigorosamente o checklist em `specs/<id>/tasks.md`.

**Steps**

1. Leia a master spec: `proposal.md`, `design.md` e `tasks.md` do diretório `specs/<id>/`.

2. **Fase 0 — Inventário (OBRIGATÓRIA):**
   - Rode `list_tables` (Supabase MCP) para confirmar o estado atual do banco.
   - Rode `grep_search` para confirmar que componentes mencionados no spec realmente existem.
   - Se algo do spec estiver desalinhado com a realidade, **pare e avise o usuário**.

3. **Fase 1 — Frontend (Stitch MCP + Antigravity):**
   - Se o design envolve telas NOVAS com >200 linhas JSX: use `generate_screen_from_text` (Stitch MCP).
   - Se é ajuste/refatoração de tela existente: Antigravity edita diretamente.
   - Se é integração (conectar UI a dados): Antigravity faz hooks/estado.

4. **Fase 2 — Backend (Supabase MCP):**
   - Crie migrações com `apply_migration`.
   - Implemente RLS policies para tabelas novas.
   - Atualize tipagens: `generate_typescript_types`.

5. **Fase 3 — Integração (Antigravity):**
   - Conecte UI gerada (Fase 1) com backend tipado (Fase 2).
   - Crie hooks apenas se NÃO existir equivalente em `src/hooks/`.
   - Resolva lint e garanta tratamento de erros.

6. **Fase 4 — Verificação:**
   - Rode `vite build` para confirmar que compila.
   - Teste no browser com `/crm-test` workflow (login automático).
   - Tire screenshots de evidência.

7. Marque progressivamente os itens do `tasks.md` como `[x]`.
8. Ao finalizar, notifique o usuário da conclusão.

**Reference**

- Não sobrescreva componentes existentes sem necessidade. Crie wrappers/hooks em volta deles.
- Mantenha Edge Functions do Supabase em `supabase/functions/`.
- Quando reverter erros: simplifique, não adicione complexidade.

<!-- OPENSPEC:END -->
