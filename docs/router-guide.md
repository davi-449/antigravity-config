# Roteamento atual

O agente principal escolhe a skill do domínio em [skills/INDEX.md](../skills/INDEX.md). Use a skill SDD da fase atual e apenas as referências técnicas necessárias.

| Pedido | Fase | Skill do assunto |
|---|---|---|
| Planejar ou propor | `/sdd-proposal` ou `/vibe-proposal` | UI, backend, banco, auth ou segurança conforme o código |
| Implementar plano aprovado | `/sdd-apply` ou `/vibe-apply` | As skills já indicadas na spec |
| Concluir entrega aprovada | `/sdd-archive` ou `/vibe-archive` | Obsidian, Git e segurança |
| Investigar falha | `/sdd-debug` | Domínio afetado |

Peça revisão em leitura ao `sdd-reviewer` quando houver risco concreto de duplicação, contrato incerto ou mudança sensível. O agente principal verifica seus achados; o parecer não substitui teste.

`/council` permanece disponível somente quando solicitado. `/route-task` e bundles v6 não são necessários para o fluxo atual.
