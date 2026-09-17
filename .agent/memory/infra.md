# 🧠 INFRA Memory — antigravity-config
> Inicializado via SDD Setup em 2026-09-17. Atualizado automaticamente pelo /sdd-archive.

<!-- Entradas consolidadas pelo sdd-archive -->

## [2026-09-17] — [Feature ID: spec-01-unified-workflows-and-manual]

**Contexto:** Distribuição de configuração e sincronização idempotente multi-projetos.
**Regra aprendida:** O script `scripts/deploy-to-projects.ps1` é o canal canônico de propagação local. Ele espelha `.agent/rules/`, `.agent/memory/`, `DESIGN.md`, `skills/` e `docs/manual-operacao-antigravity.md` de forma idempotente em todos os projetos de `scratch/`.
**Risco identificado:** Pastas legadas (.council, leads/, workers/) acumulavam centenas de megabytes de resíduos em projetos satélites.
**Não fazer:** Nunca permitir que arquivos temporários (`.tmp/`), caches de AST (`graphify-out/cache/`) ou dumps JSON do council sejam versionados no Git.

## [2026-09-17] — [Feature ID: spec-02-dev-standards-gh-motion-observability]

**Contexto:** Implementação de GitHub Flow automatizado (`gh` CLI), PR Template obrigatório e CI Quality Gate.
**Regra aprendida:** Toda tarefa inicia com uma issue (`gh issue create`), trabalha em branch nomeada (`feat/id` ou `fix/id`) e finaliza com PR (`gh pr create`) sempre referenciando `Closes #ID`. O repositório deve fornecer `.github/PULL_REQUEST_TEMPLATE.md` e o CI workflow exemplo (`quality.yml.example`) com validação de lint, typecheck, tests e build.
**Risco identificado:** Criar PRs sem vincular a issue deixa o backlog órfão e desorganizado no GitHub.
**Não fazer:** Nunca realizar commit ou merge direto na branch principal sem passar pelo fluxo de issue + branch + PR verificado por CI.