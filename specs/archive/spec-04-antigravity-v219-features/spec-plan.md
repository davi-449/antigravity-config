# Spec Plan — Modernização Antigravity v2.17 – v2.19.1 & Subagentes de Pesquisa

## [GIT & SUBAGENTS] Permissões e Criação dos Subagentes Especialistas
- [x] Completed Liberar !templates/*.json no .gitignore e criar .agents/agents/codebase-scout.md (varredura de código, AST e dependências com comandos travados).
  - Skill: ntigravity-guide
  - Verificação: powershell -Command Get-Content .agents/agents/codebase-scout.md | Select-String 'commandExecutionPolicy: off' -> Aprovado
- [x] Completed Criar .agents/agents/web-researcher.md (pesquisa externa de docs e GitHub sem poluir contexto).
  - Skill: ntigravity-guide
  - Verificação: powershell -Command Get-Content .agents/agents/web-researcher.md | Select-String 'commandExecutionPolicy: off' -> Aprovado
- [x] Completed Atualizar .agents/agents/sdd-reviewer.md para suportar o campo hooks:.
  - Skill: sdd-proposal
  - Verificação: powershell -ExecutionPolicy Bypass -File tests/config-safety/textual.ps1 -> 7/7 Aprovado

## [TEMPLATES] Template Canônico de Configuração
- [x] Completed Criar 	emplates/project-gemini-config.json com schema canônico de permissões protegidas e políticas da v2.19.
  - Skill: ntigravity-guide
  - Verificação: powershell -Command Get-Content templates/project-gemini-config.json | ConvertFrom-Json -> Aprovado

## [SCRIPTS] Atualização de Deploy e Sincronização
- [x] Completed Atualizar scripts/deploy-to-projects.ps1 e scripts/sync-global.ps1 para propagar .gemini/config.json e os novos agentes com preservação de conflitos.
  - Skill: github-ops
  - Verificação: powershell -ExecutionPolicy Bypass -File scripts/deploy-to-projects.ps1 -DryRun -> Aprovado

## [RULES & DOCS] Atualização da Constituição e Manual de Operação
- [x] Completed Atualizar .agent/rules/ia.md, specs/global/features.md e docs/manual-operacao-antigravity.md documentando os subagentes de pesquisa, orçamento de 20k tokens e proteção de diretórios sensíveis.
  - Skill: ntigravity-guide
  - Verificação: powershell -ExecutionPolicy Bypass -File scripts/run-evals.ps1 -> 33/33 Aprovado

## [TESTS] Validação do Harness de Segurança
- [x] Completed Executar a suíte de integridade 	ests/config-safety/run.ps1 e confirmar 100% de aprovação.
  - Skill: security
  - Verificação: powershell -ExecutionPolicy Bypass -File tests/config-safety/run.ps1 -> PASSOU (0 erros)
