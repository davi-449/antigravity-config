# 🧠 UI Memory — antigravity-config
> Inicializado via SDD Setup em 2026-09-17. Atualizado automaticamente pelo /sdd-archive.

<!-- Entradas consolidadas pelo sdd-archive -->

## [2026-09-17] — [Feature ID: spec-01-unified-workflows-and-manual]

**Contexto:** Padronização visual anti-slop e consistência dark mode no DESIGN.md.
**Regra aprendida:** Componentes JSX/HTML são terminantemente proibidos de usar cores brutas como `bg-black`, `bg-zinc-950` ou classes arbitrárias (`bg-[#...]`). Toda a UI usa exclusivamente tokens semânticos (`bg-background`, `bg-card`, `border-border`, `text-foreground`).
**Risco identificado:** Alterar classes dentro dos componentes para deixar a tela preta gera discrepância de cinzas e quebra o design system.
**Não fazer:** Nunca hardcodar cores físicas nos componentes. O tema escuro (inclusive preto absoluto OLED) é controlado centralizadamente nas CSS Variables em `globals.css`.