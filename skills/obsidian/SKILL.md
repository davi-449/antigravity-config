---
name: obsidian
description: Gerenciamento de memória modular do projeto — leitura, escrita e organização dos arquivos .agent/memory/<categoria>.md para garantir continuidade entre sessões.
---

# Obsidian Memory — Guia Operacional para IA

## O que é e quando usar

A skill `obsidian` gerencia a **memória persistente do projeto** em `.agent/memory/`.
Usar esta skill **sempre que**:
- Iniciar uma nova sessão (ler antes de qualquer task)
- Finalizar uma implementação (escrever no archive)
- Encontrar um padrão ou anti-pattern novo (registrar imediatamente)

## Estrutura de Arquivos de Memória

```
.agent/memory/
├── supabase.md      # Schema, RLS, RPCs, padrões de banco
├── ui.md            # Componentes, padrões visuais, paleta, tipografia
├── auth.md          # Autenticação, sessão, tokens, permissões
├── ofx.md           # Parsing OFX, XLSX, CSV, importação financeira
├── infra.md         # Deploy, VPS, SSH, DNS, Cloudflare, domínios
├── domain.md        # Regras de negócio do domínio (conciliação, etc.)
└── [outros].md      # Categorias criadas conforme o projeto evolui
```

## Leitura de Memória (Início de Sessão)

**Ao iniciar qualquer task, leia os arquivos relevantes:**

```
# Sempre leia no início:
view_file .agent/memory/supabase.md     # se envolver banco
view_file .agent/memory/ui.md           # se envolver frontend
view_file .agent/memory/ofx.md          # se envolver importação
view_file .agent/memory/auth.md         # se envolver autenticação
```

**Nunca assuma que você lembra de sessões anteriores.** A memória está nos arquivos, não no contexto.

## Escrita de Memória (Após Implementação)

Ao finalizar uma task (no `/vibe-archive`), escreva no arquivo da categoria correta.

**Formato obrigatório:**
```markdown
## [YYYY-MM-DD] — [Feature ID: <id>]

**Contexto:** O que foi implementado e qual problema resolvia.

**Regra aprendida:** A lógica crítica que não pode ser esquecida.
Ex: "FITIDs de OFX devem ser deduplicados antes do INSERT via chave composta (account_id, fitid)"

**Risco identificado:** O que quase quebrou ou pode quebrar em mudanças futuras.

**Não fazer:** Anti-pattern identificado — o que explicitamente não deve ser tentado.
```

## Regras de Qualidade de Memória

**BOA memória:**
- Específica: "A função `parse_ofx` retorna `null` para FITIDs duplicados — use UPSERT com `ON CONFLICT DO NOTHING`"
- Acionável: pode ser lida e aplicada diretamente na próxima task
- Atômica: cada entrada documenta uma lição, não um resumo geral

**MÁ memória:**
- Vaga: "Cuidado com o banco de dados"
- Genérica: "Lembrar de testar"
- Redundante: copiar o mesmo aprendizado em múltiplas categorias

## Personalização do Projeto

Este projeto usa:
- **Stack**: Next.js + React + Tailwind + Supabase
- **Ambiente**: Windows / PowerShell (usar `cmd.exe /c` para npm)
- **UI constraints**: Dark mode, Zinc-950, sem glassmorphism, Inter/Outfit
- **Auth**: Supabase Auth com JWT — `getUser()` no server, nunca `getSession()`
- **Deploy**: Lovable (frontend) + VPS self-hosted (Supabase)

Esses padrões devem estar em `memory/ui.md` e `memory/infra.md`.
