# ðŸ“– Manual de OperaÃ§Ã£o Unificado: Antigravity 2.0 (Native AGY Edition)

Este manual Ã© a fonte oficial de consulta e governanÃ§a para desenvolvedores e agentes no ecossistema **Google Antigravity 2.0 (AGY)**.
Ele define a doutrina de execuÃ§Ã£o, o ciclo determinÃ­stico de desenvolvimento (SDD), a integraÃ§Ã£o com o grafo topolÃ³gico e o padrÃ£o visual semÃ¢ntico.

---

## 1. Fundamentos da Doutrina Operacional

O agente lÃª o cÃ³digo antes de propor uma soluÃ§Ã£o, muda apenas o escopo aprovado e mostra o que conseguiu verificar. Para o usuÃ¡rio, explica o resultado em portuguÃªs simples; a spec e o diff guardam os detalhes tÃ©cnicos.

### Os TrÃªs Pilares InviolÃ¡veis:
1. **Agente principal responsÃ¡vel:**
   - A engenharia de software Ã© executada diretamente pelo agente raiz do Antigravity.
   - Skills tÃ©cnicas sÃ£o escolhidas pelo domÃ­nio, sem criar uma equipe fixa por linguagem.
   - O `sdd-reviewer` pode revisar em leitura uma decisÃ£o incerta ou sensÃ­vel. O agente principal confere os achados. `/council` continua sob demanda explÃ­cita.
2. **Output Policy Anti-Waffling:**
   - ComunicaÃ§Ã£o simples para o usuÃ¡rio: o que muda, por que, o que foi testado e o prÃ³ximo passo.
   - Detalhes tÃ©cnicos ficam na spec e no diff; resultados nÃ£o verificados sÃ£o nomeados como tal.
3. **GovernanÃ§a por Ferramentas e Guardrails:**
   - O agente nunca toma aÃ§Ãµes destrutivas (`git reset --hard`, exclusÃ£o de branches, force push) sem autorizaÃ§Ã£o explÃ­cita humana.

---

## 2. O Ciclo de Vida SDD (Spec-Driven Development)

O desenvolvimento Ã© estruturado em uma mÃ¡quina de estados finita determinÃ­stica de 4 fases, com **Hard Stops (paradas obrigatÃ³rias)** entre elas:

```
[ Ideia / Tarefa ]
        â”‚
        â–¼
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚  /sdd-proposal   â”‚ â”€â”€(Mapeia Blast Radius com Graphify + Cria TrÃ­ade SDD)
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”˜
          â”‚
    ðŸ›‘ [HARD STOP: AprovaÃ§Ã£o Humana ObrigatÃ³ria]
          â”‚
          â–¼
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚    /sdd-apply    â”‚ â”€â”€(EdiÃ§Ã£o CirÃºrgica + Build Gate no Terminal)
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”˜
          â”‚
    ðŸ›‘ [HARD STOP: Teste Humano em Localhost]
          â”‚
          â–¼
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚   /sdd-archive   â”‚ â”€â”€(MemÃ³ria Obsidian + graphify update + Staging Seletivo + Commit)
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
          â”‚
          â””â”€â–º Em caso de falhas complexas ou bugs: /sdd-debug
```

### 1. `/sdd-proposal <feature>` (Fase de Planejamento)
* **Objetivo:** Transformar a solicitaÃ§Ã£o em uma especificaÃ§Ã£o fÃ­sica determinÃ­stica em `specs/<feature>/`.
* **AÃ§Ãµes:**
  1. Consulta a inteligÃªncia topolÃ³gica via `graphify explain "<modulo>"` para mapear o **Blast Radius** (quem depende dos arquivos a serem tocados).
  2. Consulta a memÃ³ria modular em `.agent/memory/` e o catÃ¡logo de features em `specs/global/features.md`.
  3. Gera os 3 documentos: `proposal.md` (escopo e contratos), `design.md` (arquitetura e critÃ©rios de aceitaÃ§Ã£o) e `spec-plan.md` (checklist atÃ´mico de tasks).
* **Parada ObrigatÃ³ria:** **PROIBIDO** gerar cÃ³digo de implementaÃ§Ã£o nesta fase. A IA encerra o turno e aguarda aprovaÃ§Ã£o explÃ­cita.

### 2. `/sdd-apply <feature>` (Fase de ImplementaÃ§Ã£o CirÃºrgica)
* **Objetivo:** Executar o checklist aprovado do `spec-plan.md`.
* **AÃ§Ãµes:**
  1. Aplica alteraÃ§Ãµes arquivo a arquivo via ediÃ§Ãµes cirÃºrgicas pontuais (`replace_file_content`). **Proibida a reescrita de arquivos inteiros.**
  2. Atualiza o status das tasks no `spec-plan.md` (`[/] In Progress` -> `[x] Completed`).
  3. Executa o **Terminal Gate**: compilaÃ§Ã£o via `npm run build` no terminal para garantir zero quebras de tipagem e bundling.
  4. **Zero Overhead de Frontend:** Desativados testes de browser/Playwright no apply para garantir velocidade mÃ¡xima e zero latÃªncia.
* **Parada ObrigatÃ³ria:** Ao passar no build, a IA encerra o turno e solicita a validaÃ§Ã£o humana no navegador em localhost.

### 3. `/sdd-archive <feature>` (Fase de ConsolidaÃ§Ã£o e Entrega)
* **Objetivo:** Concluir a feature e garantir a persistÃªncia duradoura do conhecimento.
* **AÃ§Ãµes:**
  1. Registra liÃ§Ãµes aprendidas em `.agent/memory/<categoria>.md` (Obsidian).
  2. Atualiza o grafo de dependÃªncias com `graphify update`.
  3. **PreservaÃ§Ã£o de ResÃ­duos (Step 6.1):** MantÃ©m `.tmp/`, backups `*.bak`, logs e caches brutos de AST (`graphify-out/cache/`) fora do staging; nÃ£o apaga arquivos sem origem verificada.
  4. Move `specs/<feature>` para `specs/archive/<feature>`.
  5. Realiza o commit seletivo via allowlist rigorosa (PROIBIDO `git add .`).

### 4. `/sdd-debug <id-ou-erro>` (Fase de DiagnÃ³stico Forense)
* **Objetivo:** Isolar e reparar bugs que resistem Ã  correÃ§Ã£o inicial.
* **AÃ§Ãµes:**
  1. Inspeciona logs reais e schema do banco via SQL.
  2. Formula atÃ© 3 hipÃ³teses tÃ©cnicas isoladas.
  3. Se uma tentativa falhar, compara o diff inicial com o produzido pela tarefa. Reverte apenas trechos comprovadamente seus; se a autoria for ambÃ­gua, para sem sobrescrever.

---

## 3. InteligÃªncia TopolÃ³gica com Graphify

O **Graphify** Ã© a ferramenta nativa de anÃ¡lise estÃ¡tica e grafo do Antigravity 2.0 (comando de terminal `graphify`, pacote Python `graphifyy`).

### Como Usar:
* **Mapear Impacto de MudanÃ§a:**
  ```bash
  graphify explain "src/features/auth/AuthService.ts"
  ```
  Mostra todas as funÃ§Ãµes, rotas e componentes que dependem deste serviÃ§o, evitando alteraÃ§Ãµes que quebrem outros mÃ³dulos.
* **Buscar no Grafo:**
  ```bash
  graphify query "reconciliaÃ§Ã£o bancÃ¡ria"
  ```
* **Atualizar apÃ³s ImplementaÃ§Ã£o:**
  ```bash
  graphify update
  ```

---

## 4. Design System & Theming Dark SemÃ¢ntico

A regra nÃºmero 1 para evitar a salada visual (cards cinzas misturados com fundos pretos arbitrÃ¡rios) Ã©: **Nenhum componente JSX/HTML pode conter cores brutas ou classes arbitrÃ¡rias.**

### DicionÃ¡rio de Tokens SemÃ¢nticos (`DESIGN.md`):
* `bg-background`: Fundo principal da viewport (Canvas).
* `bg-card`: SuperfÃ­cies elevadas (Cards, containers, painÃ©is).
* `border-border`: Bordas delimitadoras.
* `text-foreground`: Texto de alto contraste (TÃ­tulos e labels principais).
* `text-muted-foreground`: Texto secundÃ¡rio (Legendas, metadados).
* `bg-primary text-primary-foreground`: AÃ§Ãµes principais e botÃµes CTA.

### Como Mudar para "Tudo Preto Absoluto (OLED)" sem Quebrar Nada:
VocÃª **nunca** edita os componentes para trocar cores. VocÃª ajusta apenas o `:root` em `src/globals.css`:
```css
:root {
  --background: 0 0% 0%;       /* Preto absoluto #000000 */
  --card: 0 0% 4%;             /* SuperfÃ­cie quase preta com elevaÃ§Ã£o sutil */
  --border: 0 0% 12%;          /* Borda ultra sutil */
  --foreground: 0 0% 98%;      /* Branco nÃ­tido */
}
```
Como todos os componentes usam `bg-background` e `bg-card`, a aplicaÃ§Ã£o inteira escurece de forma **100% harmÃ´nica e uniforme**, sem deixar nenhum card cinza solto.

---

## 5. DeliberaÃ§Ã£o do Conselho Multi-Agente (`/council`)

O Conselho foi preservado para o seu propÃ³sito real: **discussÃ£o estratÃ©gica e stress-test de decisÃµes arquiteturais difÃ­ceis**. Ele nunca roda sozinho no dia a dia.

### Como Disparar:
```text
/council Devemos migrar nossa autenticaÃ§Ã£o de JWT customizado para Supabase SSR nativo com PKCE?
```

### Estrutura das 3 Rodadas:
1. **Round 1 (PosiÃ§Ãµes):** 4 especialistas analisam o tema sob lentes opostas:
   - `Architect`: Escalabilidade, elegÃ¢ncia de design e acoplamento.
   - `Engineer`: Pragmatismo, viabilidade imediata e facilidade de manutenÃ§Ã£o.
   - `Analyst`: Custos, mÃ©tricas, riscos e ROI.
   - `Contrarian`: Advogado do diabo implacÃ¡vel que busca as falhas fatais da ideia.
2. **Round 2 (RefutaÃ§Ã£o ObrigatÃ³ria):** Cada agente lÃª o consolidado e Ã© obrigado a refutar ou refinar pelo menos 2 argumentos dos colegas.
3. **Round 3 (SÃ­ntese e Veredito):** O `Synthesizer` lÃª a memÃ³ria do debate e emite a decisÃ£o executiva final: `[GO]`, `[NO-GO]` ou `[NEEDS-REWORK]`.

---

## 6. PrevenÃ§Ã£o de RegressÃµes e Conflitos de CÃ³digo

Para garantir que uma alteraÃ§Ã£o de hoje nunca quebre cÃ³digo de anteontem:

1. **Isolamento de Escopo (Blast Radius):** Se o ticket Ã© para arrumar o parser de OFX, o agente sÃ³ tem permissÃ£o de tocar no arquivo do parser. Arquivos de UI, rotas ou tabelas vizinhas estÃ£o congelados.
2. **EdiÃ§Ã£o CirÃºrgica ObrigatÃ³ria:** Ã‰ proibido reescrever o arquivo inteiro. A IA deve usar `replace_file_content` alterando apenas o bloco estritamente necessÃ¡rio.
3. **Rollback Imediato:** Se o build falhar, reverta a alteraÃ§Ã£o (`git checkout -- <arquivo>`) antes de formular nova hipÃ³tese. Nunca construa cÃ³digo em cima de um arquivo jÃ¡ quebrado.
4. **Staging Seletivo:** Nunca use `git add .`. Sempre adicione individualmente apenas os arquivos validados pertencentes Ã quela spec.

---

## 7. PadrÃ£o de Observabilidade (Sentry Breadcrumbs & Capture)

Toda mutaÃ§Ã£o sensÃ­vel ou chamada externa de rede (pagamentos, webhooks, campanhas, envio de mensagens) deve registrar telemetria estruturada antes e durante a execuÃ§Ã£o:

```typescript
import * as Sentry from "@sentry/nextjs";

export async function executeOperation(operationId: string, payload: any) {
  // 1. Breadcrumb estruturado antes de iniciar a operaÃ§Ã£o
  Sentry.addBreadcrumb({
    category: "workflow",
    message: "Iniciando operacao estruturada",
    level: "info",
    data: { operationId, timestamp: new Date().toISOString() },
  });

  try {
    const result = await processAction(payload);
    return { success: true, result };
  } catch (error) {
    // 2. Captura contextual de erro com tags de busca e extras seguros
    Sentry.captureException(error, {
      tags: { feature: "operation-handler", operationId },
      extra: { payloadSafe: sanitize(payload) },
    });
    throw error;
  }
}
```

---

## 8. GitHub Flow & Pipeline de Qualidade CI/CD

Para garantir que o cÃ³digo sÃ³ entre em produÃ§Ã£o apÃ³s auditoria automÃ¡tica:

### 1. Ciclo de Branches e Issues:
* **Issue ObrigatÃ³ria:** Aberta via `gh issue create` com requisitos e critÃ©rios de aceite antes de iniciar o cÃ³digo.
* **Branch Dedicada:** `feature/<id>-<nome>` ou `fix/<id>-<nome>`.
* **Pull Request com Fechamento AutomÃ¡tico:**
  - O PR Ã© aberto com o template canÃ´nico de `.github/PULL_REQUEST_TEMPLATE.md`.
  - A descriÃ§Ã£o **DEVE** conter `Closes #ID` para vincular e encerrar a issue no merge.

### 2. Pipeline de Qualidade no GitHub Actions (`.github/workflows/quality.yml`):
Todo PR disparado para a branch `main` executa:
1. `bun run lint`: ValidaÃ§Ã£o estÃ¡tica de estilo (Biome / ESLint).
2. `bun run typecheck`: CompilaÃ§Ã£o TypeScript estrita (`tsc --noEmit`).
3. `bun run test`: Testes unitÃ¡rios de regras de negÃ³cio.
4. `bun run build`: CompilaÃ§Ã£o final limpa de produÃ§Ã£o.

### Evals das proteÃ§Ãµes SDD

`scripts/run-evals.ps1` verifica texto de regras; seu relatÃ³rio usa `evidence_level=rule_text_only`. Para avaliar comportamento, execute `scripts/run-behavior-evals.ps1 -Mode Prepare -CaseId <caso>`, abra o `workspace` retornado no **Antigravity 2.0** e envie o `prompt` retornado. Depois execute `-Mode Verify -CaseId <caso> -WorkspacePath <workspace> -TranscriptPath <caminho-do-transcript.jsonl>`. O verificador confere chamadas de ferramenta no transcript do AGY 2.0 e o estado final do repositÃ³rio descartÃ¡vel. Transcript ausente, insuficiente ou de outra execuÃ§Ã£o resulta em `NAO_VERIFICADO`; `PREPARADO` tambÃ©m nÃ£o Ã© um teste aprovado. O CLI nÃ£o substitui esta validaÃ§Ã£o.

---

## 9. Antigravity 2.0 (v2.17 â€“ v2.19) â€” Novas Capacidades Nativas

### 1. Subagentes Especializados de Pesquisa
- **`codebase-scout`**: Varre centenas de arquivos de cÃ³digo, interfaces e dependÃªncias legadas.
- **`web-researcher`**: Consulta documentaÃ§Ãµes oficiais, RFCs e exemplos no GitHub via web.
- **Direct Subagent Messaging**: Envie mensagens e perguntas diretamente para a caixinha de um subagente na interface sem intermediar pelo agente raiz.
- **Isolamento de Worktree**: Subagentes utilizam Git Worktrees isolados fora do diretÃ³rio de trabalho, impedindo arquivos temporÃ¡rios de pesquisa de sujarem o Git.

### 2. ConfiguraÃ§Ã£o CanÃ´nica `<project>/.gemini/config.json`
- O Antigravity 2.0 padroniza a configuraÃ§Ã£o de projetos em `.gemini/config.json`.
- ConfiguraÃ§Ãµes de permissÃ£o estrita (`.git/**`, `.env*`, `.vscode/**`) sÃ£o aplicadas nativamente pelo runtime da aplicaÃ§Ã£o.

### 3. RecuperaÃ§Ã£o Ãgil com Conversation-Only Undo
- O diÃ¡logo de desfazer (Undo) agora oferece a opÃ§Ã£o de reverter apenas os turnos da conversa mantendo todas as modificaÃ§Ãµes de arquivos intactas no disco. Ãštil para refazer perguntas sem perder cÃ³digo implementado.

### 4. ExportaÃ§Ã£o de Documentos e Specs para PDF
- Qualquer arquivo Markdown ou artefato aberto no painel lateral pode ser exportado para PDF formatado (com suporte a cÃ³digo colorido, tabelas e diagramas Mermaid) pelo menu de opÃ§Ãµes do painel lateral.

---

**Antigravity 2.0 â€” Engenharia DeterminÃ­stica, RÃ¡pida e ImpecÃ¡vel.**
