# Chaos Tests

**Applicable to:** both
**Default frameworks:** custom scripts; toxiproxy for network chaos; for IoT, manual / scripted hardware events (pull power, kill service, partition network)
**Output directory:** `tests/chaos/`

---

## Purpose

Failure injection. Confirm the system degrades gracefully when something it depends on breaks: a backend goes down mid-request, the database connection is dropped, a Pi loses power, a CDN serves stale content.

Chaos tests are *not* pass/fail at the level of "did it return 200." They're pass/fail at the level of "did the user see something sensible, did data corrupt, did the system recover when the failure ended?"

## Project Conventions

<!-- Examples:
- "Chaos tests run nightly against staging, never against production."
- "Each chaos scenario must declare both an immediate-behavior expectation and a recovery expectation."
-->

---

## Test Cases

### TC-CH-001: <Short title>

- **What it covers:** <which dependency, which failure>
- **Setup:** <baseline healthy state>
- **Action:** <failure injected — service kill, network partition, disk full>
- **Expected (during failure):** <user-visible behavior; degraded mode>
- **Expected (after recovery):** <return to healthy state without manual intervention>
- **Negative cases:** <the failure must not corrupt persisted state>

### TC-CH-002: <Short title>

(same shape)
