---
name: api-design-principles
description: "Principles and patterns for designing consistent, well-structured REST APIs and Edge Functions."
risk: safe
source: upstream (sickn33/antigravity-awesome-skills) + local adaptation
imported_on: "2026-04-14"
local_adaptation: true
category: backend
---

# API Design Principles

Apply these principles when designing or reviewing any API endpoint, Edge Function, or data contract.

## Use this skill when

- Creating a new Supabase Edge Function
- Designing a new REST endpoint
- Reviewing an existing API for consistency
- Setting up a webhook receiver (n8n, Chatwoot)

---

## Core Principles

### 1. Resource-Oriented Design
- URLs represent **resources** (nouns), not actions (verbs)
- Use HTTP methods for actions: `GET` (read), `POST` (create), `PUT/PATCH` (update), `DELETE` (remove)

```
✅ GET    /contacts
✅ POST   /contacts
✅ GET    /contacts/:id
✅ PATCH  /contacts/:id
✅ DELETE /contacts/:id

❌ POST /getContacts
❌ POST /createContact
❌ GET  /deleteContact?id=123
```

### 2. Consistent Response Shape
Every response must follow the same shape:

```typescript
// Success
{
  data: T,
  error: null,
  meta?: { page: number, total: number }
}

// Error
{
  data: null,
  error: {
    code: string,     // machine-readable, e.g. "CONTACT_NOT_FOUND"
    message: string,  // human-readable
    details?: unknown
  }
}
```

### 3. HTTP Status Codes — Use Correctly
| Code | When to use |
|------|-------------|
| 200 | Success (GET, PATCH) |
| 201 | Created (POST) |
| 204 | No content (DELETE) |
| 400 | Bad request / validation error |
| 401 | Not authenticated |
| 403 | Not authorized (authenticated but no permission) |
| 404 | Resource not found |
| 409 | Conflict (duplicate) |
| 422 | Unprocessable entity |
| 500 | Server error (never expose details in production) |

### 4. Input Validation
Validate ALL inputs before processing:

```typescript
// Edge Function — validate body
const body = await req.json().catch(() => null);
if (!body?.contact_id) {
  return new Response(JSON.stringify({
    data: null,
    error: { code: "MISSING_FIELD", message: "contact_id is required" }
  }), { status: 400 });
}
```

### 5. Idempotency
- `GET`, `PUT`, `DELETE` must be idempotent
- `POST` creates a new resource (not idempotent by default)
- For critical operations (payments, webhooks), add idempotency keys

### 6. Versioning (when needed)
- Use URL versioning for breaking changes: `/v2/contacts`
- Never break existing clients without a versioned path

---

## Edge Functions Checklist

- [ ] Returns consistent `{ data, error }` shape
- [ ] Validates Authorization header (JWT)
- [ ] Validates request body fields
- [ ] Uses `Deno.env.get()` for all secrets
- [ ] Returns appropriate HTTP status codes
- [ ] Has CORS headers for browser requests
- [ ] Error messages don't expose internals
- [ ] Logs are structured and don't contain PII

## Webhook Design (n8n / Chatwoot)

```typescript
// Validate webhook before processing
const signature = req.headers.get("x-webhook-signature");
if (!validateSignature(signature, body, secret)) {
  return new Response("Unauthorized", { status: 401 });
}

// Always return 200 quickly, process async
return new Response("OK", { status: 200 });
```

---

## Anti-Patterns to Avoid

| Anti-Pattern | Fix |
|-------------|-----|
| Returning 200 with error in body | Use correct HTTP status codes |
| Exposing stack traces in production | Catch and return generic error |
| Nested deeply-coupled responses | Flat, consistent response shape |
| Missing validation | Validate all inputs, return 400 |
| Secrets in URL params | Use headers or body |

## Limitations
- These principles cover REST APIs. For GraphQL or RPC-style APIs, adapt accordingly.
- Always review with `security-auditor` before deploying public endpoints.
