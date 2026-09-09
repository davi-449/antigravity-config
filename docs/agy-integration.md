# 🚀 Integração agy CLI como Worker Headless

## 1. O que é o agy CLI no contexto v6?

O `agy.exe` (Antigravity CLI) é o utilitário de linha de comando oficial do ecossistema Google Antigravity. No Antigravity Config v6, ele opera como um **processo filho isolado no sistema operacional** para execução paralela não bloqueante de Workers especializados.

## 2. Modelo de Execução Primário

- **Modelo Padrão:** `gemini-3.1-pro-high` (configurável via `schemas/agy-task.schema.json`)
- **Flags Mandatórias:**
  - `--print`: Garante execução não interativa headless.
  - `--output-format json`: Força a saída em formato estruturado.
  - `--dangerously-skip-permissions`: Evita prompts de autorização no terminal.
  - `--agent <worker-name>`: Carrega as diretrizes específicas do worker.

## 3. Script de Orquestração (`scripts/spawn-agy-worker.ps1`)

O helper `spawn-agy-worker.ps1` encapsula o ciclo de vida do worker:
1. Localiza o executável `agy.exe` (PATH ou WinGet packages).
2. Configura redirecionamento de stdout e stderr em arquivos temporários seguros.
3. Monitora o timeout configurado (padrão 300 segundos).
4. Caso o tempo expire, o processo é encerrado de forma determinística e o fallback é acionado.
5. Converte o resultado para o contrato `schemas/worker-output.schema.json`.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/spawn-agy-worker.ps1 `
  -TaskPrompt "Implementar server action para upload de avatar" `
  -WorkerAgent "backend-worker" `
  -Model "gemini-3.1-pro-high" `
  -TimeoutSeconds 300
```

## 4. Fallback Automático para Subagentes Nativos

Se o `agy.exe` não estiver disponível no ambiente, abortar com código diferente de zero ou exceder o timeout, o Lead imediatamente faz o fallback para o comando nativo:

```powershell
# Fallback nativo no Antigravity 2.0:
invoke_subagent(
  Subagents = @(
    @{
      TypeName = "self",
      Role = "Backend Implementation Worker",
      Prompt = "Execute a task com base na skill backend-patterns..."
    }
  )
)
```

## 5. Escolha Manual do Usuário (`--Native`)

O usuário pode forçar a desativação do agy CLI e utilizar 100% de agentes nativos através da flag `-Native` durante o bootstrap:
```powershell
powershell -ExecutionPolicy Bypass -File setup/install.ps1 -Native
```
