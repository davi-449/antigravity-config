# 📋 Proposal: Padronização de GitHub Flow, Motion UI e Observabilidade com Qualidade

## 1. Problema e Oportunidade
Atualmente, o ciclo de desenvolvimento do Antigravity 2.0 está com governança interna forte (SDD, Single-Agent, Graphify), mas os projetos satélites ainda sofrem com:
1. **Falta de Rastreabilidade no GitHub:** Commits sendo empurrados sem vinculação a Issues, sem Pull Requests padronizados e sem `Closes #ID`.
2. **UIs Sem Estados de Transição (AI Slop de UX):** Telas que ficam brancas ou vazias durante fetching em vez de exibir Skeleton Loadings ou que deletam cards bruscamente sem animação de saída.
3. **Erros Silenciosos sem Observabilidade:** Falhas em fluxos críticos (ex: envio de mensagens, conciliação, integrações com Supabase) ocorrem sem captura de contexto em ferramentas como Sentry (faltando breadcrumbs e tags estruturadas).
4. **CI/CD Desarmado:** Ausência de pipeline padronizado no GitHub Actions para rodar linter, typecheck e testes automáticos antes de permitir o merge.

## 2. Solução Proposta
Padronizar em todo o ecossistema Antigravity 2.0 (regras globais, skills e projetos) os três pilares de maturidade de software:
1. **GitHub Flow Canônico:**
   - Cada tarefa (bug, melhoria, feature) abre uma Issue via `gh issue create`.
   - Desenvolvimento em branch dedicada (`feature/<id>` ou `fix/<id>`).
   - Pull Request obrigatório com template estruturado contendo Resumo, `Closes #ID`, Alterações e Testes Realizados.
2. **Motion Engineering & Micro-UX (Padrão Skill Motion / Rauno):**
   - Skeleton Loading obrigatório para qualquer estado de carregamento assíncrono (`isLoading ? <ListSkeleton /> : <List />`).
   - Animações suaves de entrada (ex.: `slideIn 240ms ease-out` ou fade-in sutil) e animações de saída antes de exclusão de elementos do DOM.
   - Feedback visual imediato e progresso visível em botões e mutações.
3. **Observabilidade e Pipeline de Qualidade:**
   - Padrão Sentry: `Sentry.addBreadcrumb` antes de operações críticas e `Sentry.captureException` com contexto (tags de feature, IDs e payload seguro).
   - Template canônico de CI (`.github/workflows/quality.yml`) rodando Biome/ESLint, Typecheck, Testes Unitários (Vitest) e Build antes do merge.

## 3. Skills Especializadas Aplicadas
- `github-ops`: Automação headless de Issues, PRs e Conventional Commits.
- `ui-motion`: Princípios de micro-interações funcionais (≤ 200-240ms, GPU compositor).
- `frontend-design-pro`: Skeletons, empty states e eliminação de AI Slop.
- `security`: Sanitização de dados antes de enviar para ferramentas de telemetria (Sentry).

## 4. Contratos de Dados & Padrões
- **Issue Template:** `.github/ISSUE_TEMPLATE/feature_or_bug.md`
- **PR Template:** `.github/PULL_REQUEST_TEMPLATE.md`
- **CI Workflow Template:** `.github/workflows/quality.yml`
- **Guia Técnico:** Atualização em `docs/manual-operacao-antigravity.md` e `skills/github-ops/SKILL.md`.

## 5. Arquivos Afetados
- `[NOVO]` `specs/spec-02-dev-standards-gh-motion-observability/proposal.md`
- `[NOVO]` `specs/spec-02-dev-standards-gh-motion-observability/design.md`
- `[NOVO]` `specs/spec-02-dev-standards-gh-motion-observability/spec-plan.md`
- `[NOVO]` `.github/PULL_REQUEST_TEMPLATE.md`
- `[NOVO]` `.github/workflows/quality.yml.example`
- `[MODIFICADO]` `skills/github-ops/SKILL.md` (Adicionando templates de Issues/PRs e automação via CLI)
- `[MODIFICADO]` `skills/ui-motion/SKILL.md` (Adicionando padrões de Skeleton e Animações de Saída)
- `[MODIFICADO]` `docs/manual-operacao-antigravity.md` (Seção dedicada a GitHub Flow, Observabilidade Sentry e Motion)
- `[MODIFICADO]` `specs/global/features.md` (Registro dos novos padrões)

## 6. Plano de Rollback
- Reversão atômica via Git caso as regras criem atrito indesejado.
- As automações são não-destrutivas (templates e documentação de guardrails).

## 7. Risco Principal e Mitigação
- **Risco:** CI muito lento ou falhando por ausência de dependências opcionais.
- **Mitigação:** O workflow de CI é fornecido como `.example` e configurado de forma rápida com Bun/Node e caching de dependências.