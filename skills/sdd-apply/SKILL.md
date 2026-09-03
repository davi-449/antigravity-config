---
name: sdd-apply
description: "Implementação técnica determinística da Spec para Antigravity 2.0. Suporta modo Equipe (Frontend, Backend, DB, Validator e Auditor Agents) e modo Solo, com auto-healing em 3 tentativas, Visual QA e Hard Stop final."
triggers: [apply, implementar spec, executar spec, codificar spec, sdd-apply]
---

# ⚙️ SDD Apply — Implementação Determinística & Auditoria de Qualidade

<skill>
<overview>
Executa o checklist de `specs/<id>/spec-plan.md` com rigor absoluto. A spec é a lei — não improvise, não altere contratos sem aprovação. Suporta modo Equipe (orquestrado com subagentes especializados e portão de auditoria de 7 dimensões) e modo Solo (execução direta sequencial).
</overview>

<guardrails>
- <rule type="mandatory">A spec é a lei. Implemente exatamente o que foi acordado no proposal.md e design.md.</rule>
- <rule type="save_state">Atualize o spec-plan.md continuamente: [- [/] In Progress] ao iniciar e [- [x] Completed] ao finalizar cada task.</rule>
- <rule type="circuit_breaker">PARADA OBRIGATÓRIA (HARD STOP) no final. Proibido auto-arquivar, commitar ou mover specs sem comando do usuário.</rule>
</guardrails>

<modes>
<mode name="Solo" command="/vibe-apply-solo">
Indicado para correções pontuais, pequenos ajustes e desenvolvimento direto:
1. O agente lê a spec (`proposal.md`, `design.md`, `spec-plan.md`) e injeta variáveis de ambiente silenciosamente.
2. Executa cada task pendente sequencialmente (DB -> Backend -> Frontend).
3. Auto-healing em caso de falhas de compilação ou testes (máximo 3 tentativas; se falhar, `git reset --hard HEAD`).
4. Executa VLM Visual QA via Playwright caso toque em UI.
5. Roda `npm run build` local para garantir integridade de compilação.
6. Encerra no `<hard_stop>` aguardando o usuário testar a aplicação.
</mode>

<mode name="Team" command="/vibe-apply" alias="/vibe-apply-team">
Indicado para módulos completos e desenvolvimento orquestrado com auditoria avançada:
1. O Orchestrator lê a spec e carrega a memória Obsidian necessária.
2. Agrupa tasks por domínio e despacha para os subagentes especializados com prompts enriquecidos:
   - Tasks [DB] -> `database-agent` (com `skills/database/` e `memory/supabase.md`)
   - Tasks [BACKEND] -> `backend-agent` (com `skills/backend-patterns/`, `skills/auth/` e `memory/auth.md`)
   - Tasks [FRONTEND] -> `frontend-agent` (com `skills/ui-components/`, `skills/ui-motion/` e `memory/ui.md`)
3. Submete os relatórios consolidados ao **Validator Agent**.
4. Aciona o **Bug Agent** automaticamente se houver erros de runtime ou testes.
5. Executa o **Auditor Agent** no Step 7 para avaliar as 7 Dimensões (Spec, Grafo, Build, Segurança, Memória, UI, Limpeza).
6. Encerra no `<hard_stop>` quando o Auditor emitir `[AUDIT_PASSED 🟢]`.
</mode>
</modes>

<auto_healing>
<protocol>
Se ocorrer erro de compilação, TypeScript ou teste:
- Tentativa 1: Correção cirúrgica na causa raiz revisando interfaces no design.md.
- Tentativa 2: Abordagem alternativa documentada.
- Tentativa 3: Se persistir o erro na 3ª tentativa, execute imediatamente:
  `git reset --hard HEAD`
  Pare a execução, alerte o usuário com diagnóstico completo e NUNCA tente uma 4ª vez.
</protocol>
</auto_healing>

<visual_qa>
<directive>
Se a task tocou em qualquer tela ou componente React:
1. Execute: `npx playwright screenshot <url-local> screenshot.png`
2. Inspecione visualmente a imagem: verifique paleta Zinc-950, alinhamento, ausência de CSS quebrado e contraste.
3. Corrija qualquer defeito visual antes de marcar a task como concluída.
</directive>
</visual_qa>

<hard_stop>
<directive>
Quando todas as tasks do spec-plan.md estiverem [x] Completed e o build/auditoria passar:
1. NÃO inicie o sdd-archive ou vibe-archive automaticamente.
2. NÃO execute git commit, git push ou git add.
3. NÃO mova pastas de specs/ para specs/archive/.
4. NÃO escreva nos arquivos de memória .agent/memory/ dentro do apply.
5. Finalize sua resposta informando:
   "Implementação concluída com sucesso! Por favor, teste a aplicação no seu ambiente. Quando estiver pronto para arquivar e commitar, envie: /vibe-archive <id> (ou /sdd-archive <id>)."
</directive>
</hard_stop>
</skill>
