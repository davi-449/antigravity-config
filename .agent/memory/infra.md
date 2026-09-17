# 🧠 INFRA Memory — antigravity-config
> Inicializado via SDD Setup em 2026-09-17. Atualizado automaticamente pelo /sdd-archive.

<!-- Entradas consolidadas pelo sdd-archive -->

## [2026-09-17] — [Feature ID: spec-01-unified-workflows-and-manual]

**Contexto:** Distribuição de configuração e sincronização idempotente multi-projetos.
**Regra aprendida:** O script `scripts/deploy-to-projects.ps1` é o canal canônico de propagação local. Ele espelha `.agent/rules/`, `.agent/memory/`, `DESIGN.md`, `skills/` e `docs/manual-operacao-antigravity.md` de forma idempotente em todos os projetos de `scratch/`.
**Risco identificado:** Pastas legadas (.council, leads/, workers/) acumulavam centenas de megabytes de resíduos em projetos satélites.
**Não fazer:** Nunca permitir que arquivos temporários (`.tmp/`), caches de AST (`graphify-out/cache/`) ou dumps JSON do council sejam versionados no Git.