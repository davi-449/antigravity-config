# SDD Proposal — Modernização Antigravity v2.17 – v2.19.1 & Subagentes Especializados de Pesquisa

## Problema
O Antigravity v2.17.0 – v2.19.1 trouxe melhorias críticas para orquestração de subagentes e controle de contexto:
1. **Direct Subagent Messaging**: Capacidade de interagir diretamente com um subagente na UI sem intermediar pelo agente raiz.
2. **Subagent Worktree Isolation**: Isolamento de Git worktrees para que pesquisas em branches ou histórico não sujem o diretório de trabalho nem criem artefatos fantasmas.
3. **Dedicated 20k Token Rules Budget**: Regras (ia.md) isoladas em 20.000 tokens, impedindo que regras compitam com MCPs e histórico de código.
4. **Centralização Canônica em <project>/.gemini/config.json**: Substituição definitiva do .agents/settings.json.
5. **Gargalo Atual de Pesquisa**: Quando o agente principal precisa analisar grandes bibliotecas, documentações na web ou dezenas de arquivos legados, o contexto se esgota rapidamente com logs e trechos de arquivos brutos.

---

## Solução Proposta
1. **Catálogo de Subagentes Especialistas de Leitura/Pesquisa (.agents/agents/)**:
   - codebase-scout: Especialista em varredura interna (grep, rastreio de dependências, AST de tipos). Retorna apenas síntese limpa. commandExecutionPolicy: off.
   - web-researcher: Especialista em busca externa (documentações oficiais, bibliotecas, repositórios GitHub, web). Retorna resumos estruturados sem poluir o contexto do agente raiz. commandExecutionPolicy: off.
   - sdd-reviewer: Revisor de riscos arquiteturais e duplicação pré-proposal e pré-archive.
2. **Configuração Canônica de Projeto (.gemini/config.json)**:
   - Template canônico com políticas de plano, permissões protegidas (.git, .env, .vscode) e mapeamento de subagentes.
3. **Propagação Automatizada**:
   - Atualizar scripts/deploy-to-projects.ps1 e scripts/sync-global.ps1 para sincronizar os novos agentes e o template de configuração nos 19 projetos com preservação de conflitos.
4. **Documentação e Atualização de Regras**:
   - Atualizar docs/manual-operacao-antigravity.md e .agent/rules/ia.md formalizando a governança dos subagentes de pesquisa (quando acionar, permissões de leitura estrita e isolamento de contexto).

---

## Skills Especializadas Aplicadas
- ntigravity-guide / gy-customizations: Padrões de agentes e configuração v2.19.
- security: Políticas de travas de permissão (commandExecutionPolicy: off).
- obsidian: Memória de decisões e rastreabilidade modular.

---

## Arquivos Afetados

### [Arquivos Existentes Modificados]
- scripts/deploy-to-projects.ps1: Propagar .gemini/config.json e novos subagentes.
- scripts/sync-global.ps1: Mapear .agents/agents para a pasta de agentes global.
- .agent/rules/ia.md: Formalizar governança dos subagentes de pesquisa e budget de 20k tokens.
- .agents/agents/sdd-reviewer.md: Adicionar campo hooks: da v2.19.
- docs/manual-operacao-antigravity.md: Guia de acionamento de subagentes e novidades da v2.19.
- specs/global/features.md: Adicionar catálogo de subagentes de pesquisa.

### [Arquivos Novos]
- .agents/agents/codebase-scout.md: Subagente de varredura interna e análise de código legado.
- .agents/agents/web-researcher.md: Subagente de busca externa e documentações.
- 	emplates/project-gemini-config.json: Template canônico do .gemini/config.json.

---

## Evidência e Decisão
| Caminho / Símbolo | Ação | Motivo | Verificação |
|---|:---:|---|---|
| .agents/agents/codebase-scout.md | **Criar** | Isolar varreduras pesadas de código fora do contexto principal. | Frontmatter YAML válido com commandExecutionPolicy: off. |
| .agents/agents/web-researcher.md | **Criar** | Consultar documentações e GitHub sem gastar tokens da conversa raiz. | Ferramentas exclusivas de web/leitura. |
| 	emplates/project-gemini-config.json | **Criar** | Padrão canônico da v2.19 para os 19 projetos. | JSON válido. |
| scripts/deploy-to-projects.ps1 | **Editar** | Distribuir agentes e config para os 19 projetos com Copy-IfSafe. | Execução com 0 erros de sintaxe. |
| .agent/rules/ia.md | **Editar** | Documentar quando chamar subagentes de pesquisa. | 	ests/config-safety/textual.ps1 passa. |

---

## Plano de Rollback
- Reverter alterações locais via git restore ..
- Remover subagentes novos caso ocorra qualquer incompatibilidade de runtime.

---

## Risco Principal e Mitigação
- **Risco:** Subagentes tentarem executar comandos ou editar código desobedecendo a constituição.
- **Mitigação:** Atributo nativo obrigatório commandExecutionPolicy: off e ferramentas estritamente de leitura (iew_file, grep_search, search_web,
ead_url_content).
