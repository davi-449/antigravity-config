# 🪐 Antigravity Config v7 (Native AGY Edition — 2026)

> Repositório oficial de configuração, governança, workflows determinísticos (SDD) e Design System para o **Google Antigravity 2.0 (AGY Client & IDE)**.

---

## ⚡ Doutrina de Alta Performance

Este ecossistema foi projetado para eliminar as três maiores causas de falhas no desenvolvimento com IA:
1. **Fim do Loop de Regressão ("Arruma hoje, quebra anteontem"):** Implementações cirúrgicas por bloco via `replace_file_content` com isolamento de *Blast Radius* e rollback automático.
2. **Fim do AI Slop e da Salada Visual (Preto vs. Cinza):** Interface 100% amarrada aos tokens semânticos do Shadcn (`bg-background`, `bg-card`, `border-border`) e controle de Dark Theme/OLED centralizado nas CSS Variables do `globals.css`.
3. **Fim do Waffling e da Amnésia:** Eliminação da sobrecarga de multi-agentes. O modo padrão é **Single-Agent Direto (`Concurrency: 1`)**, garantindo respostas rápidas, técnicas e sem prolixidade.

📖 **Consulte o guia completo:** [Manual de Operação Unificado](docs/manual-operacao-antigravity.md)

---

## 🔄 O Ciclo de Vida SDD (Spec-Driven Development)

| Comando | Fase | Descrição | Parada Obrigatória (Hard Stop) |
|---|---|---|---|
| `/sdd-proposal <id>` | **Planejamento** | Inspeciona dependências com **Graphify**, consulta memória Obsidian e gera a tríade SDD (`proposal.md`, `design.md`, `spec-plan.md`). | 🛑 Para imediatamente para aprovação do plano (zero código). |
| `/sdd-apply <id>` | **Implementação** | Executa as tasks sequencialmente, aplica patches cirúrgicos e valida com `npm run build` no terminal. | 🛑 Para imediatamente para validação humana em localhost. |
| `/sdd-archive <id>` | **Consolidação** | Registra lições no Obsidian, atualiza o grafo (`graphify update`), limpa `.tmp/` e faz commit seletivo. | ✅ Conclusão do ciclo com hash do commit. |
| `/sdd-debug <id>` | **Diagnóstico** | Investiga logs reais e SQL com até 3 tentativas isoladas e rollback automático em caso de falha. | 🛑 Para se o budget de tentativas for atingido. |
| `/council <tópico>` | **Deliberação** | Dispara debate de 4 especialistas (Architect, Engineer, Analyst, Contrarian) + Síntese para stress-test arquitetural sob demanda. | 🛑 Entrega o veredito final ao usuário. |

---

## 🧰 Catálogo de Skills Canônicas Ativas (11 Skills)

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
10. **`agy-bridge`**: Integração com agy CLI para workers assíncronos.
11. **`council-debate`**: Deliberação multi-agente em 3 rodadas para stress-test arquitetural.

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

O sincronizador espelha a Constituição v7, o `DESIGN.md`, a pasta `docs/` e o catálogo de skills limpas de forma 100% idempotente.