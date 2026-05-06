# Performance Tests

**Applicable to:** both
**Default frameworks:** k6 / Locust / wrk for load; Lighthouse / WebPageTest for frontend; custom timing harnesses for IoT
**Output directory:** `tests/performance/`

---

## Purpose

Confirm the system meets its non-functional performance budgets from the PRD. Load (concurrent users), latency (p50/p95/p99), throughput (requests/sec), and resource ceilings (memory, CPU, battery on IoT).

Performance tests are not pass/fail in the same sense as functional tests — they assert against a budget. A regression here is a release blocker.

## Project Conventions

<!-- Examples:
- "p95 latency budget for /api/* is 200ms under 50 concurrent users."
- "Frontend bundle initial JS budget: 200 KB gzipped on production build."
- "On IoT: idle CPU < 5%, memory < 200 MB."
-->

---

## Test Cases

### TC-P-001: <Short title>

- **What it covers:** <which endpoint / page / device behavior>
- **Setup:** <load profile, duration, concurrency>
- **Action:** <traffic pattern>
- **Expected:** <budget — specific numeric thresholds>
- **Negative cases:** <none typical; performance tests measure, they don't accept invalid inputs>

### TC-P-002: <Short title>

(same shape)
