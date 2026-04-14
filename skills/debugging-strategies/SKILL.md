---
name: debugging-strategies
description: "Transform debugging from frustrating guesswork into systematic problem-solving with proven strategies, powerful tools, and methodical approaches."
risk: safe
source: upstream (sickn33/antigravity-awesome-skills)
imported_on: "2026-04-14"
local_adaptation: false
category: debugging
---

# Debugging Strategies

Transform debugging from frustrating guesswork into systematic problem-solving with proven strategies, powerful tools, and methodical approaches.

## Use this skill when

- Tracking down elusive bugs
- Investigating performance issues
- Debugging production incidents
- Analyzing crash dumps or stack traces
- Debugging distributed systems or n8n workflows

## Do not use this skill when

- There is no reproducible issue or observable symptom
- The task is purely feature development
- You cannot access logs, traces, or runtime signals

## Instructions

### Step 1 — Reproduce and Capture
- Reproduce the issue consistently
- Capture: logs, traces, environment details, error messages, stack traces
- If using Supabase: check Edge Function logs via `get_logs` (service: edge-function)
- If using n8n: check execution history and node outputs

### Step 2 — Form Hypotheses
- List all plausible causes (minimum 3)
- Rank by likelihood and ease of verification
- Start with the simplest hypothesis

### Step 3 — Binary Search
- Narrow scope with binary search isolation
- Disable/enable components to isolate the source
- Use minimal reproducible examples
- Add targeted instrumentation (console.log, Supabase logs)

### Step 4 — Verify and Fix
- Test your fix against the reproduction case
- Confirm the fix does not break anything else
- Document the root cause and the fix

### Step 5 — Prevent Recurrence
- Add a test that would have caught this bug (see `test-driven-development`)
- Consider if a pattern change can prevent the entire class of bugs

## Common patterns in our stack

### Supabase / PostgreSQL
- Check RLS policies first — most "data not found" bugs are RLS
- Verify column types and null constraints
- Check that migrations ran: `list_migrations` via Supabase MCP

### React / TypeScript
- Check for undefined before accessing nested properties
- Verify hook dependencies arrays
- Check for stale closures in event handlers

### Edge Functions / n8n
- Verify environment variables are set
- Check CORS headers for browser requests
- Verify webhook URLs are correct and reachable

## Limitations
- Use this skill only when there is a reproducible issue to debug.
- Do not treat the output as a substitute for environment-specific validation.
- Stop and ask for clarification if required inputs are missing.
