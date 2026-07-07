---
description: Executa a implementação técnica baseada nas tasks.md, utilizando as skills especialistas.
---

<!-- VIBEAPPLY:START -->

**Objetivo**
Executar o checklist definido no `tasks.md` da spec atual com extrema precisão, usando o máximo das capacidades técnicas injetadas via ClawHub.

**Skills ativas obrigatórias**
- **Frontend**: Invoque as skills `frontend-design-pro`, `frontend-design-3` e `afrexai-nextjs-production` para ditar o padrão de UI, qualidade do React, Tailwind e regras de arquitetura frontend.
- **Backend**: Invoque as skills `backend` e `supabase` para gerenciar as rotas, Edge Functions, RPCs e Migrations com segurança (RLS obrigatório).
- **Memória Em Tempo Real**: Mantenha no "scratchpad" (sua memória temporária) qualquer erro bizarro ou preferência do usuário dita no meio do percurso, para ser consolidada no `/vibe-archive`.

**Steps**

1. Abra o arquivo `specs/<id>/tasks.md`.
2. Para cada task, decida se é frontend ou backend e ative as skills correspondentes mentalmente e em suas ferramentas.
3. Escreva o código seguindo ESTRITAMENTE as melhores práticas das skills do ClawHub e da memória do projeto lida anteriormente.
4. Se houver mudanças nos requisitos durante o percurso, anote-as para não esquecer.
5. Avise o usuário quando a spec terminar de ser implementada, instruindo-o a revisar e depois rodar `/vibe-archive <id>`.

## Auto-healing Atômico & Strict Rollback

- Se durante a implementação ocorrerem erros de build, testes falhando ou falhas catastróficas apontadas pelo Visual QA, você entra em modo de *Auto-healing*.
- **O Limite Categórico:** Você tem **EXATAMENTE 3 tentativas** para corrigir o erro.
- **O Rollback:** Se a 3ª tentativa falhar, PARE IMEDIATAMENTE. Não tente uma 4ª vez. Execute um `git reset --hard` para reverter o repositório ao último estado funcional pré-modificação, notifique o usuário da falha estrutural e solicite reavaliação arquitetural. Isso previne a degradação irreversível da codebase.

## Infra-aware apply & Remote infra execution

Antes de aplicar qualquer mudança, leia `.antigravity/state.json` e detecte o impacto da mudança (UI only, app + deploy, app + backend, backend only, infra only).

Se `supabase.mode=self_hosted_vps` e houver impacto de infra/backend:
1. Assumir acesso SSH remoto ao host da VPS via credenciais (ou referências de env).
2. Instalar dependências se necessário (Git, Docker, Docker Compose).
3. Provisionar ou reconciliar o Supabase oficial no host remoto via Docker (`git clone supabase/supabase`, gerar chaves, `docker compose up -d`).
4. Configurar DNS Cloudflare via chamadas de API (`POST` para criar records `A` para `api`, `studio`, `app`).
5. Atualizar envs do app.
6. Se `lovable.enabled=true`, instruir o MCP (caso ativado no futuro) ou o código do app a se conectar à instância Supabase remota recém-criada.

## Multimodal Visual QA (VLM Loop)

Se a mudança envolver UI/Frontend:
1. **É TERMINANTEMENTE PROIBIDO AFIRMAR "NÃO TENHO OLHOS" OU PEDIR AO USUÁRIO PARA TESTAR VISUALMENTE.** Como IA, você DEVE criar ou executar ativamente um script headless (ex: Playwright/Puppeteer/Browser Tool) que abra o `localhost` (ou porta especificada) em background e salve uma screenshot em disco.
2. Se a rota for protegida, injete as credenciais de teste (recuperadas do `.env` da IA) no script de navegação.
3. Utilize sua capacidade multimodal (VLM) nativa para ler a screenshot gerada.
4. Analise rigorosamente a imagem: O layout quebrou? Há CSS sobreposto? Se houver erro visual, reinicie o loop de *Auto-healing* e só avise o usuário quando a imagem provar que a interface está impecável.

<!-- VIBEAPPLY:END -->
