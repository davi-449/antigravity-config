# Como usar as skills

Uma skill é um guia de trabalho. O agente principal usa a skill da fase SDD e consulta o domínio afetado pelo pedido, como UI, backend, banco, autenticação ou segurança. Veja a lista real em [skills/INDEX.md](../skills/INDEX.md).

Exemplo: para alterar uma Server Action existente, peça `/sdd-proposal <id>`. O agente lê o arquivo e consulta `backend-patterns`, registra por que editar é melhor do que criar outra função e para para sua aprovação. Depois, `/sdd-apply <id>` executa e verifica a tarefa.

O `sdd-reviewer` é um subagente opcional de leitura para decisões incertas. Ele não escreve nem valida testes. Não carregue todas as skills para uma mudança pequena.
