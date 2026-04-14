# Getting Started — antigravity-config

Bem-vindo ao `antigravity-config` — repositório de configuração de skills, workflows e regras de orquestração para o Gemini CLI / Antigravity.

---

## O que é este repositório?

Este repo contém:
- **Skills curadas** — playbooks que ensinam ao agente como executar tarefas específicas
- **Bundles** — agrupamentos de skills por tipo de tarefa
- **Workflows** — sequências de passos guiados (slash commands)
- **Regras** — princípios de orquestração anti-vibe-coding
- **Políticas** — contexto, ativação e sync com upstream

---

## Estrutura rápida

```
.agent/
├── rules/ia.md           ← Regras principais (FONTE DA VERDADE)
├── workflows/            ← Slash commands (/vibe-proposal, /route-task, etc.)
├── manifests/            ← skill-manifest.yaml (catálogo central)
├── bundles/              ← Agrupamentos de skills por tipo de tarefa
├── catalog/              ← Índice navegável de skills
└── policies/             ← context-budget, activation-rules, sync-upstream

.antigravity/
└── rules.md              ← Espelho das regras principais

skills/                   ← Todas as skills (SKILL.md)
docs/                     ← Documentação
setup/                    ← Scripts de instalação
```

---

## Instalação (novo ambiente)

### Linux / macOS
```bash
bash setup/install.sh
```

### Windows (PowerShell)
```powershell
.\setup\install.ps1
```

---

## Primeiros passos

### 1. Verificar que as regras estão carregadas
As regras em `.agent/rules/ia.md` e `.antigravity/rules.md` são carregadas automaticamente pelo Gemini CLI/Antigravity.

### 2. Usar um workflow
```
/route-task — receber recomendação de bundle para a tarefa atual
/vibe-proposal "nome da feature" — iniciar planejamento
/skill-audit — verificar sobrecarga de contexto
```

### 3. Ativar um bundle
```
Ative o bundle planning-mode para planejar esta feature.
Ative o bundle fullstack-dev para implementar esta spec.
```

### 4. Usar uma skill individual
```
Use brainstorming para planejar esta mudança.
Use debugging-strategies para investigar este erro.
Use lint-and-validate antes de commitar.
```

---

## Fluxo completo de desenvolvimento

```
1. /route-task  →  identifica o tipo de tarefa
2. /vibe-proposal "feature"  →  spec completo (proposal + design + tasks)
3. /bundle-activate fullstack-dev  →  ativa skills de implementação
4. /vibe-apply <id>  →  implementação guiada pelo spec
5. /ship-pr  →  quality gate + commit semântico + PR
6. /vibe-archive <id>  →  arquiva spec e limpa contexto
```

---

## Próximos passos

- [Ver todos os bundles disponíveis →](bundles.md)
- [Ver catálogo de skills →](../.agent/catalog/README.md)
- [Entender o roteamento →](router-guide.md)
- [Como usar skills →](skills-usage.md)
