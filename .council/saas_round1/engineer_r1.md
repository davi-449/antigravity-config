# ENGINEER — Round 1

## Pesquisa real dos repositórios

### shadcn/ui v4 — Categorias reais do registry (50+ blocos):
- dashboard-01..N (app shell, sidebar, charts, data tables)
- sidebar-01..07+ (collapsible, icons, groups)
- login-01..N (auth layouts)
- chart-01..N (Recharts: bar, line, area, pie, radar)
- MARKETING: hero, pricing, faq, cta, testimonials, blog, features, about, contact
- APP: account, ai, billing, calendar, carousel, changelog, chat, checkout,
  command-menu, comments, empty-state, error, file-upload, gallery,
  integration, kanban, logos, monitoring, music, notification,
  onboarding, product-cards, reviews, search, skeleton, stats, stepper,
  storefront, success, team, timeline, todo-list, web3

### shadcnblocks.com — 2100+ components. Categorias únicas:
- Ecommerce (product listings, checkout flows)
- Advanced forms (color picker, emoji picker, date picker avançado)
- Kanban boards
- Marketing (announcement bars, logo clouds, testimonials em carrossel)

### Magic UI — 6 categorias:
1. Text Animations: Text Animate, Typing Animation, Blur In, Hyper Text, Morphing Text, Number Ticker
2. Special Effects: Animated Beam, Border Beam, Shine Border, Magic Card, Meteors, Confetti
3. Backgrounds: Warp Background, Flickering Grid, Animated Grid Pattern, Retro Grid, Ripple
4. Buttons: Rainbow Button, Shimmer Button, Pulsating Button, Ripple Button
5. Components: Marquee, Terminal, Bento Grid, Globe, Orbiting Circles, Icon Cloud, File Tree, Dock
6. Device Mocks: Safari, iPhone, Android

### Dyad (dyad-sh/dyad) — AI_RULES.md pattern
- Local-first AI builder. Usa AI_RULES.md no root. PROVA que arquivo simples > KB complexa.
- React + Supabase + Git-based versioning + MCP plugins

### OpenDesign (nexu-io/open-design) — DESIGN.md portável
- DESIGN.md blueprint de design system (idêntico ao SKILL.md do Antigravity!)
- HyperFrames — framework de geração de UI
- Anti-slop mechanisms (auto-crítica 5 dimensional)
- Stack: Next.js 16 + Express + SQLite

## Diagnóstico: Problema atual
- 3 skills de frontend sobrepostas (frontend-design-pro + frontend-design-3 + ui-blocks-catalog)
- ~512 linhas combinadas sendo carregadas juntas = ruído

## Proposta concreta
CONSOLIDAR as 3 skills de frontend em 1 (saas-builder) + criar 2 novas:

```
skills/
  saas-builder/         ← consolida frontend-design-pro + frontend-design-3 + ui-blocks-catalog
    SKILL.md            ← ~400 linhas: stack, padrões visuais, TOP templates
    references/
      blocks-landing.md ← shadcn + shadcnblocks landing page blocks
      blocks-app.md     ← dashboard, auth, tables, forms, kanban
      blocks-magic.md   ← Magic UI catalog
      
  saas-motion/          ← Magic UI + 21st.dev patterns (quando usar animações)
    SKILL.md            
    
  saas-fullstack/       ← Dyad AI_RULES.md pattern + backend integration
    SKILL.md            
```

DELETAR: frontend-design-pro, frontend-design-3, ui-blocks-catalog → conteúdo migrado

## Protocolo anti-bloat
1. TRIGGER: task de UI recebida
2. ROUTER: lê só o description YAML (~100 tokens por skill)
3. LOAD: carrega SKILL.md do domínio match (~3000 tokens)
4. SE precisar catálogo: lê references/ específico

## Números concretos
| Arquivo | Tokens est. | Prioridade |
|---|---|---|
| saas-builder/SKILL.md | ~3000 | P0 |
| references/blocks-landing.md | ~1200 | P1 |
| references/blocks-app.md | ~1600 | P1 |
| references/blocks-magic.md | ~800 | P2 |
| saas-fullstack/SKILL.md | ~2400 | P1 |

Total por tarefa típica: 3000-5000 tokens

## Conclusão: FAVORÁVEL — implementação em 2 dias
Não criar 8 skills separadas por repositório. Não copiar catálogo inteiro.
