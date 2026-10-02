# SDD Design — Modernização Antigravity v2.17 – v2.19.1 & Arquitetura de Subagentes

## Arquitetura de Orquestração com Subagentes Read-Only

`
                        ┌──────────────────────────────────────────────┐
                        │            AGENTE PRINCIPAL (AGY)            │
                        │  - Concurrency: 1                            │
                        │  - Contexto limpo e focado                   │
                        │  - Único autorizado a escrever código e testar│
                        └───────┬──────────────────────────────┬───────┘
                                │                              │
                Delega Varredura Interna               Delega Busca Externa
                                │                              │
                                ▼                              ▼
        ┌───────────────────────────────┐      ┌───────────────────────────────┐
        │        codebase-scout         │      │        web-researcher         │
        │  - commandExecutionPolicy: off│      │  - commandExecutionPolicy: off│
        │  - tools: view_file, grep     │      │  - tools: search_web, read_url│
        │  - Retorna síntese em 5 linhas│      │  - Retorna resumo sem lixo    │
        └───────────────────────────────┘      └───────────────────────────────┘
`

---

## Contratos dos Novos Subagentes

### 1. codebase-scout.md
`yaml
---
name: codebase-scout
description: Varre o código interno, rastreia dependências e interfaces legadas sem poluir o contexto do agente principal.
tools:
  - view_file
  - grep_search
mainAgent: false
subagent: true
model: inherit
commandExecutionPolicy: off
---
`

### 2. web-researcher.md
`yaml
---
name: web-researcher
description: Pesquisa documentações externas, bibliotecas, RFCs e exemplos no GitHub via web sem carregar lixo HTML no agente principal.
tools:
  - search_web
  - read_url_content
mainAgent: false
subagent: true
model: inherit
commandExecutionPolicy: off
---
`

### 3. Schema .gemini/config.json
`json
{
   : https://raw.githubusercontent.com/google/antigravity/main/schemas/project-config.json,
  version: 2.0,
  planReviewPolicy: whenJudgedWorthwhile,
  permissions: {
    protectedPaths: [
      .git/**,
      .env*,
      .vscode/**
    ],
    commandExecution: prompt
  },
  rules: {
    inheritGlobal: true,
    projectRulePath: .agent/rules/ia.md
  }
}
`

---

## Cenários Obrigatórios

### Happy Path
1. Agente principal precisa planejar uma integração que exige ler 30 arquivos legados de tipos.
2. Agente dispara invoke_subagent com codebase-scout.
3. codebase-scout roda em conversa isolada, lê os arquivos com iew_file e grep_search.
4. codebase-scout retorna mensagem estruturada com interfaces encontradas.
5. Agente principal incorpora o resumo na spec sem consumir 50.000 tokens de leituras intermediárias.

### Edge Case
1. web-researcher encontra uma página web com scripts ou links externos que tentam sugerir comandos de terminal.
2. A política commandExecutionPolicy: off bloqueia categoricamente qualquer tentativa de invocação de terminal pelo subagente.
3. Apenas dados textuais e referências são devolvidos com segurança.

---

## Critérios de Aceitação Verificáveis
1. **Definições de Subagentes Válidas**: codebase-scout.md e web-researcher.md criados em .agents/agents/ com schemas válidos.
2. **Template de Configuração**: 	emplates/project-gemini-config.json válido e testado com ConvertFrom-Json.
3. **Deploy Engine Atualizado**: scripts/deploy-to-projects.ps1 propaga novos agentes para os 19 projetos.
4. **Harness de Testes Aprovado**: 	ests/config-safety/textual.ps1 e
un.ps1 passam com 100%.
