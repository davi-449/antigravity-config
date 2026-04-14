# Guia de Roteamento de Tarefas

O sistema de roteamento decide **quais skills/bundles ativar** com base no tipo de tarefa atual.

---

## Como usar o roteador

```
/route-task
```

O roteador analisa a descrição da sua tarefa e recomenda:
1. O bundle ideal
2. Skills adicionais opcionais
3. O workflow correto para iniciar

---

## Tabela de roteamento

| Tipo de tarefa | Indicadores | Bundle/Skill |
|---------------|-------------|--------------|
| **Planejamento** | "planejar", "propor", "nova feature", "como deveria funcionar" | `planning-mode` |
| **Implementação** | "implementar", "criar feature", "adicionar", vibe-apply | `fullstack-dev` |
| **UI visual pesada** | "criar tela", "nova página", "prototipar", >200 linhas JSX | `stitch-visual` |
| **Debugging** | "não funciona", "erro", "bug", "investigar", logs | `debugging-strategies` |
| **API/Edge Function** | "endpoint", "Edge Function", "webhook", "API" | `planning-mode` + `api-design-principles` |
| **Segurança** | "RLS", "autenticação", "auditoria", "endpoint público" | `security-auditor` |
| **Commit/PR** | "commitar", "PR", "pull request", "release" | `ship-mode` |
| **Qualidade** | "lint", "TypeScript any", "imports", "erros de build" | `lint-and-validate` |
| **Code review** | "revisar código", "diff", "antes de merge" | `ship-mode` |
| **Banco de dados** | "tabela", "migration", "RLS policy", "schema" | `supabase-best-practices` |

---

## Fluxos de roteamento compostos

### Feature nova (mais comum)
```
Passo 1: planning-mode  [levantamento + spec]
         ↓ spec aprovado?
Passo 2: fullstack-dev  [implementação]
         ↓ code completo?
Passo 3: ship-mode      [quality gate + PR]
         ↓ PR merged?
Passo 4: vibe-archive   [limpeza de contexto]
```

### Bug em produção
```
Passo 1: debugging-strategies  [root cause]
         ↓ causa identificada?
Passo 2: implementar fix       [skill de teste TDD recomendada]
         ↓ fix validado?
Passo 3: ship-mode             [commit + PR]
```

### UI nova visual
```
Passo 1: planning-mode   [definir o que gerar]
         ↓ aprovado?
Passo 2: stitch-visual   [gerar com Stitch MCP]
         ↓ screens geradas?
Passo 3: fullstack-dev parcial [integrar ao estado/backend]
         ↓ integrado?
Passo 4: ship-mode        [commit + PR]
```

---

## Regras de desempate

Quando a tarefa tem características de múltiplos tipos:

1. **Planning > Implementation**: Se há dúvida se o design está aprovado, volve para `planning-mode`
2. **Debug > Feature**: Um bug bloqueante tem prioridade sobre nova feature
3. **Security > Speed**: Jamais pular `security-auditor` por pressão de tempo
4. **Spec > Código**: Nunca iniciar implementação sem spec aprovado

---

## Customizando o roteamento

Para adicionar novos padrões de roteamento:
1. Editar `.agent/workflows/route-task.md`
2. Adicionar linha na tabela de tipos de tarefa
3. Referenciar o bundle ou skill correta

---

## Referências

- Bundles disponíveis: [`docs/bundles.md`](bundles.md)
- Catálogo de skills: [`.agent/catalog/README.md`](../.agent/catalog/README.md)
- Workflow de roteamento: [`.agent/workflows/route-task.md`](../.agent/workflows/route-task.md)
- Política de ativação: [`.agent/policies/activation-rules.md`](../.agent/policies/activation-rules.md)
