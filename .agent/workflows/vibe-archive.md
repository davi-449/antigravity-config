---
description: Conclui o fluxo da Spec, consolidando a memória em políticas semânticas, testando o build e enviando para produção de forma segura.
---

<!-- VIBEARCHIVE:START -->

**Objetivo**
Garantir a I.A não sofra amnésia e organize seu aprendizado estruturalmente (Memory Continuum). Transforma o trabalho em memória persistente segmentada e entrega o código seguro no Github via fallbacks resilientes.

**Steps**

1. **Memória Semântica Contínua & Safe Compression**: 
   - NÃO faça um "dump" genérico. Analise os aprendizados da iteração (ex: regras de UI/UX Premium, prevenções de Hook Loops).
   - Ao adicionar novos aprendizados aos arquivos em `.agent/policies/` (ex: `ui-rules.md`), realize uma **Compressão de Memória**.
   - Refatore o documento para mesclar redundâncias e deletar instruções de sintaxe obsoletas para manter o limite ideal de leitura (use `replace_file_content`).
   - **CLÁUSULA DE PROTEÇÃO ABSOLUTA:** Jamais, sob nenhuma hipótese, apague ou altere: (a) Regras de infraestrutura/deploy; (b) Variáveis de ambiente referenciadas; (c) Restrições arquiteturais impostas explicitamente pelo usuário; (d) Fallbacks de segurança. A compressão deve ser cirúrgica e focada apenas em otimização de texto e regras de código puras.

2. **Quality Gate (Build e Resiliência)**: 
   - Execute o comando de build via CMD (`cmd.exe /c "npm run build"`) para evadir do PowerShell Execution Policy e atestar integridade.
   
3. **Commit Controlado & Seguro**: 
   - Tente `git add .`
   - Se `git` não for reconhecido, puxe o fallback absoluto: `C:\Users\admin\.gemini\antigravity\scratch\mingit\cmd\git.exe add .`
   - Use HEREDOCs no bash para fazer o commit de explicações complexas, garantindo que o log acompanhe o SDD. 
   - Lembre-se do Git Identity Override (configurar user/email) se houver falhas. JAMAIAS use `push --force`.

4. **Push Automático**: 
   - `git push origin` ou o fallback MinGit.

5. **Clean Up**:
   - Mova a pasta `specs/<id>` para `specs/archive/<id>` usando a ferramenta `run_command`.

6. Avise o usuário que a Spec foi finalizada e que as políticas semânticas no `Memory Continuum` foram expandidas com sucesso.

## Infra finalization & Deployment reconciliation

Antes de arquivar e ao fechar o ciclo de uma entrega:
1. Verificar se o frontend está publicado (Lovable live_url ou deploy similar).
2. Verificar se a API do Supabase (remota) responde corretamente.
3. Verificar se os subdomínios esperados no Cloudflare (`app`, `api`, `studio`) resolvem.
4. Persistir metadados da infra e URLs finais no `.antigravity/state.json` consolidado e registrar os links no artefato do archive para o usuário testar.

## Lovable Deploy & Archive

1. `deploy_project(project_id)` → captura `live_url`
2. `get_project_analytics_trend(project_id)` → confirma que está online
3. Registra no arquivo de archive:
   - `live_url`
   - `project_id`
   - data de deploy
4. Faz commit do `.antigravity/state.json` atualizado com status `deployed` 

<!-- VIBEARCHIVE:END -->
