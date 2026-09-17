# 🧠 DOMAIN Memory — antigravity-config
> Inicializado via SDD Setup em 2026-09-17. Atualizado automaticamente pelo /sdd-archive.

<!-- Entradas consolidadas pelo sdd-archive -->

## [2026-09-17] — [Feature ID: spec-01-unified-workflows-and-manual]

**Contexto:** Unificação de workflows, manual de operação e eliminação de conflitos no Antigravity 2.0.
**Regra aprendida:** O modo padrão é estritamente Single-Agent Direto (`Concurrency: 1`). Subagentes e conselhos rodam exclusivamente sob demanda (/council). A Inteligência Topológica do Graphify deve ser acionada no Proposal (`graphify explain`) para traçar o Blast Radius e atualizada no Archive (`graphify update`).
**Risco identificado:** Sobrecarga de skills ou prompts inflados induzem o modelo a "waffling" e esquecimento de regras. O catálogo ativo deve permanecer enxuto (11 skills canônicas).
**Não fazer:** Nunca reescrever arquivos inteiros para consertar bugs pontuais; use sempre `replace_file_content` com rollback imediato em caso de erro no build.