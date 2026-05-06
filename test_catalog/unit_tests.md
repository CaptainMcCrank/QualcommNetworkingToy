# Unit Tests

**Applicable to:** both
**Default frameworks:** confirmed in `docs/techstack_decision.md`
**Output directory:** `tests/unit/`

---

## Purpose

Per-function, per-module correctness tests. Hermetic — no network, no filesystem outside fixtures, no real services. Fast (milliseconds, not seconds).

This is where domain logic gets rigorously exercised. Every row in `domain_correctness_matrix.md` should be reachable from a unit test entry below.

## Project Conventions

<!-- Examples:
- "Every public function in the domain layer must have at least one unit test."
- "No real `datetime.now()` — inject a clock."
- "Use Hypothesis for property tests on pure functions."
-->

---

## Test Cases

### TC-U-001: <Short title>

- **What it covers:** <function or module under test; reference DC- or DR- IDs if applicable>
- **Setup:** <fixtures, mocks>
- **Action:** <inputs supplied>
- **Expected:** <output asserted>
- **Negative cases:** <invalid inputs and the errors they should raise>

### TC-U-002: <Short title>

(same shape)
