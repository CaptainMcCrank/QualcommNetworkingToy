# API Tests

**Applicable to:** any project exposing an HTTP / RPC surface (webapp, service, IoT with HTTP)
**Default frameworks:** confirmed in `docs/techstack_decision.md` (e.g., pytest + httpx for Python; supertest / vitest for Node)
**Output directory:** `tests/api/`

---

## Purpose

Endpoint contract tests. Validate request schema, response schema, status codes, auth, and error paths. The service is started — possibly with a test database or in-memory backing store — but external dependencies are stubbed.

API tests are the contract between the frontend and backend (or between this service and its callers). Any change to a tested endpoint contract must update an entry here.

## Project Conventions

<!-- Examples:
- "Every endpoint has at least one happy-path test and one auth-rejection test."
- "Error bodies must conform to RFC 9457 problem details — assert on type/title/status/detail."
- "Pagination, ordering, and filtering each get explicit tests; do not assume defaults."
-->

---

## Test Cases

### TC-API-001: <METHOD /path>

- **What it covers:** <which endpoint, which behavior>
- **Setup:** <auth state, fixture data>
- **Action:** <request body / query params>
- **Expected:** <status code, response shape, side effect>
- **Negative cases:** <unauthorized, malformed body, conflicting state, idempotency edge>

### TC-API-002: <METHOD /path>

(same shape)
