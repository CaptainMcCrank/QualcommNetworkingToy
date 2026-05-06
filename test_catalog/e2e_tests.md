# End-to-End Tests

**Applicable to:** both (sometimes called "system tests" in IoT context)
**Default frameworks:** Playwright / Cypress for webapp; shell + ssh / Ansible for IoT
**Output directory:** `tests/e2e/`

---

## Purpose

Exercise complete user journeys (from `user_journeys.md`) against a deployed environment — staging, preview, or a fresh production-equivalent. No mocking; the system is treated as a black box.

E2E tests are the slowest and most brittle category. Keep them focused on the journeys that *must* work; rely on lower categories for breadth.

## Project Conventions

<!-- Examples:
- "Each E2E test maps to exactly one user journey ID."
- "E2E tests run against the preview deployment on every PR; against production on a daily cron."
- "Flaky E2E tests are quarantined within 24 hours and must be fixed before being re-enabled."
-->

---

## Test Cases

### TC-E2E-001: <Journey ID> — <Short title>

- **What it covers:** <reference to UJ-XXX in user_journeys.md>
- **Setup:** <fresh environment, seed user, browser/device config>
- **Action:** <step-by-step user actions; mirror the journey>
- **Expected:** <observable end state>
- **Negative cases:** <typical user mistakes the system should handle gracefully>

### TC-E2E-002: <Journey ID> — <Short title>

(same shape)
