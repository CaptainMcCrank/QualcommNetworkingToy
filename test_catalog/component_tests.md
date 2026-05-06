# Component Tests

**Applicable to:** webapp (skip for `service` and `iot`)
**Default frameworks:** confirmed in `docs/techstack_decision.md` (e.g., Vitest + Testing Library, Jest + Testing Library, Playwright Component Testing)
**Output directory:** `tests/component/`

---

## Purpose

Render-and-interact tests for individual frontend components in isolation. Validate props → DOM behavior, event handlers, accessibility roles. No backend; mock data sources at the component boundary.

Component tests sit between unit tests (pure functions) and integration tests (multiple components together). They protect against UI regressions that pure-function tests cannot see.

## Project Conventions

<!-- Examples:
- "Every component with stateful behavior gets a component test."
- "Snapshot tests are forbidden — assert on roles and accessible names instead."
- "Touch event behavior is tested at the component level, not E2E."
-->

---

## Test Cases

### TC-C-001: <Component name>

- **What it covers:** <which component, which behaviors>
- **Setup:** <props, context providers, mocks>
- **Action:** <render + simulated user interaction>
- **Expected:** <DOM assertion, event-handler call, accessibility property>
- **Negative cases:** <bad props, missing context, error boundaries>

### TC-C-002: <Component name>

(same shape)
