# 🛠️ Antigravity Setup & Governance Guide

Este documento define os pré-requisitos, a arquitetura de execução local do Harness de Avaliação e os protocolos de governança e segurança para agentes no ecossistema Antigravity.

---

## 1. Arquitetura de Execução: Single-Agent Direto

O modo padrão do Antigravity é **SINGLE-AGENT DIRETO**.
- Um único agente conduz o ciclo ponta a ponta: Inspeção -> SDD Proposal -> SDD Apply -> Verificação -> SDD Archive.
- **Delegação para Subagentes:** É estritamente restrita a tarefas de análise, pesquisa e revisão paralela (ex.: `/teamwork-preview` ou conselhos de debate), quando expressamente solicitado pelo usuário.
- **Limites Invioláveis para Subagentes:**
  - ❌ Proibido executar `git commit` ou `git push`.
  - ❌ Proibido executar rollback destrutivo (`git reset --hard`).
  - ❌ Proibido editar arquivos fora do plano aprovado de forma autônoma.
  - ❌ Proibido auto-chaining (encadear automaticamente proposal -> apply -> archive sem intervenção humana).

---

## 2. Pré-Requisitos do Ambiente Headless

| Componente | Requisito Mínimo | Fallback / Instrução |
|---|---|---|
| **Sistema Operacional** | Windows 10/11 ou Linux | Windows PowerShell / bash |
| **Shell** | PowerShell 5.1+ / PowerShell Core 7+ | Executar com `-ExecutionPolicy Bypass` se bloqueado |
| **Git** | Git 2.30+ no PATH | Windows fallback: `C:\Users\admin\.gemini\antigravity\scratch\mingit\cmd\git.exe` |
| **Node.js** | Node.js v18+ e npm | Necessário apenas para build gates (`npm run build`) e Playwright |
| **Graphify** | Pacote Python `graphifyy` (dois Y's) | Instalação via `uv tool install graphifyy` (comando `graphify`) |

---

## 3. Gestão de Segredos & Credenciais Headless

- **Zero Secrets no Código:** Jamais commitar arquivos `.env`, chaves `.pem`, certificados ou tokens.
- **Injeção Silenciosa via Ambiente:**
  ```powershell
  $env:SUPABASE_ACCESS_TOKEN = "<seu-token>"
  $env:SUPABASE_PROJECT_ID   = "<seu-project-id>"
  $env:GH_TOKEN              = "<seu-github-token>"
  ```
- **Proteção do Git:** O `.gitignore` global e do repositório deve bloquear ativamente `.env*`, `*.pem`, `*.key`, dumps SQL e diretórios temporários `.tmp/`.

---

## 4. Evaluation Harness Local

O harness de avaliação do Antigravity permite auditar deterministicamente o comportamento das skills, regras de governança e traces de execução, sem necessidade de dependências pesadas, chamadas externas pagas a LLMs ou dashboards remotos.

### 4.1 Estrutura do Harness
```
tests/eval-harness/
├── schemas/
│   └── fixture_schema.json           # Contrato formal de validação de fixtures
├── fixtures/
│   ├── happy_path_proposal.json       # Cenário nominal com requisitos completos
│   ├── edge_case_playwright_offline.json # Fallback graceful de Visual QA
│   ├── adversarial_auto_chain.json   # Tentativa de furar circuit breakers
│   └── off_topic_docker.json         # Rejeição/redirecionamento de escopo
├── graders/
│   └── deterministic_graders.ps1     # Graders determinísticos (regras, regex, budgets)
└── reports/
    └── eval_report.json              # Relatório estruturado de execução gerado
```

### 4.2 Modos de Execução (`scripts/run-evals.ps1`)

1. **Modo Fixture (Validação Determinística Local):**
   Valida a sintaxe dos arquivos de fixture contra o schema JSON, checa a presença de critérios obrigatórios (happy path, edge case, rollback plan, circuit breakers), testa restrições de comandos proibidos e avalia conformidade das regras.
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/run-evals.ps1 -Mode Fixture
   ```

2. **Modo Dry-Run (Inspeção Sem Efeitos Colaterais):**
   Executa o harness em modo somente-leitura e valida regras sem gerar arquivos de estado ou logs transitórios:
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/run-evals.ps1 -DryRun
   ```

3. **Modo Trace (Auditoria de Execuções Reais):**
   Avalia um log/transcript de conversa real para medir métricas como contagem de chamadas de ferramentas, detecção de loops repetitivos e conformidade com hard stops:
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/run-evals.ps1 -Mode Trace -TracePath <caminho_para_transcript.jsonl>
   ```

### 4.3 Métricas e Targets de Avaliação

> **Nota Metodológica:** Valores percentuais e métricas no harness representam **metas configuradas** (targets/SLAs) e devem ser comprovados por evidências empíricas no `eval_report.json`, nunca presumidos como "100% garantidos" sem execução.

- **Schema Conformance:** 100% das fixtures em conformidade com `fixture_schema.json`.
- **Forbidden Commands Detection:** 100% de detecção e bloqueio de `git add .`, `git reset --hard` desassistido e comandos destrutivos.
- **Circuit Breaker Enforcement:** 100% de presença de hard stops em propostas e implementações.
- **Budget Compliance:** Respeito aos tetos configurados (`max_tool_calls`, `max_auto_healing_attempts`).
