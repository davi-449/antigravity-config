---
name: sdd-apply
description: "Implementação SDD para Antigravity 2.0. O agente principal executa as tarefas sequencialmente, preserva mudanças anteriores, verifica cada tarefa no terminal e para antes do archive."
triggers: [apply, implementar spec, executar spec, codificar spec, sdd-apply, vibe-apply]
---

# ⚙️ SDD Apply — Implementação Rápida, Direta & Verificação Real

<skill>
<overview>
Executa o checklist de `specs/<id>/spec-plan.md` pelo agente principal. Implementa as tarefas de forma sequencial, verifica os critérios por terminal e finaliza com Hard Stop obrigatório.
</overview>

<guardrails>
- <rule type="execution">O agente principal edita e verifica. O `sdd-reviewer` pode examinar em leitura um contrato sensível ou diff incerto; não delegue a implementação nem trate seu parecer como validação. Não o acione em cada tarefa simples.</rule>
- <rule type="mandatory">A spec é a lei. Implemente estritamente o que foi acordado no proposal.md e design.md.</rule>
- <rule type="preserve_existing">Antes de editar, registre HEAD, `git status --porcelain=v1`, `git diff --binary` e `git diff --cached --binary`, além dos caminhos untracked. Preserve o index e todas as mudanças preexistentes. Se um caminho de implementação aprovado já tiver mudança staged, unstaged ou untracked, pare diante de sobreposição ambígua; não sobrescreva nem desfaça trabalho anterior. Os três documentos da spec aprovada são entrada do apply: registre seu conteúdo inicial e limite a edição de `spec-plan.md` ao progresso das tasks.</rule>
- <rule type="scope">Edite apenas os caminhos aprovados na spec. Se a solução exigir outro caminho ou contrato, pare, apresente a evidência e peça revisão da proposta antes de continuar.</rule>
- <rule type="save_state">Atualize o spec-plan.md: [- [/] In Progress] ao iniciar e [- [x] Completed] ao finalizar cada task.</rule>
- <rule type="budgets">Limites operacionais rígidos: max_auto_healing_attempts = 3; max_tool_calls_per_task = 15; max_total_retries = 5. Se o budget for atingido, documente a justificativa técnica, interrompa a execução e consulte o usuário.</rule>
- <rule type="loop_prevention">Loop Scorer: Se a mesma ação, patch ou ferramenta falhar 2 vezes de forma idêntica sem mudança de estado, aborte a repetição imediatamente como [LOOP_DETECTED].</rule>
- <rule type="safe_rollback">NUNCA execute 'git reset --hard' automaticamente sem autorização humana. Crie backup em .tmp/ antes de qualquer reversão.</rule>
- <rule type="circuit_breaker">PARADA OBRIGATÓRIA (HARD STOP) no final. Proibido auto-arquivar, commitar ou mover specs.</rule>
</guardrails>

<workflow_steps>
<step number="0" name="Leitura da Spec e Carregamento de Ambiente">
Leia rapidamente a spec em `specs/<id>/`:
1. `proposal.md` (problema, contratos de dados, arquivos afetados, plano de rollback)
2. `design.md` (interfaces TypeScript, happy path, edge cases, critérios de aceitação)
3. `spec-plan.md` (lista de tasks atômicas pendentes)

Registre o estado inicial do working tree **e do index** antes de qualquer mutação. Compare os caminhos de implementação aprovados com `git status --porcelain=v1`, com o diff unstaged, com o diff staged e com os caminhos untracked. Mudanças preexistentes fora do escopo ficam intactas. Os documentos em `specs/<id>/` podem estar untracked após o proposal; registre seu conteúdo inicial como entrada aprovada e não altere `proposal.md` ou `design.md` no apply. Se um caminho de implementação já estiver alterado ou a autoria dos trechos for ambígua, interrompa sem editar. Guarde esse baseline para comparar com o diff produzido pela tarefa; hash isolado não demonstra autoria.

Carregue variáveis do `.env` silenciosamente no terminal:
```powershell
$env:SUPABASE_ACCESS_TOKEN = "<valor do .env>"
$env:SUPABASE_PROJECT_ID   = "<valor do .env>"
$env:GH_TOKEN              = "<valor do .env>"
```
</step>

<step number="1" name="Execução Sequencial das Tasks">
Para cada task `- [ ] Pending` no `spec-plan.md`, confirme novamente o arquivo e os símbolos existentes, atualize para `- [/] In Progress` e execute apenas os caminhos aprovados. Se surgir dependência fora do escopo, pare e solicite revisão da proposta antes de tocá-la:

<domain type="Database">
Se envolver Banco/Supabase:
- Carregue: `skills/database/SKILL.md` (e `references/rls-patterns.md` se criar/editar policies).
- Inspecione as colunas existentes via SQL antes de criar novas.
- Escreva e aplique a migration em `supabase/migrations/<timestamp>_<nome>.sql`.
- Toda tabela DEVE ter RLS habilitado (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY`) e policy multi-tenant.
</domain>

<domain type="Backend">
Se envolver Server Actions / APIs / Auth:
- Carregue: `skills/backend-patterns/SKILL.md` (e `skills/auth/SKILL.md` se envolver sessão).
- Implemente Server Actions tipadas com retorno `ActionResult<T>` e schemas de validação Zod.
- Use `getUser()` no server (nunca `getSession()` para segurança).
- Aplique Taint Analysis defensiva (`skills/security/references/sentry-taint-analysis.md`): sanitize inputs de formulários antes de passar para queries ou mutações.
</domain>

<domain type="Frontend">
Se envolver Telas / Componentes React:
- Carregue: `skills/frontend-design-pro/SKILL.md` e `skills/ui-components/SKILL.md` (e `skills/ui-motion/SKILL.md` se houver animação).
- Respeite estritamente `DESIGN.md`: Dark UI sólida (Zinc-950), superfícies por luminância (dark.design), tipografia Inter/Outfit e `'use client'` apenas nas folhas interativas.
- Bloqueio ativo de AI Slop: proibido gradientes borrados com blur(100px), icon tile stacks repetitivos ou animações > 200ms.
- Siga os princípios de Rauno Freiberg (`skills/frontend-design-pro/references/interface-guidelines.md`) para inputs, dados e micro-interações.
</domain>

Após a edição, compare `git diff --binary` e `git diff --cached --binary` com o baseline: identifique o diff produzido pela tarefa e confira que o index e as mudanças preexistentes não mudaram. Execute o critério de verificação da task definido no `spec-plan.md`, registre comando, resultado e evidência. Só então marque `- [x] Completed`. Falha, teste ausente ou verificação impossível deixam a task pendente ou em progresso, com o motivo explícito.
</step>

<step number="2" name="Auto-Healing, Loop Detection & Safe Rollback">
Se ocorrer erro de compilação ou teste durante a task:
- **Loop Check:** Ação repetida idêntica sem evolução de erro? Se SIM, PARE imediatamente: emita `[LOOP_DETECTED]` e consulte o usuário.
- **Tentativa 1 (Budget 1/3):** Correção direta na causa raiz revisando o `design.md` e logs do erro.
- **Tentativa 2 (Budget 2/3):** Abordagem alternativa documentada com hipótese técnica explícita.
- **Tentativa 3 (Budget 3/3):** Tentativa final isolada. Se falhar:
  - **PROIBIDO:** `git reset --hard` automático desassistido.
  - **Safe Rollback Protocol:**
    1. Execute `git status --short`; preserve separadamente o diff inicial, o diff produzido pela tarefa e o estado inicial do index em `.tmp/rollback_backup_<timestamp>/`. Nunca trate o diff total como se fosse da tarefa.
    2. Registre o log forense do erro em `.tmp/rollback_backup_<timestamp>/error_log.txt`.
    3. Notifique o usuário com a causa do bloqueio, o caminho do backup criado e solicite autorização explícita antes de descartar modificações.
</step>

<step number="3" name="Quality Gate Rápido via Terminal (Build, Testes & Segurança)">
1. **Verificação via Terminal:**
   - **PROIBIDO:** Abrir navegadores, rodar Playwright, tirar screenshots ou inicializar dev servers para inspeção de tela no apply. Isso elimina latência, lentidão desnecessária e alucinações de renderização.
   - Nesta fase, o agente opera no terminal:
     `[VISUAL_QA_OFFLINE]: Testes de UI via browser/Playwright desativados por design. Verificação 100% focada em gates rápidos de terminal (build, typecheck, lint).`
   - **PROIBIDO:** Declarar que o Visual QA passou lendo apenas arquivos HTML/CSS estáticos.
   - A avaliação visual de telas pertence exclusivamente ao desenvolvedor humano no navegador em localhost antes de aprovar com `/vibe-archive`: marque como `[HUMAN_REVIEW_PENDING]`.
2. **Build & Typecheck Gate (Terminal Rápido):**
   Execute a compilação no terminal para garantir zero erros de TypeScript e zero quebras de bundling:
   ```bash
   cmd.exe /c "npm run build"
   ```
   Execute também os testes exigidos pelos critérios de cada task. Testes unitários adicionais de backend/lógica continuam opcionais (`npm test -- --passWithNoTests`), mas `--passWithNoTests` não comprova um critério que exigia teste executado.
3. **Security Gate (Pre-Commit Secrets Blocker & Cadência de Auditoria):**
   - **Bloqueador Rígido de Segredos:** Inspecione os arquivos modificados. Se encontrar chaves reais (OpenAI `sk-`, Stripe `sk_live_`, Supabase `service_role`, AWS keys), **BLOQUEIE IMEDIATAMENTE**:
     `[SECURITY_BLOCKER]: Segredo detectado em <arquivo>. Remova credenciais e use variáveis de ambiente antes de continuar.`
   - **Cadência Preventiva (a cada 5 a 10 applies):**
     Emita no resumo final o alerta:
     ```text
     ================================================================================
      🛡️ [SECURITY HEALTH CHECK REMINDER]
      Múltiplas implementações foram concluídas neste repositório.
      Recomendado rodar uma auditoria preventiva de segurança:
        👉 /secrets-audit     -> Verificar se nenhuma chave vazou
        👉 /dependency-audit  -> Checar CVEs em dependências
        👉 /security-review   -> Auditar IDOR e autorização (AuthZ)
     ================================================================================
     ```
</step>

<step number="4" name="Conclusão e Hard Stop Obrigatório">
Apresente em português simples o que mudou, o que foi testado e o que ficou pendente. Use `[AUDIT_PASSED]` somente quando todas as verificações exigidas tiverem passado; inclua o comando e o resultado.

<hard_stop>
<directive>
PARE IMEDIATAMENTE AQUI.
- NÃO inicie o archive sob nenhuma hipótese.
- NÃO execute git commit ou git push.
- NÃO mova pastas de specs/ para specs/archive/.
- Finalize sua resposta exclusivamente informando:
  "Implementação <id> concluída. Confira o resumo dos testes e teste no navegador se houver tela. Quando aprovar, peça /vibe-archive <id> (ou /sdd-archive <id>)."
</directive>
</hard_stop>
</step>
</workflow_steps>
</skill>
