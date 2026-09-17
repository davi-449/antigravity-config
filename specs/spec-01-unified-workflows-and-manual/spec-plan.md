# 📋 Spec Plan: Unificação de Workflows, Manual de Operação e Prevenção de Conflitos

## [DOCS] Manual de Operação & Documentação Canônica
- [x] Completed: Criar `docs/manual-operacao-antigravity.md` com as 6 seções completas (Fundamentos, SDD com Hard Stops, Graphify, Theming Dark, Council e Anti-Regressão). (Verificação: `Test-Path docs/manual-operacao-antigravity.md` e contagem de linhas > 150).
- [x] Completed: Atualizar `README.md` do repositório base para refletir a Constituição v7, o mapa de skills ativas e o link para o Manual de Operação. (Verificação: `git diff README.md`).

## [WORKFLOWS] Prevenção de Conflitos & Governança
- [x] Completed: Validar `specs/global/features.md` como catálogo mestre anti-duplicação e garantir que nenhuma skill morta permaneça referenciada. (Verificação: `Select-String -Path skills/INDEX.md -Pattern "saas-scaffold" -Quiet` deve retornar False).
- [x] Completed: Atualizar `scripts/deploy-to-projects.ps1` para propagar `docs/` e `specs/global/features.md` para todos os projetos de forma idempotente. (Verificação: execução do script em modo `-DryRun`).

## [SYNC/TEST] Execução & Validação em Massa
- [x] Completed: Executar `deploy-to-projects.ps1` e confirmar sincronização em todos os 19 projetos sem falhas (`$failCount -eq 0`). (Verificação: retorno do script).
- [x] Completed: Criar commit atômico no repositório `antigravity-config-main` registrando a consolidação definitiva. (Verificação: `git status` limpo).