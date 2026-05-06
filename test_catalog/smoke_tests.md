# Smoke Tests

**Applicable to:** both
**Default frameworks:** shell / curl / lightweight HTTP client; for IoT, also `ansible -m ping` and `systemctl is-active`
**Output directory:** `tests/smoke/`

---

## Purpose

The fastest possible "is this thing alive?" check after a deploy. Should run in under a minute total. If smoke fails, do not run integration / e2e — investigate first.

The Validation Agent (06) runs these immediately after deployment. The Deployment Troubleshooting Agent (06B) runs them as the first step of any post-incident triage.

## Project Conventions

<!-- Examples:
- "Smoke tests must not require any test data setup — they exercise what's already deployed."
- "Smoke tests must exit non-zero on any failure; agents read exit codes, not log output."
-->

---

## Test Cases

### TC-S-001: <Short title>

- **What it covers:** <which service or surface>
- **Setup:** <none for true smoke; possibly a known URL / hostname>
- **Action:** <the cheap check — HTTP 200, port open, service active>
- **Expected:** <pass condition>
- **Negative cases:** <none typical; smoke tests are pass/fail>

### TC-S-002: <Short title>

(same shape)
