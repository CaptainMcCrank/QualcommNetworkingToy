# User Journeys

**Applicable to:** both
**Source:** PRD (01) + Experiment validation (03 / 03_WebDev) + Design Review (03B, WebDev only)
**Owner:** project team

---

## Purpose

Every critical path a user takes through this system. Each journey is a sequence of user actions and system responses that must work end-to-end. This file is the canonical source for E2E tests and the dependency input for integration tests.

## Project Conventions

<!-- Edit this block. Examples:
- "Every journey must be exercised on the production environment before a release tag is cut."
- "Journeys with payment steps must be testable in a sandbox mode."
-->

---

## Journeys

### UJ-001: <Short title>

- **Trigger:** <what initiates the journey — landing page visit, scheduled event, hardware input>
- **Preconditions:** <auth state, data state, device state>
- **Steps:**
  1. User <action>
  2. System <response>
  3. User <action>
  4. System <response>
- **Success:** <end state — what the user sees / what changed in the system>
- **Failure modes:** <what can go wrong, and what the user should see when it does>
- **Linked FRs:** <functional requirement IDs from PRD>
- **Test categories that consume this:** e2e, integration

### UJ-002: <Short title>

(same shape)
