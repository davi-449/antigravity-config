# Como Usar as Skills

Skills são playbooks que ensinam ao agente como executar tarefas com mais qualidade e consistência.

---

## O que é uma skill?

Uma skill é um arquivo `SKILL.md` que define:
- **Quando usar** — gatilhos de ativação
- **Quando NÃO usar** — gatilhos de supressão
- **Instruções** — como o agente deve se comportar
- **Checklists** — critérios de saída
- **Exemplos** — padrões de código ou comportamento

---

## Ativando uma skill

### Via texto natural
```
Use brainstorming para planejar esta mudança de schema.
Use debugging-strategies para investigar este erro de autenticação.
Use security-auditor para revisar esta Edge Function.
```

### Via bundle
```
Ative o bundle planning-mode para esta feature.
Ative o bundle ship-mode antes de commitar.
```

### Via workflow
```
/vibe-proposal "nome da feature"    → ativa planning-mode automaticamente
/ship-pr                             → ativa ship-mode automaticamente
/route-task                          → recomenda o bundle correto
```

---

## Skills disponíveis por área

### 📋 Planejamento
| Skill | Quando invocar |
|-------|---------------|
| `brainstorming` | Antes de qualquer feature nova |
| `architecture-review` | Decisões arquiteturais estruturais |
| `api-design-principles` | Ao criar APIs ou Edge Functions |

### 🎨 Frontend / UI
| Skill | Quando invocar |
|-------|---------------|
| `design-md` | Documentar design system Stitch |
| `enhance-prompt` | Otimizar prompt antes de enviar ao Stitch |
| `stitch-loop` | Gerar site/app multi-página |
| `react-components` | Converter Stitch → componentes React |
| `shadcn-ui` | Trabalhar com shadcn/ui |
| `remotion` | Gerar vídeo de walkthrough |
| `frontend-design` | Padrões de UI/UX React |

### 🗄️ Backend / Supabase
| Skill | Quando invocar |
|-------|---------------|
| `supabase-best-practices` | Qualquer operação de banco |

### 🔍 Debugging
| Skill | Quando invocar |
|-------|---------------|
| `debugging-strategies` | Qualquer bug ou comportamento inesperado |

### ✅ Qualidade
| Skill | Quando invocar |
|-------|---------------|
| `test-driven-development` | Ao escrever features com testes |
| `lint-and-validate` | Antes de qualquer commit |
| `code-review` | Self-review ou review de PR |

### 🔒 Segurança
| Skill | Quando invocar |
|-------|---------------|
| `security-auditor` | Novos endpoints, RLS, dados sensíveis |

### 🚀 Release
| Skill | Quando invocar |
|-------|---------------|
| `create-pr` | Ao preparar PR |

---

## Limite de contexto

**Máximo 5 skills ativas simultaneamente.**  
Se mais estiverem ativas, use `/skill-audit` para diagnosticar e desativar as menos relevantes.

---

## Adicionando uma nova skill

1. Criar `skills/<nome>/SKILL.md` seguindo o formato existente
2. Adicionar à seção `skills:` em `.agent/manifests/skill-manifest.yaml`
3. Atualizar `.agent/catalog/README.md`
4. Se importada do upstream: seguir `.agent/policies/sync-upstream.md`

### Template mínimo de SKILL.md
```markdown
---
name: minha-skill
description: "Uma linha descrevendo o que esta skill faz."
risk: safe
source: original | upstream (...)
imported_on: "YYYY-MM-DD"
category: [planning|frontend|backend|debugging|quality|security|devops]
---

## Use this skill when
- [gatilho 1]
- [gatilho 2]

## Do not use this skill when
- [supressor 1]

## Instructions
[Passo a passo de como operar com esta skill ativa]

## Limitations
- [limitação 1]
```
