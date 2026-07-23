---
description: Conclui o fluxo da Spec, atualizando a memória modular, o Grafo e realizando o commit do progresso. Arquiva a spec para reutilização futura.
---

<!-- VIBEARCHIVE:END -->

> ⛔ **OVERRIDE SUPREMO:** Se o usuário mencionar `/teamwork-preview` ou pedir análise conjunta, PARE e acione os subagentes. NUNCA ignore.

**Objetivo**
Garantir que a entrega não quebrou o build, atualizar as fontes de verdade (memória modular + Graphify) e fazer o commit. A spec vai para o arquivo histórico para reutilização futura.

**Steps de Encerramento**

1. **Quality Gate (Build)**:
   - Execute o build da aplicação: `cmd.exe /c "npm run build"`
   - Se o build falhar, NÃO faça commit. Corrija o erro ou acione o auto-healing do `/vibe-apply`.

2. **Atualização da Memória Modular** ← OBRIGATÓRIO, nunca pule:
   - Identifique a categoria do conhecimento gerado (ex: OFX, Supabase RLS, UI Pattern, Auth)
   - Escreva a lição no arquivo correspondente em `.agent/memory/<categoria>.md`
   - Exemplos: `memory/ofx.md`, `memory/supabase.md`, `memory/ui.md`, `memory/auth.md`
   - **Nunca jogue tudo no `memory.md` geral** — memória granular é memória utilizável
   - Formato exato a usar:
     ```
     ## [Data] — [Feature ID]
     **Contexto:** O que foi feito
     **Regra aprendida:** A lógica crítica que não pode ser esquecida
     **Risco identificado:** O que quase quebrou
     ```

3. **Atualização do Grafo (Graphify)**:
   - Execute `graphify update` para re-extrair os arquivos modificados para o `graph.json`
   - Se o comando falhar com "command not found", instale: `uv tool install graphifyy` (Python, não NPM)
   - Confirme que `graphify-out/graph.json` foi atualizado

4. **Arquivamento da Spec**:
   - Mova `specs/<id>/` para `specs/archive/<id>/` para manter o projeto limpo mas o histórico acessível
   - Isso é importante: specs antigas são reutilizáveis em proposals futuras similares

5. **Atualização do `spec/global/features.md`**:
   - Adicione os novos componentes, hooks, tabelas ou lógicas criadas nesta iteração
   - Isso alimenta o bloqueio anti-duplicação do próximo `/vibe-proposal`

6. **Commit & Push Controlado**:
   - `git add .` (incluindo `graphify-out/` e `specs/archive/`)
   - Gere um commit descritivo: `git commit -m "feat(<id>): <o que foi resolvido>"`
   - `git push origin main`
   - *Fallback Windows:* Se o `git` não estiver no PATH, use `C:\Users\admin\.gemini\antigravity\scratch\mingit\cmd\git.exe`
   - **Jamais use `push --force`**

7. **Notificação Final**:
   - Avise o usuário que a task foi finalizada com sucesso
   - Mencione o que foi arquivado na memória e qual categoria

<!-- VIBEARCHIVE:END -->
