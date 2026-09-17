# 📋 Proposal: Unificação de Workflows, Manual de Operação e Prevenção de Conflitos

## 1. Problema e Diagnóstico
O ecossistema Antigravity 2.0 passou por uma limpeza profunda (remoção de multi-agente descontrolado, expurgo de caches de 228MB, consolidação de skills). No entanto, falta um **ponto único de verdade operacional**:
1. Não existe um manual unificado em `docs/` explicando a operação ponta a ponta do ciclo SDD, do Council e dos Tokens Semânticos.
2. Riscos de conflitos e regressões de comandos: divergências entre aliases antigos (`/vibe-apply`, `/vibe-proposal`) e os comandos canônicos nativos (`/sdd-apply`, `/sdd-proposal`).
3. Ausência de documentação de prevenção de conflitos para que novas features não recriem ferramentas ou skills duplicadas.

## 2. Solução Proposta
1. **Unificação Total de Workflows:** Padronizar os comandos canônicos `/sdd-proposal`, `/sdd-apply`, `/sdd-archive`, `/sdd-debug` e `/council`, mantendo aliases compatíveis sem duplicação de arquivos.
2. **Manual de Operação Completo (`docs/manual-operacao-antigravity.md`):** Um guia técnico completo cobrindo:
   - Ciclo de Vida SDD e regras de transição (com Hard Stops explicados).
   - Uso cirúrgico do Graphify (Topologia de dependências e Blast Radius).
   - Guia prático de Theming Dark (como mudar para tudo preto sem quebrar cards).
   - Deliberação do Council sob demanda via `/council`.
   - Protocolo anti-regressão e regras de terminal.
3. **Prevenção de Conflitos & Anti-Duplicação:**
   - Catalogação formal no `specs/global/features.md`.
   - Atualização do script de deploy (`scripts/deploy-to-projects.ps1`) para distribuir a documentação e os workflows unificados para todos os projetos locais.

## 3. Skills Especializadas Aplicadas
- `sdd-proposal`: Metodologia de especificação física determinística.
- `github-ops`: Padronização de branches, commits e governança de repositório.
- `frontend-design-pro`: Regras semânticas e governança visual.

## 4. Contratos de Dados & Arquitetura
- **Documento Canônico:** `docs/manual-operacao-antigravity.md`
- **Catálogo Global:** `specs/global/features.md`
- **Índice de Skills:** `skills/INDEX.md`
- **Script de Sincronização:** `scripts/deploy-to-projects.ps1`

## 5. Arquivos Afetados
- `[NOVO]` `specs/spec-01-unified-workflows-and-manual/proposal.md`
- `[NOVO]` `specs/spec-01-unified-workflows-and-manual/design.md`
- `[NOVO]` `specs/spec-01-unified-workflows-and-manual/spec-plan.md`
- `[NOVO]` `specs/global/features.md`
- `[NOVO]` `docs/manual-operacao-antigravity.md`
- `[MODIFICADO]` `README.md` (Atualizado com links para o novo manual e arquitetura v7)
- `[MODIFICADO]` `scripts/deploy-to-projects.ps1` (Incluindo sincronização da pasta docs/)

## 6. Plano de Rollback
Se a unificação apresentar inconsistências:
- Reverter commit via `git checkout HEAD~1`.
- Restaurar `README.md` e `deploy-to-projects.ps1` prévios.
- Os arquivos `.md` criados em `specs/` e `docs/` não interferem no runtime de compilação.

## 7. Risco Principal e Mitigação
- **Risco:** Projetos legados dependerem de nomes antigos de comandos ou pastas deletadas.
- **Mitigação:** Mantidos aliases semânticos em `ia.md` (`/vibe-*` aponta para `/sdd-*`) para garantir compatibilidade retroativa total.