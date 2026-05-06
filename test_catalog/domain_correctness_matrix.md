# Domain Correctness Matrix

**Applicable to:** both, optional
**Source:** PRD's domain rules + Experiment validation
**Owner:** project team

---

## Purpose

A table of domain-specific correctness rules that the system must honor exactly. Examples: a music-theory engine that must yield the right chord for every (key, scale degree, inversion); a tax engine that must apply the right rate for every (jurisdiction, taxable_event, year); a sensor pipeline that must emit the right unit conversion for every (sensor_type, raw_reading).

Skip this file if the project has no such structured domain. If you keep it, every row drives a unit-test obligation.

## Project Conventions

<!-- Examples:
- "Every row must be covered by a unit test before merge to main."
- "Any disagreement between this matrix and the implementation is resolved in favor of this matrix; open an ADR if the matrix should change."
-->

---

## Matrix

| Rule ID | Input dimension(s) | Expected output | Source / authority |
|---------|-------------------|-----------------|---------------------|
| DC-001  | <e.g., key, degree> | <e.g., correct quality> | <e.g., music theory textbook reference> |
| DC-002  | <...>             | <...>           | <...>               |

(Add as many rows as the domain demands. Coverage of this table is what the unit-test category protects.)
