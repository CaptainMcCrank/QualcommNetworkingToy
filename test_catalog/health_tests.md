# Health Tests

**Applicable to:** IoT primary; webapp optional (typically subsumed by smoke tests against the deployed `/healthz`)
**Default frameworks:** systemd unit checks + `journalctl` + custom shell for IoT; HTTP healthcheck endpoint for webapp
**Output directory:** `tests/health/`

---

## Purpose

Continuous post-deployment monitoring of a running system. Different from smoke (which runs once after deploy) — health checks run on a cadence and signal *ongoing* state. The Validation Agent (06) and the Deployment Troubleshooting Agent (06B) read these.

## Project Conventions

<!-- Examples:
- "Every long-lived service has a health entry that polls service status, log error rate, and resource ceiling."
- "Health checks emit exit code 0 (healthy), 1 (degraded), or 2 (unhealthy)."
-->

---

## Test Cases

### TC-H-001: <Short title>

- **What it covers:** <which service or resource>
- **Setup:** <none typical; runs against live system>
- **Action:** <the periodic check>
- **Expected (healthy):** <exit 0; metric within budget>
- **Expected (degraded):** <exit 1; what it indicates; whether to alert>
- **Expected (unhealthy):** <exit 2; alert; recommended remediation>
- **Cadence:** <how often this runs; e.g., every 5 minutes>

### TC-H-002: <Short title>

(same shape)
