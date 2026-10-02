# Cenários históricos v6

Estes três fixtures verificavam roteamento do `agy CLI`, hierarquia de leads/workers e políticas de host que não compõem a configuração ativa. Foram preservados para consulta, mas não entram em `scripts/run-evals.ps1`.

O teste textual ativo continua em `tests/eval-harness/fixtures/` e `tests/config-safety/textual.ps1`. Teste de comportamento do agente exige `scripts/run-behavior-evals.ps1` com transcript real do Antigravity 2.0 e estado final do repositório descartável.
