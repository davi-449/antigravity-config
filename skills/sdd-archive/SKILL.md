---
name: sdd-archive
description: "Conclusão definitiva do ciclo SDD para Antigravity 2.0 — Quality Gate de build, escrita obrigatória na memória Obsidian por categoria, elevação de regras universais /learn, atualização do grafo e commit controlado."
triggers: [archive, arquivar spec, commitar spec, finalizar feature, sdd-archive, vibe-archive]
---

# 📦 SDD Archive — Consolidação de Memória, Grafo & Commit

<skill>
<overview>
Conclui o fluxo da Spec garantindo que a entrega não quebrou o build, registrando o conhecimento adquirido na memória persistente Obsidian por categoria, atualizando o grafo de dependências e efetuando o commit controlado no repositório.
</overview>

<guardrails>
- <rule type="mandatory">Build obrigatório. Se o build falhar, é proibido commitar ou arquivar.</rule>
- <rule type="mandatory">Escrita de memória obrigatória. NUNCA pule o registro de lições na memória modular.</rule>
- <rule type="prohibition">TERMINANTEMENTE PROIBIDO usar 'git add .' ou staging indiscriminado.</rule>
- <rule type="prohibition">JAMAIS use git push --force.</rule>
- <rule type="safety">Bloqueio ativo de segredos e voláteis: PROIBIDO incluir no staging .env*, *.pem, *.key, *.dump, backups SQL e diretórios .tmp/.</rule>
- <rule type="staging_allowlist">Staging estritamente seletivo: apenas arquivos pertencentes à allowlist do escopo (specs/archive/, .agent/memory/, graphify-out/ e caminhos específicos de código validados).</rule>
- <rule type="preserve_index">No início, registre `git status --porcelain=v1` e `git diff --cached --binary`. Se o index já contiver mudanças staged, pare antes de adicionar, desfazer, arquivar ou commitar: não misture a entrega com staging preexistente.</rule>
</guardrails>

<steps>
<step number="1" name="Quality Gate & Pre-Archive Audits (Build & Segurança)">
0. **Baseline de Git:** Registre HEAD, status, diff unstaged e diff staged. Identifique mudanças preexistentes e os caminhos produzidos pela spec. Se houver staging preexistente ou autoria ambígua em um caminho da entrega, interrompa sem alterar o index.
1. **Build Gate:**
   Execute o build completo da aplicação para garantir compilação limpa e zero erros de TypeScript:
   ```bash
   cmd.exe /c "npm run build"
   ```
   Se o build falhar, pare a execução imediatamente. O archive é proibido em código com erro de compilação.

2. **Pre-Commit Security & Secrets Audit:**
   Execute a varredura rápida de credenciais nos arquivos modificados:
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/security-audit.ps1
   ```
   Se qualquer segredo for detectado, o commit é BLOQUEADO.
</step>

<step number="2" name="Escrita na Memória Modular Obsidian">
Leia `skills/obsidian/SKILL.md`. Identifique a categoria de conhecimento gerada e grave no arquivo correspondente em `.agent/memory/`:
- `memory/ui.md`: Componentes criados, convenções visuais, seletores Tailwind.
- `memory/supabase.md`: Tabelas novas, RPCs, regras de RLS, triggers.
- `memory/auth.md`: Sessões, tokens, middlewares de proteção.
- `memory/infra.md`: Configurações de VPS, Cloudflare, domínios, deploy.
- `memory/domain.md`: Lógica e regras de negócio do produto.

<template>
```markdown
## [YYYY-MM-DD] — [Feature ID: <id>]

**Contexto:** O que foi implementado e qual problema resolvia.
**Regra aprendida:** A lógica crítica que não pode ser esquecida.
**Risco identificado:** O que quase quebrou ou pode quebrar no futuro.
**Não fazer:** Anti-pattern explicitamente identificado.
```
</template>
</step>

<step number="3" name="Self-Annealing & Elevação para a Constituição (/learn)">
Avalie: *"Algum comportamento da IA gerou erro que não deve se repetir em NENHUM projeto futuro?"*
- Se SIM: Proponha ao usuário e, com aprovação, injete a regra universal em `.agent/rules/ia.md`.
- Se NÃO: Registre explicitamente que nenhum guardrail universal foi identificado nesta iteração.
</step>

<step number="4" name="Atualização do Grafo Topológico">
Reindexe os arquivos modificados para manter o grafo 100% sincronizado com a realidade do código:
```bash
graphify update
```
</step>

<step number="5" name="Atualização do Mapa Global de Features">
Adicione os artefatos novos criados nesta iteração em `specs/global/features.md`:
- Componentes e hooks novos
- Tabelas e RPCs novas
- Regras de negócio implementadas
Isso alimenta o bloqueio anti-duplicação das próximas propostas.
</step>

<step number="6" name="Arquivamento da Spec">
Confirme que `specs/<id>` existe e `specs/archive/<id>` **não** existe. Se o destino estiver ocupado, pare sem mover nada. Só então mova a pasta de spec ativa para o diretório de histórico:
```powershell
Move-Item "specs/<id>" "specs/archive/<id>"
```
</step>

<step number="6.1" name="Preservação de Artefatos Fora da Entrega">
Não apague `.tmp/`, `*.bak`, logs ou outros arquivos sem origem verificada. Backups de apply podem estar em `.tmp/`. Exclua esses caminhos do staging. O cache bruto de AST (`graphify-out/cache/`) também fica fora do commit; inclua somente arquivos consolidados do grafo que tenham sido produzidos por esta entrega.
</step>

<step number="7" name="Staging Seletivo & Commit Controlado">
1. **Inspeção Pré-Staging Obrigatória:**
   ```bash
   git status --short
   ```
2. **Filtro Anti-Vazamento:**
   - Verifique que NENHUM arquivo `.env*`, `*.pem`, `*.key`, `*.dump` ou `.tmp/` está na lista.
   - Inspecione `git diff --cached` em busca de padrões de chaves reais (OpenAI, Stripe, Supabase service keys).
3. **Staging Seletivo por Caminho da Entrega (PROIBIDO git add .):**
   Derive a lista exata dos arquivos da spec aprovada e dos artefatos realmente produzidos neste archive. Inclua os caminhos antigos e novos da spec movida. Um diretório permitido não autoriza adicionar todos os seus arquivos. Compare cada caminho com o baseline e pare se a autoria for ambígua.
   ```bash
   git add -A -- "specs/<id>/<arquivo_específico_rastreado_antes_do_move>" "specs/archive/<id>/<arquivo_específico>"
   git add -- ".agent/memory/<arquivo_modificado_nesta_entrega>"
   git add -- "graphify-out/<arquivo_consolidado_modificado_nesta_entrega>"
   git add -- "src/<caminho_específico>" "supabase/migrations/<caminho_específico>"
   ```
   Os exemplos acima são placeholders: inclua o caminho antigo somente se já era rastreado pelo Git e adicione somente caminhos da lista exata. Nunca inclua uma mudança preexistente no mesmo arquivo sem separar seus hunks com segurança; se não conseguir, pare.
4. **Inspeção do Staged Diff & Commit:**
   ```bash
   git status --short
   git diff --cached --name-status
   git diff --cached --check
   git diff --cached
   git commit -m "feat(<id>): <resumo do que foi implementado>"
   git push origin main
   ```
   Antes do commit, confirme que o staged diff contém somente os caminhos e trechos desta entrega e nenhum segredo ou arquivo volátil. Se houver divergência, pare sem desfazer staging preexistente.
</step>
</steps>

<completion>
Notifique o usuário com o resumo:
- ✅ Build verificado
- 📝 Lições registradas na memória Obsidian
- 📊 Grafo de dependências atualizado
- 📦 Spec arquivada em `specs/archive/<id>/`
- 🔗 Hash do commit gerado

<cadence_reminder>
A cada 5 a 10 archives concluídos no projeto, emita com destaque o alerta:
```text
================================================================================
 🛡️ [SECURITY HEALTH CHECK REMINDER]
 Múltiplos ciclos de entrega foram arquivados e commitados no repositório.
 Recomenda-se rodar uma auditoria preventiva de segurança:
   👉 /secrets-audit     -> Verificar se nenhuma chave vazou no histórico do git
   👉 /dependency-audit  -> Checar CVEs em pacotes recém-instalados
   👉 /security-review   -> Auditar autorização (AuthZ/IDOR) e sanitização
================================================================================
```
</cadence_reminder>
</completion>
</skill>
