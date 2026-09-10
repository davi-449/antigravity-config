# 🔬 Antigravity Performance Benchmark Suite

## Visão Geral

Suite de benchmark para medir performance, qualidade de raciocínio e compliance do sistema Antigravity sob diferentes condições de carga de contexto.

## 5 Dimensões Avaliadas

| # | Dimensão | Método | Grading |
|:--|:---|:---|:---|
| 1 | Instruction Adherence | 10 prompts IFEval-style com constraints verificáveis | Determinístico (regex/contains) |
| 2 | Circuit Breaker Compliance | 5 cenários de tentativa de violação | Presence/absence |
| 3 | Reasoning Quality | 5 tasks de código com complexidade crescente | Solução + eficiência |
| 4 | Context Budget | Medição de tokens consumidos por overhead | Ratio overhead/trabalho |
| 5 | Speed & Latency | Cronometragem de 3 tasks padronizadas | Tempo absoluto |

## Como Rodar

```powershell
# Benchmark completo com perfil atual
powershell -ExecutionPolicy Bypass -File tests/benchmark/run-benchmark.ps1 -Profile current

# Após otimizações
powershell -ExecutionPolicy Bypass -File tests/benchmark/run-benchmark.ps1 -Profile optimized

# Comparar resultados
powershell -ExecutionPolicy Bypass -File tests/benchmark/run-benchmark.ps1 -Compare
```

## Estrutura

```
tests/benchmark/
├── README.md                          # Este arquivo
├── fixtures/
│   ├── instruction_adherence.json     # Dim 1: IFEval-style
│   ├── circuit_breaker_stress.json    # Dim 2: Violações
│   ├── reasoning_quality.json         # Dim 3: Tasks de código
│   └── context_budget.json            # Dim 4: Overhead
├── graders/
│   └── benchmark_graders.ps1          # Funções de avaliação
├── reports/
│   ├── baseline_report.json           # Antes das otimizações
│   └── optimized_report.json          # Depois das otimizações
└── run-benchmark.ps1                  # Runner principal
```

## Metodologia

Baseado em:
- **IFEval** (Google) — instruction following verificável
- **SWE-bench** — resolução de bugs em repos reais
- **Golden-PR Replay** — replay de PRs do próprio repo
- **Regra 5-10%** — system prompt deve ocupar <10% da context window
- **Lost in the Middle** — posicionamento de informações críticas
