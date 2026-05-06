# Domain-Specific Risks

**Applicable to:** both
**Source:** Experiment Agent observations + human domain expertise
**Owner:** project team

---

## Purpose

The failure modes that are silent or hard to spot — the bugs that don't crash anything but corrupt the user's outcome. These drive coverage decisions: every domain risk must map to at least one test entry in the appropriate category file (usually `unit_tests.md`, `integration_tests.md`, or `e2e_tests.md`).

## Project Conventions

<!-- Examples:
- "Any risk marked Severity: High must have a regression test before the build is tagged."
- "Risks discovered post-deployment should be added here AND linked from the GitHub issue."
-->

---

## Risks

### DR-001: <Short title>

- **What silently breaks:** <description; specifically the *silent* failure — not a crash>
- **How it manifests to the user:** <what they see; how they'd notice>
- **Likely causes:** <root-cause hypotheses>
- **Detection strategy:** <which test category catches this; reference TC IDs>
- **Severity:** Low | Medium | High
- **Notes:** <links to related lessons learned, prior incidents>

### DR-002: <Short title>

(same shape)
