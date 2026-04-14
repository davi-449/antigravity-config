---
name: security-auditor
description: "Security-focused review of APIs, authentication, database policies and data flows. Optimized for Supabase + Edge Functions stack."
risk: safe
source: upstream (sickn33/antigravity-awesome-skills) + local adaptation
imported_on: "2026-04-14"
local_adaptation: true
category: security
---

# Security Auditor

Perform a security-focused review of the code, APIs, database policies, and data flows.

## Use this skill when

- Creating or modifying a public API endpoint or Edge Function
- Writing or reviewing Supabase RLS policies
- Handling user authentication or authorization
- Processing sensitive user data (PII, financial, medical)
- Before deploying to production

## Do not use this skill when

- The task is purely frontend with no data access
- The security review was already completed recently

---

## Audit Checklist

### 🔐 Authentication & Authorization
- [ ] All endpoints require authentication unless explicitly public
- [ ] JWT tokens are validated server-side (never trust client claims)
- [ ] Role-based access is enforced at the database level (RLS), not just the API
- [ ] Service role key is NEVER exposed to the frontend

### 🛡️ Supabase RLS Policies
- [ ] RLS is enabled on ALL tables with user data
- [ ] `SELECT` policies filter by `auth.uid()` or role
- [ ] `INSERT` policies validate `auth.uid() = user_id` where applicable
- [ ] `UPDATE`/`DELETE` policies prevent cross-user data modification
- [ ] Test RLS with an anon key — if you can read data you shouldn't, RLS is wrong

```sql
-- Template: Basic user-scoped RLS
CREATE POLICY "Users can only access their own data"
ON public.table_name
FOR ALL
USING (auth.uid() = user_id);
```

### 🌐 Edge Functions / API
- [ ] Input validation on ALL incoming request body fields
- [ ] No secrets hardcoded — use `Deno.env.get()` for environment variables
- [ ] CORS headers configured explicitly (not `*` in production)
- [ ] Rate limiting considered for public endpoints
- [ ] Error messages don't leak internal implementation details

### 📦 Data Handling
- [ ] No PII logged to console in production
- [ ] Sensitive fields masked in error responses
- [ ] File uploads validated for type and size
- [ ] SQL injection not possible (use parameterized queries / Supabase client)

### 🔑 Secrets Management
- [ ] No API keys in source code
- [ ] No secrets in `.env` files committed to git
- [ ] `.env` in `.gitignore`
- [ ] Supabase `service_role` key only in server-side code

---

## Common Vulnerabilities in Our Stack

### IDOR (Insecure Direct Object Reference)
**Risk**: User accesses another user's resource by changing an ID  
**Fix**: RLS policy using `auth.uid()` on all relevant tables

### Missing RLS
**Risk**: Anon users can read all data  
**Fix**: Enable RLS + create explicit policies for each table

### Service Role Exposure
**Risk**: `service_role` key in frontend code bypasses all RLS  
**Fix**: Never use `service_role` in browser-accessible code

### Unvalidated Webhooks
**Risk**: n8n/Chatwoot webhook accepts any payload  
**Fix**: Validate webhook signature or use a secret token in headers

---

## Output Format

After the audit, report findings as:

```
## Security Audit — [Component/Feature]

### 🔴 Critical Issues
- [description, location, fix]

### 🟡 Warnings
- [description, location, recommendation]

### 🟢 Passed
- [list of checks that passed]

### 📋 Recommendations
- [non-critical improvements]
```

## Limitations
- This audit covers code-level security. Infrastructure-level (firewalls, networking) is out of scope.
- Always have a human review critical security changes before deploying to production.
