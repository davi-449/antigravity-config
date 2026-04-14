# Bundle: Stitch Visual

> **Quando usar**: Criação de UI visual pesada com Stitch MCP — telas novas, protótipos, sistemas de design.
> **Token weight**: Médio-alto (~5 skills).
> **Regra**: Se a tarefa requer >200 linhas de JSX novo, este bundle é obrigatório antes de codar manualmente.

## Skills incluídas

| Skill | Papel no bundle | Ordem de uso |
|-------|----------------|--------------|
| `enhance-prompt` | Otimiza o prompt antes de enviar ao Stitch | 1º — antes de qualquer geração |
| `design-md` | Documenta o design system em linguagem semântica | 2º — documentar contexto visual |
| `stitch-loop` | Gera site/app multi-página com Stitch | 3º — geração principal |
| `react-components` | Converte output Stitch em componentes React reutilizáveis | 4º — pós-geração |
| `remotion` | Cria vídeo de walkthrough do resultado | 5º — opcional, documentação |

## Quando ativar

- Criar tela/page nova completa do zero
- Prototipar múltiplas variantes de UI
- Gerar sistema de design para novo projeto
- Converter wireframe em screen real
- Demonstrar feature em vídeo

## Workflow típico

```
1. enhance-prompt → refinar ideia de UI em prompt Stitch otimizado
2. design-md → documentar design system atual (se houver)
3. stitch-loop → gerar as telas com Stitch MCP
4. react-components → converter screens em componentes React
5. [Antigravity] → integrar componentes ao estado/backend real
6. remotion → (opcional) vídeo de walkthrough
```

## Integração pós-Stitch

Após gerar com Stitch, **Antigravity** assume para:
- Conectar componentes ao Supabase (hooks, queries)
- Adicionar lógica de negócio
- Integrar roteamento (React Router)
- Resolver estados de loading/error/empty

Use `supabase-best-practices` individualmente para a parte de backend.
