---
description: Ship PR — processo completo de qualidade, commit semântico e abertura de Pull Request.
---

<!-- SHIP:START -->

**Guardrails**

- Só iniciar se a feature estiver completa (todas as tasks do spec marcadas como `[x]`).
- NÃO commitar código com lint errors ou TypeScript `any`.
- Se houver dúvida sobre o escopo do commit, pergunte antes de commitar.

**Steps**

1. **Verificar pré-condições**:
   - [ ] Todas as tasks do spec estão `[x]`?
   - [ ] O código compila? (`npm run build` ou `npx tsc --noEmit`)
   - Se não: PARE e corrija antes de continuar.

2. **Aplicar `lint-and-validate`** (skill):
   - Zero erros de lint
   - Zero TypeScript `any`
   - Sem imports não utilizados
   - Sem `console.log` de debug

3. **Aplicar `code-review`** (skill) — self-review do diff:
   - Ler o diff inteiro (`git diff HEAD`)
   - Checar framework SOLID+S
   - Remover código morto ou temporário

4. **Montar o commit semântico**:
   - Identificar o tipo: `feat` / `fix` / `docs` / `chore` / `refactor` / `test`
   - Identificar o scope: `auth`, `crm`, `leads`, `dashboard`, `api`, `db`, `config`
   - Escrever mensagem clara: `feat(leads): add status filter to leads table`

5. **Verificar arquivos staged**:
   ```bash
   git status
   git diff --staged  # Revisar o que vai no commit
   ```

6. **Commitar** com conventional commit:
   ```bash
   git add -p  # Staging interativo (preferido)
   git commit -m "feat(scope): descrição clara"
   ```

7. **Aplicar `create-pr`** (skill) — estruturar a PR description:
   - Context: por que esta mudança?
   - Changes: o que foi feito?
   - Database changes: migrações e RLS?
   - Testing: como foi validado?

8. **Push e abrir PR**:
   ```bash
   git push origin <branch>
   ```

9. **Arquivar spec** (se spec completa):
   - Invocar `/vibe-archive <id>` para limpar o contexto

**Reference**

- Skills usadas: `lint-and-validate`, `code-review`, `create-pr`
- Conventional commits: `.agent/bundles/ship-mode.md`
- Template PR: `skills/create-pr/SKILL.md`

<!-- SHIP:END -->
