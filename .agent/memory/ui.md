# 🧠 UI Memory — antigravity-config
> Inicializado via SDD Setup em 2026-09-17. Atualizado automaticamente pelo /sdd-archive.

<!-- Entradas consolidadas pelo sdd-archive -->

## [2026-09-17] — [Feature ID: spec-01-unified-workflows-and-manual]

**Contexto:** Padronização visual anti-slop e consistência dark mode no DESIGN.md.
**Regra aprendida:** Componentes JSX/HTML são terminantemente proibidos de usar cores brutas como `bg-black`, `bg-zinc-950` ou classes arbitrárias (`bg-[#...]`). Toda a UI usa exclusivamente tokens semânticos (`bg-background`, `bg-card`, `border-border`, `text-foreground`).
**Risco identificado:** Alterar classes dentro dos componentes para deixar a tela preta gera discrepância de cinzas e quebra o design system.
**Não fazer:** Nunca hardcodar cores físicas nos componentes. O tema escuro (inclusive preto absoluto OLED) é controlado centralizadamente nas CSS Variables em `globals.css`.

## [2026-09-17] — [Feature ID: spec-02-dev-standards-gh-motion-observability]

**Contexto:** Padronização de Motion Engineering, Skeletons assíncronos e prevenção de layout shift.
**Regra aprendida:** Todo estado assíncrono (carregamento de dados, mutações) deve renderizar Skeleton loading preservando as dimensões do conteúdo final. Transições de entrada devem usar GPU-only keyframes `slideIn` (240ms ease-out) e remoções devem executar saída suave (`scale(0.96)`, 200ms ease-in) antes do desmonte do DOM. Respeitar sempre `@media (prefers-reduced-motion)`.
**Risco identificado:** Spinners genéricos no centro da tela causam saltos visuais abruptos (layout shifts) e rebaixam a nota de Core Web Vitals (CLS).
**Não fazer:** Nunca desmontar componentes instantaneamente em remoções de lista ou apresentar telas vazias sem skeleton enquanto requisições estão em trânsito.