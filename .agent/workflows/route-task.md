---
description: Roteador de tarefas — identifica o tipo de tarefa e recomenda o bundle de skills ideal.
---

<!-- ROUTER:START -->

**Guardrails**

- NÃO execute nenhuma tarefa neste workflow. Apenas diagnostique e recomende.
- Seja explícito na recomendação — diga exatamente quais skills ativar.
- Se o tipo de tarefa estiver ambíguo, pergunte antes de recomendar.

**Objetivo**

Analisar a descrição da tarefa do usuário e recomendar:
1. O bundle de skills ideal
2. Skills individuais adicionais se necessário
3. O workflow correto para iniciar

**Steps**

1. **Leia a descrição da tarefa** fornecida pelo usuário.

2. **Classifique o tipo de tarefa** usando esta tabela:

| Tipo de tarefa | Palavras-chave indicadoras | Bundle recomendado |
|---------------|---------------------------|-------------------|
| Planejamento / nova feature estrutural | "planejar", "propor", "nova funcionalidade", "arquitetura", "como deveria funcionar" | `planning-mode` |
| Implementação full-stack | "implementar", "criar", "adicionar feature", "vibe-apply" | `fullstack-dev` |
| Criação de UI visual pesada | "criar tela", "prototipar", "gerar UI", "nova página visual", ">200 linhas JSX" | `stitch-visual` |
| Debugging | "não funciona", "erro", "bug", "debugar", "investigar", "logs mostram" | `debugging-strategies` (skill individual) |
| Auditoria de segurança | "segurança", "RLS", "autenticação", "endpoint público", "auditoria" | `security-auditor` (skill individual) |
| API / Edge Function | "endpoint", "Edge Function", "API", "webhook" | `planning-mode` + `api-design-principles` |
| Commit / PR / Release | "commitar", "PR", "pull request", "release", "merge" | `ship-mode` |
| Qualidade / lint | "lint", "TypeScript errors", "any", "qualidade" | `lint-and-validate` (skill individual) |
| Review de código | "revisar código", "code review", "olhar o diff" | `ship-mode` |

3. **Emita a recomendação** neste formato:

```
## 🗺️ Route Task — Diagnóstico

**Tipo identificado**: [tipo]
**Bundle recomendado**: [bundle]
**Skills adicionais**: [se houver]

**Workflow a iniciar**: [/vibe-proposal ou /vibe-apply ou nenhum]

**Por que este bundle?**
[Justificativa em 1-2 frases]

**Para ativar, diga**:
> "Ative o bundle [nome] para esta tarefa."
```

4. **Se a tarefa tiver múltiplas fases** (ex: "planejar E implementar"):
   - Recomende começar com `planning-mode`
   - Informe que após aprovação do spec, mudar para `fullstack-dev`
   - **Nunca** recomendar implementação sem spec aprovado primeiro

**Reference**

- Bundles disponíveis: `.agent/bundles/`
- Manifesto completo: `.agent/manifests/skill-manifest.yaml`
- Catálogo navegável: `.agent/catalog/README.md`
- Política de ativação: `.agent/policies/activation-rules.md`

<!-- ROUTER:END -->
