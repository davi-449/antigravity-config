# Comece por aqui

Este repositório guarda as regras e skills canônicas do Antigravity 2.0.

1. Leia [o manual](manual-operacao-antigravity.md) para entender as três fases.
2. Use `/sdd-proposal <id>` (ou `/vibe-proposal <id>`) para planejar. O agente para antes de mexer no código.
3. Depois de aprovar o plano, use `/sdd-apply <id>` (ou `/vibe-apply <id>`). O agente implementa, verifica e para para sua revisão.
4. Após sua validação, use `/sdd-archive <id>` (ou `/vibe-archive <id>`) para registrar a entrega.

O agente principal escolhe as skills do assunto usando [o índice](../skills/INDEX.md). Um revisor opcional só lê código quando há decisão incerta. Para testar a distribuição, comece por `scripts/sync-global.ps1 -DryRun` e `scripts/deploy-to-projects.ps1 -DryRun -ProjectName <nome>`. Conflitos são preservados para revisão.

Os guias de bundles e comandos da configuração v6 não fazem parte deste fluxo.
