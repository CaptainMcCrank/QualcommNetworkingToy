# Integration Tests

**Applicable to:** both
**Default frameworks:** confirmed in `docs/techstack_decision.md`; typically the same runner as unit tests but with `docker compose` or live services
**Output directory:** `tests/integration/`

---

## Purpose

Tests that exercise multiple components together with real (or close-to-real) backing services — a real database, a real message queue, a real HTTP request between frontend and backend. Slower than unit tests; should still be deterministic.

These catch the bugs unit tests can't see: schema migrations that break the ORM, mismatched serialization between services, race conditions in shared state.

## Project Conventions

<!-- Examples:
- "Integration tests run against a fresh `docker compose` environment per test class — no shared state across files."
- "No mocking the database. If the test feels slow, fix the test data setup, not the realism."
-->

---

## Test Cases

### TC-I-001: <Short title>

- **What it covers:** <which two-or-more components, which interaction>
- **Setup:** <containers, fixtures, seed data>
- **Action:** <the cross-component flow being exercised>
- **Expected:** <observable outcome, often state in a backing store>
- **Negative cases:** <connection failure between components, schema drift>

### TC-I-002: <Short title>

(same shape)
