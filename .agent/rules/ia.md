---
trigger: always_on
---

# 🪐 Antigravity Vibe Coding Orchestration Rules v2

## 1. Core Principles

- **Desconfie do Vibe Coding Puro**: Nenhuma feature grande deve ser iniciada escrevendo código direto. Toda mudança estrutural precisa de uma Especificação (Proposal) detalhada antes.
- **Isolamento de Responsabilidade**: Você (Antigravity) coordena e "costura". Deixe tarefas massivas de banco de dados para o `Supabase MCP` e construção visual pesada para o `Stitch MCP`.

## 2. ⛔ Regra Anti-Alucinação (MAIS IMPORTANTE)

**ANTES de criar qualquer coisa nova, você DEVE pesquisar o que já existe.**

### Criando Componente?
```
OBRIGATÓRIO: grep_search no diretório src/components/ e src/features/ pelo nome ou função similar.
Se já existe → USE. Crie um wrapper se precisar, NÃO duplique.
Se não existe → PERGUNTE ao usuário se quer um novo ou se esqueceu de apontar um existente.
```

### Alterando Banco de Dados?
```
OBRIGATÓRIO: rode list_tables via Supabase MCP antes de qualquer operação.
Se a tabela já existe → USE. Adicione coluna se necessário via migration, NÃO crie tabela nova.
Se não existe → PERGUNTE ao usuário se realmente precisa de uma nova tabela.
NUNCA crie tabela, RPC, ou política sem verificar primeiro.
```

### Criando Hook?
```
OBRIGATÓRIO: grep_search em src/hooks/ pelo nome ou funcionalidade similar.
O projeto tem +87 hooks — é MUITO provável que já exista o que você precisa.
```

### Criando Página?
```
OBRIGATÓRIO: verifique App.tsx para rotas existentes.
```

### Regra Absoluta
- **NUNCA crie duplicatas.** Se algo parecido existe, use ou estenda.
- **Se der erro, NÃO crie coisa nova pra contornar.** Conserte o que existe.
- **Ao reverter/arrumar um bug, NÃO adicione mais complexidade.** Simplifique.

## 3. Padrões de Frontend (UI/UX)

- Se a UI requer centenas de linhas JSX e CSS, use o **Stitch MCP** para gerar a base visual.
- Puxe componentes primitivos do `shadcn/ui` (via `src/components/ui/`).
- **Stitch MCP = gerador visual.** Use para: criar telas novas inteiras, prototipar layouts, gerar variantes.
- **Antigravity = integrador.** Conecte a UI do Stitch ao backend Supabase, adicione lógica, hooks, estado.
- Sempre exporte Requisitos Visuais para o arquivo `design.md` dentro de uma especificação Vibe (Fase 1).

## 4. Padrões de Backend (Supabase)

- **Migrações são a Lei:** Toda alteração de schema passa por `apply_migration` no Supabase MCP ou CLI local (`supabase migration new`).
- **Sincronização Typescript:** Após alterar schema: `supabase gen types typescript --local > src/types/database.types.ts`.
- **Segurança Backend:** Segredos em variáveis de ambiente. RLS obrigatório em tabelas novas.
- **Antes de qualquer operação no banco**: rode `list_tables` via Supabase MCP.

## 5. Workflows OpenSpec (Vibe)

Todo desenvolvimento segue essa sequência rigorosa:

1. `/vibe-proposal "Feature name"`: Engenharia de Requisitos sem código → `specs/<id>/proposal.md` + `design.md` + `tasks.md`.
2. `/vibe-apply <id>`: Implementação guiada estrita pelo `tasks.md`. Use MCPs para DB/Front.
3. `/vibe-archive <id>`: Move specs finalizadas para `specs/archive/`.

## 6. Qualidade de Código Final

- **Feature-Sliced Design**: Organizar por domínio (`/features/auth/`, `/features/finance/`, etc), NÃO por tipo genérico.
- Zero `any` no TypeScript.
- Sem imports não utilizados.
- Lint limpo ao final de cada `/vibe-apply`.

## 7. Credenciais de Teste (CRM)

Ao testar o Tork CRM no browser, use:
- **URL**: verificar a porta ativa (geralmente https://preview--renew-assist-pro.lovable.app/)
- **Email**: `contato@jjamorimseguros.com.br`
- **Senha**: `123456`

Faça login automaticamente — NÃO pause para pedir credenciais ao usuário.

## 8. Economia de Contexto

- Ao gerar UI pesada (muitas linhas de JSX), prefira o **Stitch MCP** para gerar a base e depois ajuste.
- Para lógica de negócio, state management, hooks e integração: **Antigravity** faz direto.
- Para queries SQL, migrações, RLS: **Supabase MCP** faz direto.
- Regra: se a tarefa exige >200 linhas de JSX novo, considere Stitch primeiro.