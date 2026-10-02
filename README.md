# 🪐 Antigravity Config v7 (Native AGY Edition — 2026)

> Repositório oficial de configuração, governança, workflows determinísticos (SDD) e Design System para o **Google Antigravity 2.0 (AGY Client & IDE)**.

---

## Como funciona

Este repositório reúne as regras, skills e o fluxo de trabalho do Antigravity 2.0:
1. **Preservar trabalho existente:** O agente inspeciona o código e registra mudanças locais antes de editar. Se houver sobreposição incerta, para.
2. **Manter a interface consistente:** As skills de UI usam os tokens definidos em `DESIGN.md`.
3. **Respostas fáceis de conferir:** O agente principal explica em português simples o que mudou e mostra a evidência técnica quando ela importa. Um revisor opcional, somente de leitura, ajuda em decisões incertas.

📖 **Consulte o guia completo:** [Manual de Operação Unificado](docs/manual-operacao-antigravity.md)

---

## 🔄 O Ciclo de Vida SDD (Spec-Driven Development)

| Comando | Fase | Descrição | Parada Obrigatória (Hard Stop) |
|---|---|---|---|
| `/sdd-proposal <id>` | **Planejamento** | Inspeciona dependências com **Graphify**, consulta memória Obsidian e gera a tríade SDD (`proposal.md`, `design.md`, `spec-plan.md`). | 🛑 Para imediatamente para aprovação do plano (zero código). |
| `/sdd-apply <id>` | **Implementação** | Executa as tasks sequencialmente, aplica patches cirúrgicos e valida com `npm run build` no terminal. | 🛑 Para imediatamente para validação humana em localhost. |
| `/sdd-archive <id>` | **Consolidação** | Registra lições no Obsidian, atualiza o grafo (`graphify update`), preserva temporários fora do staging e faz commit seletivo. | ✅ Conclusão do ciclo com hash do commit. |
| `/sdd-debug <id>` | **Diagnóstico** | Investiga evidências reais e tenta corrigir sem descartar trabalho preexistente. | 🛑 Para se o limite de tentativas for atingido. |
| `/council <tópico>` | **Deliberação** | Dispara debate de 4 especialistas (Architect, Engineer, Analyst, Contrarian) + Síntese para stress-test arquitetural sob demanda. | 🛑 Entrega o veredito final ao usuário. |

---

## 🧰 Skills e revisão

Consulte [`skills/INDEX.md`](skills/INDEX.md) para roteamento sob demanda:

1. **`frontend-design-pro`**: Hub de Design Engineering, Dark UI Zinc-950, 48 guidelines do Rauno e catálogo anti-slop.
2. **`ui-components`**: Catálogo de componentes Shadcn/Tailwind semânticos.
3. **`ui-motion`**: Micro-interações e animações Magic UI (≤ 200ms).
4. **`backend-patterns`**: Server Actions tipadas `ActionResult<T>`, validação Zod e cache revalidation.
5. **`database`**: Padrões PostgreSQL/Supabase, multi-tenant RLS e migrations idempotentes.
6. **`auth`**: Autenticação SSR segura, PKCE, `getUser()` no server.
7. **`deploy-production`**: 4 camadas de cache App Router, SEO metadata e Core Web Vitals.
8. **`security`**: AppSec, Taint Analysis (Sentry), Pentest (Cloudflare), OWASP Top 10 e Secrets.
9. **`github-ops`**: Operações Git headless e GitHub CLI token-driven.
10. **`agy-bridge`**: Integração legada com agy CLI, apenas quando solicitada.
11. **`council-debate`**: Deliberação multi-agente em 3 rodadas para stress-test arquitetural.

O agente principal usa as skills por assunto. `sdd-reviewer` é um agente opcional de leitura para conferir escolhas com risco real de duplicação ou contratos incertos; ele não edita nem aprova testes.

---

## 📐 Design System & Theming Semântico

* **Fonte de Verdade:** [`DESIGN.md`](DESIGN.md).
* **Regra Fundamental:** Zero classes arbitrárias (`bg-[#...]`, `w-[...]`) ou cores brutas (`bg-black`, `bg-zinc-950`) em componentes JSX.
* **Tokens Obrigatórios:** `bg-background` (canvas), `bg-card` (superfícies), `border-border` (divisores), `text-foreground` (título) e `text-muted-foreground` (legendas).
* **Controle Dark OLED:** Centralizado no `:root` de `src/globals.css`.

---

## 🚀 Instalação & Sincronização Local

Para aplicar esta configuração em todos os projetos locais em `~/.gemini/antigravity/scratch/`:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/deploy-to-projects.ps1
```

Primeiro rode `scripts/sync-global.ps1 -DryRun` para ver a cópia global. Os scripts preservam arquivos personalizados: atualizam apenas uma versão anterior comprovada do mesmo arquivo canônico e relatam conflitos. `deploy-to-projects.ps1` aceita `-ProjectName <nome>` para testar um projeto antes da propagação geral.
