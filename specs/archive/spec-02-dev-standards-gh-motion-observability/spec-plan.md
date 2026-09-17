# 📋 Spec Plan: GitHub Flow, Motion UI e Observabilidade

## [GITHUB-FLOW] Issues, Pull Requests & CI Pipeline
- [x] Completed: Criar `.github/PULL_REQUEST_TEMPLATE.md` com seções de Resumo, Closes #ID, Alterações e Testes Realizados. (Verificação: `Test-Path .github/PULL_REQUEST_TEMPLATE.md`).
- [x] Completed: Criar `.github/workflows/quality.yml.example` contendo steps para Checkout, Bun/Node, Lint, Typecheck, Test e Build. (Verificação: `Test-Path .github/workflows/quality.yml.example`).
- [x] Completed: Atualizar `skills/github-ops/SKILL.md` adicionando automação de `gh issue create`, fluxo de branches e template de PR. (Verificação: `git diff skills/github-ops/SKILL.md`).

## [UI-MOTION] Padrões de Skeleton Loading & Micro-UX
- [x] Completed: Atualizar `skills/ui-motion/SKILL.md` documentando o padrão obrigatório de Skeletons assíncronos e keyframes de entrada (`slideIn 240ms`) e saída. (Verificação: `git diff skills/ui-motion/SKILL.md`).

## [OBSERVABILITY] Padrão Sentry & Telemetria
- [x] Completed: Atualizar `docs/manual-operacao-antigravity.md` adicionando a Seção 7: "Padrão de Observabilidade (Sentry Breadcrumbs & Capture)" e Seção 8: "GitHub Flow & CI Pipeline". (Verificação: `git diff docs/manual-operacao-antigravity.md`).
- [x] Completed: Atualizar `specs/global/features.md` registrando os padrões de GitHub Flow, Motion e Observabilidade. (Verificação: `git diff specs/global/features.md`).

## [SYNC/TEST] Propagação & Validação
- [x] Completed: Atualizar `scripts/deploy-to-projects.ps1` para propagar `.github/PULL_REQUEST_TEMPLATE.md` e CI workflow para todos os projetos locais. (Verificação: `powershell -File scripts/deploy-to-projects.ps1 -DryRun`).
- [x] Completed: Executar `deploy-to-projects.ps1` e confirmar sincronização em todos os projetos com `$failCount -eq 0`. (Verificação: retorno do script).