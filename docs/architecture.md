# Arquitetura ativa do Antigravity 2.0

O agente principal conduz cada fase do SDD. Ele lê o código existente, escolhe as skills pelo assunto e responde pela decisão, pelas edições e pelos testes.

```text
pedido → /sdd-proposal → aprovação → /sdd-apply → revisão humana → /sdd-archive
                        ↘ sdd-reviewer (somente leitura, quando necessário)
```

O `sdd-reviewer` em `.agents/agents/sdd-reviewer.md` é opcional. Use-o quando a escolha entre reutilizar, editar ou criar estiver incerta, houver contrato sensível ou risco de duplicação. O agente principal confere os achados no código. Mudanças simples seguem sem revisão adicional.

As skills em `skills/INDEX.md` são guias por domínio. Elas não representam agentes separados. Os arquivos em `.agent/agents/_archive_multiagent/` e a integração `agy-bridge` documentam a configuração v6 e não fazem parte do roteamento padrão.

`scripts/sync-global.ps1` copia as regras, skills e o revisor para a configuração global. `scripts/deploy-to-projects.ps1` copia recursos aos projetos sem apagar arquivos locais. Arquivos diferentes só são atualizados quando correspondem a uma versão anterior comprovada do mesmo caminho no repositório; conflitos são preservados e relatados.

Testes textuais verificam regras escritas. Testes de comportamento exigem uma execução real no Antigravity 2.0, o trace dessa execução e o estado final de um repositório descartável. Sem trace suficiente, o resultado é `NAO_VERIFICADO`.
