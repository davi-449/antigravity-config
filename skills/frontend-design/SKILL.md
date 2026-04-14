---
name: frontend-design
description: "UI/UX quality principles for React applications. Covers interaction design, accessibility, visual hierarchy, and component composition."
risk: safe
source: upstream (sickn33/antigravity-awesome-skills) + local adaptation
imported_on: "2026-04-14"
local_adaptation: true
category: frontend
---

# Frontend Design

Apply these principles when creating or reviewing UI components to ensure high-quality, accessible, and consistent interfaces.

## Use this skill when

- Creating new UI components or pages
- Reviewing existing UI for quality
- Designing interaction patterns
- Handling loading, error, and empty states

---

## Core UI Principles

### 1. Visual Hierarchy
Every screen must have a clear visual hierarchy:
- **One primary action** per screen (most prominent)
- Secondary actions clearly subordinate
- Destructive actions (delete, remove) visually distinct (red, outlined)

```tsx
// ✅ Clear hierarchy
<Button variant="default">Create Lead</Button>  {/* primary */}
<Button variant="outline">Export</Button>        {/* secondary */}
<Button variant="destructive">Delete</Button>    {/* destructive */}
```

### 2. State Completeness
**Every data-fetching component must handle all 4 states:**

```tsx
// ✅ Complete state handling
if (isLoading) return <Skeleton className="h-32 w-full" />;
if (error) return <ErrorState message={error.message} onRetry={refetch} />;
if (!data?.length) return <EmptyState message="Nenhum lead encontrado" />;
return <DataTable data={data} />;
```

**Never leave undefined/loading as a silent blank screen.**

### 3. Feedback on Every Action
| Action | Feedback required |
|--------|------------------|
| Form submit | Loading indicator + success/error toast |
| Delete | Confirmation dialog + success/error toast |
| Save | Optimistic update OR loading state |
| Navigate | Page transition (no flash of empty) |

### 4. Responsive Design
- Mobile-first: design for smallest screen first
- Use CSS grid/flexbox for layouts (not absolute positioning)
- Test at 375px (mobile), 768px (tablet), 1280px (desktop)
- Touch targets minimum 44x44px

### 5. Accessibility (A11Y)
- [ ] All interactive elements reachable by keyboard (Tab)
- [ ] Focus visible on all interactive elements
- [ ] Images have `alt` text
- [ ] Form inputs have associated `<label>`
- [ ] Color is not the only indicator of state
- [ ] ARIA roles where semantic HTML is insufficient

---

## Component Composition Patterns

### Container vs Presentational
```tsx
// Container (has logic/data)
function LeadsContainer() {
  const { data, isLoading } = useLeads();
  return <LeadsTable leads={data} isLoading={isLoading} />;
}

// Presentational (pure UI, no fetching)
function LeadsTable({ leads, isLoading }: Props) {
  // Only renders, no side effects
}
```

### shadcn/ui First
Always prefer `shadcn/ui` components over custom implementations:
```tsx
// ✅ Use shadcn
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent } from "@/components/ui/dialog";

// ❌ Don't create custom dialog from scratch
```

---

## Anti-Patterns

| Anti-Pattern | Impact | Fix |
|-------------|--------|-----|
| Missing loading state | Flash of empty content | Add Skeleton |
| Missing error state | Silent failure | Add ErrorState with retry |
| Hardcoded colors | Hard to theme | Use CSS variables/Tailwind tokens |
| `z-index: 9999` | Z-index wars | Use design system z-index scale |
| Click area too small | Unusable on mobile | Min 44x44px targets |
| Form without validation | Bad UX on error | Add inline validation |

---

## Performance

- Lazy load pages with `React.lazy()` + `Suspense`
- Memoize expensive list renders with `React.memo`
- Avoid unnecessary re-renders: check hook dependencies
- Images: use `loading="lazy"` for below-fold

## Limitations
- This skill covers React web UI patterns. For native mobile, adapt accordingly.
- Large UI generation (>200 lines JSX) should use Stitch MCP via `stitch-visual` bundle.
