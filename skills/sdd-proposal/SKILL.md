---
name: sdd-proposal
description: "Planejamento e especificação física determinística (SDD) para Antigravity 2.0. Inspeciona código legado, consulta memória Obsidian e Grafo, suporta modos Equipe e Solo, gerando proposal.md, design.md e spec-plan.md com Hard Stop obrigatório."
triggers: [proposal, planejar feature, criar spec, planejar, sdd-proposal, especificação]
---

# 📋 SDD Proposal — Planejamento Determinístico & Anti-Alucinação

<skill>
<overview>
Transforma requisitos do usuário em uma especificação física completa em `specs/<id>/` antes de qualquer linha de código. Suporta modo Equipe (com Research e Validator Agents) e modo Solo (direto por um único agente).
</overview>

<guardrails>
- <rule type="prohibition">NÃO ESCREVA CÓDIGO de implementação nesta fase. Seu único output são arquivos .md em specs/.</rule>
- <rule type="mandatory">Inspecione o código legado e a memória Obsidian ANTES de propor. Zero suposições de tipos.</rule>
- <rule type="circuit_breaker">PARADA OBRIGATÓRIA (HARD STOP) no final. Proibido auto-engatar o apply.</rule>
</guardrails>

<modes>
<mode name="Solo" command="/vibe-proposal-solo">
Indicado para tarefas pontuais, correções de bugs, refatores locais e quando se busca agilidade sem overhead de subagentes.
1. O próprio agente lê `skills/adaptive-reasoning/SKILL.md` e `skills/obsidian/SKILL.md`.
2. Lê as memórias relevantes em `.agent/memory/`.
3. Executa `graphify query` e `graphify explain`.
4. Inspeciona o código legado via AST Skeleton (`view_file` para extrair interfaces reais).
5. Escreve diretamente `specs/<id>/proposal.md`, `design.md` e `spec-plan.md`.
6. Encerra no `<hard_stop>`.
</mode>

<mode name="Team" command="/vibe-proposal" alias="/vibe-proposal-team">
Indicado para features completas, novos módulos e arquiteturas full-stack.
1. O Orchestrator lê `adaptive-reasoning` e a memória Obsidian.
2. Lança **Research Agents** por domínio (`frontend`, `backend`, `banco`) com skills e memória injetadas no prompt.
3. Consolida os relatórios de pesquisa e escreve os 3 arquivos de spec.
4. Lança o **Validator Agent** para revisar conformidade, dependências e tipos.
5. Encerra no `<hard_stop>`.
</mode>
</modes>

<phases>
<phase number="0" name="Leitura de Memória e Grafo">
Antes de redigir qualquer especificação:
- Leia a memória relevante: `memory/ui.md`, `memory/supabase.md`, `memory/auth.md`, `memory/domain.md`.
- Rastreie dependências estruturais:
```bash
graphify query "<feature>"
graphify explain "<modulo-central>"
```
- Inspecione arquivos legados com `view_file` para extrair interfaces TypeScript e formatos de retorno reais.
</phase>

<phase number="1" name="Bloqueio Anti-Duplicação">
Cruze as descobertas com `spec/global/features.md` e a memória Obsidian:
Se a tabela, hook, componente ou RPC já existe no projeto: **BLOQUEADO.** Reutilize o código canônico existente ou crie uma extensão mínima.
</phase>

<phase number="2" name="Estrutura da Spec (Tríade SDD)">
Gere os 3 arquivos em `specs/<id>/`:
1. `proposal.md`: Problema real, solução proposta, contratos de dados, dependências e risco principal mitigado.
2. `design.md`: Arquitetura de fluxo, interfaces TypeScript copiadas do legado, lista de artefatos e 2 cenários de verificação (SCAN -> INFER -> VERIFY -> FIX).
3. `spec-plan.md`: Lista atômica de tasks marcadas estritamente como `- [ ] Pending`.
</phase>
</phases>

<hard_stop>
<directive>
Ao concluir a apresentação do resumo da Spec ao usuário:
1. NÃO chame nenhuma ferramenta adicional.
2. NÃO edite nenhum arquivo fora de specs/.
3. NÃO marque nenhuma task como [/] ou [x].
4. NÃO inicie o apply automaticamente.
5. Finalize sua resposta exclusivamente informando:
   "Especificação da Spec <id> concluída. Aguardando sua aprovação. Para implementar, digite /vibe-apply <id> (ou /vibe-apply-solo <id>)."
</directive>
</hard_stop>
</skill>
