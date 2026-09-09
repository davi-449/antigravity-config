# 🌐 Lazyweb MCP Configuration Guide

Instruções para conectar agentes de IA ao repositório visual do **Lazyweb** (mais de 257.000 telas reais de 25.000+ aplicações web).

---

## 1. Identificador e Credencial

- **Setup Bearer Token / Agent ID**: `37f07477-4758-4c37-9610-ad6dc0a9142f`
- **Endpoint HTTP / SSE**: `https://www.lazyweb.com/mcp`
- **Permissão**: Read-only e não-destrutiva (pesquisa de telas e download de capturas de tela para referência de design).

---

## 2. Configuração por Cliente

### Cursor (`.cursor/mcp.json`)
```json
{
  "mcpServers": {
    "lazyweb": {
      "url": "https://www.lazyweb.com/mcp",
      "headers": {
        "Authorization": "Bearer 37f07477-4758-4c37-9610-ad6dc0a9142f"
      }
    }
  }
}
```

### Claude Code CLI
```bash
claude mcp add --transport http lazyweb https://www.lazyweb.com/mcp --header "Authorization: Bearer 37f07477-4758-4c37-9610-ad6dc0a9142f"
```

### Antigravity / Gemini CLI (`mcp.json`)
```json
{
  "mcpServers": {
    "lazyweb": {
      "url": "https://www.lazyweb.com/mcp",
      "headers": {
        "Authorization": "Bearer 37f07477-4758-4c37-9610-ad6dc0a9142f"
      }
    }
  }
}
```

---

## 3. Ferramentas Disponíveis no Agente

Uma vez ativo, o agente pode utilizar:
- `search_screens(query, domain, category)`: Busca telas de referência por fluxo (ex.: "pricing table", "b2b onboarding", "reconciliation table", "command palette").
- `download_screenshot(screen_id)`: Baixa a captura de alta resolução no workspace para análise via VLM / Playwright.
- `get_brand_context(brand_domain)`: Obtém paleta de cores e estilo visual verificado de concorrentes e benchmarks.
