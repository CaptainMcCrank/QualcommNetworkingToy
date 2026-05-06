# Cross-Device Tests

**Applicable to:** webapp primary; IoT with multiple target hardware models
**Default frameworks:** Playwright with device emulation / BrowserStack / Sauce Labs for webapp; physical or PXE-managed device matrix for IoT
**Output directory:** `tests/cross-device/`

---

## Purpose

Confirm the system behaves correctly across the target browser × viewport matrix (webapp) or hardware-model matrix (multi-target IoT). Catches regressions that show up only on one device class — Safari iPad, an older Pi model, a low-DPI display.

The matrix is sourced from `domain_knowledge/browser_compat_matrix.yml` (webapp) or `domain_knowledge/compatibility_matrix.yml` (IoT), authored by the Build Agent.

## Project Conventions

<!-- Examples:
- "Every UJ in user_journeys.md is exercised on at least the primary mobile target and the primary desktop target."
- "Touch-specific behavior is tested only on touch-capable devices in the matrix."
- "On IoT: the same playbook is exercised on every supported Pi model."
-->

---

## Test Cases

### TC-CD-001: <Short title>

- **What it covers:** <which UJ or behavior, which device row in the matrix>
- **Setup:** <device profile / model>
- **Action:** <user actions; mirror the journey>
- **Expected:** <observable outcome on this device>
- **Negative cases:** <degradations that are *acceptable* on this device versus those that are not>

### TC-CD-002: <Short title>

(same shape)
