---
name: supabase-best-practices
description: "Best practices for Supabase — migrations, RLS policies, Edge Functions, TypeScript types, and query patterns. Tailored for this project's stack."
risk: safe
source: supabase/agent-skills (upstream reference) + custom adaptation
imported_on: "2026-04-14"
local_adaptation: true
category: backend
---

# Supabase Best Practices

**SEMPRE usar esta skill ao tocar qualquer parte do banco de dados.**  
Adaptada especificamente para este stack: Supabase + Deno Edge Functions + React + TypeScript.

## Critical Rules (Non-Negotiable)

1. **SEMPRE** verificar se a tabela existe antes de criar: `list_tables` via Supabase MCP
2. **SEMPRE** usar `apply_migration` para alterações de schema (nunca SQL direto raw em produção)
3. **SEMPRE** habilitar RLS em tabelas novas
4. **SEMPRE** regenerar tipos TypeScript após mudanças de schema
5. **NUNCA** expor `service_role` key no frontend

---

## Migrations

### Criando uma migration
```bash
# Via CLI local
supabase migration new "add_automation_rules"

# Via Supabase MCP (preferido no Antigravity)
# Usar apply_migration tool com query SQL
```

### Estrutura de Migration
```sql
-- Migration: add_automation_rules
-- Created: YYYY-MM-DD

-- 1. Criar tabela
CREATE TABLE public.automation_rules (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL
);

-- 2. Habilitar RLS (OBRIGATÓRIO)
ALTER TABLE public.automation_rules ENABLE ROW LEVEL SECURITY;

-- 3. Criar políticas
CREATE POLICY "Authenticated users can read automation_rules"
ON public.automation_rules FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Admins can manage automation_rules"
ON public.automation_rules FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE profiles.id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- 4. Index em colunas de busca frequente
CREATE INDEX idx_automation_rules_is_active ON public.automation_rules(is_active);

-- 5. Trigger para updated_at
CREATE TRIGGER update_automation_rules_updated_at
  BEFORE UPDATE ON public.automation_rules
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

---

## RLS — Row Level Security

### Patterns comuns
```sql
-- Usuário acessa apenas seus próprios dados
USING (auth.uid() = user_id)

-- Qualquer autenticado lê, só dono escreve
-- SELECT:
USING (true)
-- INSERT/UPDATE/DELETE:
USING (auth.uid() = user_id)

-- Role-based access
USING (
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid() AND role = ANY(ARRAY['admin', 'manager'])
  )
)

-- Anonimo pode ler (tabela pública)
TO anon, authenticated
USING (true)
```

### Testando RLS
```sql
-- Simular usuário específico
SET LOCAL role = anon;
SELECT * FROM public.automation_rules; -- deve retornar 0 rows

SET LOCAL role = authenticated;
SET LOCAL "request.jwt.claims" = '{"sub": "user-uuid-here"}';
SELECT * FROM public.automation_rules; -- retorna apenas dados do usuário
```

---

## Edge Functions

### Template padrão
```typescript
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    // Validar autorização
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ data: null, error: { code: "UNAUTHORIZED", message: "Missing authorization" } }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Criar cliente Supabase com token do usuário (RLS ativo)
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } }
    );

    // Para operações privilegiadas: usar service_role (sem RLS)
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // Parse body
    const body = await req.json().catch(() => null);
    if (!body) {
      return new Response(JSON.stringify({ data: null, error: { code: "INVALID_BODY", message: "Invalid JSON body" } }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // --- Lógica da função ---

    return new Response(JSON.stringify({ data: result, error: null }), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("Function error:", error);
    return new Response(JSON.stringify({ data: null, error: { code: "INTERNAL_ERROR", message: "Internal server error" } }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
```

---

## TypeScript Types

### Regenerar após mudança de schema
```bash
supabase gen types typescript --local > src/types/database.types.ts
```

### Uso correto
```typescript
import type { Database } from "@/types/database.types";

type ContactRow = Database["public"]["Tables"]["contacts"]["Row"];
type ContactInsert = Database["public"]["Tables"]["contacts"]["Insert"];
type ContactUpdate = Database["public"]["Tables"]["contacts"]["Update"];
```

---

## Queries — Padrões Seguros

```typescript
// ✅ Tratamento de erro correto
const { data, error } = await supabase
  .from("contacts")
  .select("id, name, phone")
  .eq("is_active", true)
  .order("created_at", { ascending: false });

if (error) throw new Error(`Failed to fetch contacts: ${error.message}`);

// ✅ Single record com 404 handling
const { data, error } = await supabase
  .from("contacts")
  .select("*")
  .eq("id", contactId)
  .single();

if (error?.code === "PGRST116") return null; // Not found
if (error) throw error;

// ✅ Upsert
const { data, error } = await supabase
  .from("contacts")
  .upsert({ id: existingId, name: "Updated Name" }, { onConflict: "id" })
  .select()
  .single();
```

## Checklist de nova tabela

- [ ] `list_tables` verificado — tabela não existe ainda
- [ ] Migration criada via `apply_migration`
- [ ] RLS habilitado (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY`)
- [ ] Pelo menos uma política criada (não deixar tabela sem política com RLS ativo)
- [ ] Index em colunas de uso frequente
- [ ] Trigger `updated_at` se relevante
- [ ] Tipos TypeScript regenerados
- [ ] Manifesto de skill e catálogo atualizados (se a mudança for de config)

## Limitations
- Esta skill cobre padrões Supabase. Para design da API REST, use `api-design-principles`.
- Sempre revisar RLS com `security-auditor` antes de ir para produção.
