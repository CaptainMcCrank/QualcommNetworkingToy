# Security Tests

**Applicable to:** both
**Default frameworks:** semgrep / bandit / npm audit for static; ZAP / Burp / custom scripts for dynamic
**Output directory:** `tests/security/`

---

## Purpose

Validate the security model declared in the PRD. Auth bypass attempts, input validation (XSS, SQLi, prompt injection where relevant), secret exposure, insecure-default detection. Different from threat modeling — these are *executable* checks.

Refer to `Standards/Input_Security_Policy.md` for the agent-side input-vector taxonomy. This file enumerates the project-specific tests that exercise those vectors.

## Project Conventions

<!-- Examples:
- "Every state-changing endpoint must have an unauthenticated-rejection test."
- "Every form input must have an XSS-payload test. Use a curated payload list."
- "Secret-exposure check runs in CI on every commit; failures block merge."
-->

---

## Test Cases

### TC-SEC-001: <Short title>

- **What it covers:** <which surface, which threat>
- **Setup:** <auth context to bypass; payload corpus>
- **Action:** <attack vector exercised>
- **Expected:** <rejection / safe handling — never silent acceptance>
- **Negative cases:** <legitimate inputs that look risky must still pass>

### TC-SEC-002: <Short title>

(same shape)
