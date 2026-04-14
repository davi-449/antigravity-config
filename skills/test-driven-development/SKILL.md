---
name: test-driven-development
description: "Use when implementing any feature or bugfix, before writing implementation code. Red-Green-Refactor cycle."
risk: safe
source: upstream (sickn33/antigravity-awesome-skills)
imported_on: "2026-04-14"
local_adaptation: false
category: testing
---

## Overview
Write the test first. Watch it fail. Write minimal code to pass.

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

**Violating the letter of the rules is violating the spirit of the rules.**

## When to Use
**Always:**
- New features
- Bug fixes
- Refactoring
- Behavior changes

**Exceptions (ask your human partner):**
- Throwaway prototypes
- Generated code (Stitch output)
- Configuration files

## The Iron Law
```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over.

## Red-Green-Refactor

### RED — Write Failing Test
Write one minimal test showing what should happen.

**Requirements:**
- One behavior per test
- Clear, descriptive name
- Real code (no mocks unless unavoidable)

### Verify RED — Watch It Fail
**MANDATORY. Never skip.**

```bash
npm test path/to/test.test.ts
```

Confirm:
- Test fails (not errors)
- Failure message is expected
- Fails because feature missing (not typos)

### GREEN — Minimal Code
Write simplest code to pass the test. YAGNI — don't add features.

### Verify GREEN — Watch It Pass
**MANDATORY.**

```bash
npm test path/to/test.test.ts
```

### REFACTOR — Clean Up
After green only:
- Remove duplication
- Improve names
- Extract helpers

Keep tests green. Don't add behavior.

## Verification Checklist
Before marking work complete:

- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing
- [ ] Each test failed for expected reason
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass
- [ ] Output pristine (no errors, warnings)
- [ ] Edge cases and errors covered

## Red Flags — STOP and Start Over
- Code before test
- Test passes immediately (without any implementation)
- Can't explain why test failed
- "I'll write tests after"
- "This is too simple to test"

## Limitations
- Use this skill only when there is a test-able behavior to implement.
- Do not use for configuration files or generated code.
- Ask for clarification if the test strategy is unclear.
