---
description: Executa a implementação técnica baseada nos arquivos de spec gerados no /vibe-proposal, usando skills especialistas por tipo de task, VLM visual QA e auto-healing com rollback.
---

<!-- VIBEAPPLY:START -->

> ⛔ **OVERRIDE SUPREMO:** Se o usuário mencionar `/teamwork-preview`, delegar para equipe ou pedir análise conjunta, PARE IMEDIATAMENTE. Acione os subagentes via `invoke_subagent`. NUNCA ignore um pedido de delegação.

**Objetivo**
Executar o checklist definido em `specs/<id>/spec-plan.md` com extrema precisão, usando o máximo das capacidades técnicas das skills especialistas. A spec é a lei — não improvise, não extrapole.

---

**Step 0 — Leitura Obrigatória Antes de Qualquer Ação**

1. Abra e leia `specs/<id>/spec-plan.md` — este é o seu mapa. Nenhuma ação começa sem ele.
2. Leia a memória modular relevante em `.agent/memory/` (ex: `memory/supabase.md`, `memory/ui.md`).
3. Se envolver módulos existentes, execute `graphify explain "<Modulo>"` para entender dependências antes de editar.
4. Carregue silenciosamente as credenciais do `.env`:
   - `$env:SUPABASE_ACCESS_TOKEN = "<token do .env>"`
   - `$env:GH_TOKEN = "<token do .env>"`
   - **É EXTREMAMENTE PROIBIDO pedir para o usuário fazer login ou rodar comandos de autenticação.**

---

**Step 1 — Execução por Tipo de Task**

Para cada item do `spec-plan.md`, identifique o tipo e ative as skills correspondentes:

**Frontend (UI/React/Tailwind):**
- Invoque `frontend-design-pro`, `frontend-design-3` e `afrexai-nextjs-production`
- Respeite SEMPRE as restrições visuais: Dark UI sólido (Zinc-950, `#050711`), sem glassmorphism
- Componentes novos devem ser isolados — verifique `spec/global/features.md` para não duplicar
- Nunca renomeie props ou quebre API pública sem necessidade explícita na spec

**Backend (Supabase, Edge Functions, RPCs, Migrations):**
- Invoque skills `backend` e `supabase`
- RLS obrigatório em toda tabela nova
- Nunca crie tabela, RPC ou policy sem verificar o que já existe no banco
- Use sempre `SUPABASE_SERVICE_ROLE_KEY` para webhooks e operações privilegiadas

**Infra/Deploy:**
- Leia `.antigravity/state.json` para entender o impacto (UI only, app+backend, infra only)
- Se `supabase.mode=self_hosted_vps`: acesso via SSH remoto, nunca container local
- Configure DNS Cloudflare via API se necessário

---

**Step 2 — Atualização do Save-State**

À medida que executa cada item do `spec-plan.md`:
- Marque `- [/] In Progress` ao iniciar
- Marque `- [x] Completed` ao concluir
- Se o contexto resetar no meio da execução, a IA relê o arquivo e retoma pelo primeiro `[/]` ou `[ ]`

---

**Step 3 — Auto-healing & Proteção**

Se ocorrerem erros de build, testes falhando ou falhas de lógica:
- **Limite Categórico:** Exatamente **3 tentativas** de correção
- **Rollback:** Se a 3ª tentativa falhar, execute `git reset --hard` imediatamente
- Notifique o usuário da falha estrutural e solicite reavaliação — **NÃO tente uma 4ª vez**
- Anote o erro no `spec-plan.md` para análise posterior

---

**Step 4 — VLM Visual QA (Se mudou UI/Frontend)**

É **PROIBIDO** dizer "não tenho olhos" se a mudança impactou visualmente.

1. Acesse a URL de preview ou `localhost:5173` com Playwright:
   `npx playwright screenshot <url> tela.png`
2. Se a rota for protegida, recupere as credenciais de teste do `.env` isolado e faça login
3. Leia a imagem gerada e analise:
   - O CSS vazou? Há contraste ruim?
   - Z-index quebrou algum componente?
   - A paleta Zinc-950 foi respeitada?
4. Se encontrar problemas estéticos, corrija antes de marcar o step como finalizado

---

**Conclusão**

Quando todos os itens do `spec-plan.md` estiverem `[x] Completed`, avise o usuário e instrua:
*"Implementação concluída. Rode `/vibe-archive <id>` para finalizar."*

<!-- VIBEAPPLY:END -->
