# Architecture Decision Records

This document tracks significant decisions made during the project lifecycle.
Each decision is recorded as an ADR (Architecture Decision Record).

---

## Template

```markdown
### ADR-XXX: [Decision Title]

**Date:** [ISO 8601]
**Status:** proposed | accepted | deprecated | superseded
**Deciders:** [agent-ids and/or humans involved]

#### Context

[What is the issue that we're seeing that is motivating this decision?]

#### Decision

[What is the change that we're proposing and/or doing?]

#### Consequences

**Positive:**
- [Benefit 1]
- [Benefit 2]

**Negative:**
- [Tradeoff 1]
- [Tradeoff 2]

#### Alternatives Considered

- [Alternative 1]: [Why rejected]
- [Alternative 2]: [Why rejected]
```

---

## Decisions

<!-- Add ADRs below this line -->

### ADR-000: Project Initialization

**Date:** 2026-05-06T22:56:17Z
**Status:** accepted
**Deciders:** initialization-agent-v1.0

#### Context

A new project needs to be created with proper structure for multi-agent development.

#### Decision

Initialize project with:
- `project.manifest.yaml` for state tracking
- `.agent-ownership.yaml` for artifact ownership
- `DECISIONS.md` for decision logging
- Standard directory structure (base + IoT with ansible/)
- Project type: IoT

#### Consequences

**Positive:**
- Consistent project structure across all agents
- Clear ownership and accountability
- Decision history preserved
- Ansible directories ready for IoT build automation

**Negative:**
- Initial setup overhead
- Requires agent compliance with protocol

---

### ADR-000b: Proposal Adopted as PRD Source

**Date:** 2026-05-07T02:17:00Z
**Status:** accepted
**Deciders:** prd-agent-v1.0, user

#### Context

A product proposal was registered at init time as the primary input for PRD development.

#### Decision

Adopt `docs/inputs/product_proposal.md` (sha256 `789600305db2466432b336771ed19a6253cfeb32d334623f1fd4fda6e5e1357c`) as the source of record for problem statement, target users, and candidate features. Phase 1 will close the gaps listed in the extraction map; Phase 3 will trace each functional requirement back to a proposal section or to a Phase 1 interview answer.

#### Consequences

**Positive:**
- PRD requirements are traceable to a versioned input.

**Negative:**
- If the proposal changes after this ADR, the PRD must be re-reconciled (proposal hash drift is a hard gate at the start of every subsequent phase).

---

### ADR-001: No RF Wardriving Challenge

**Date:** 2026-05-07T02:17:00Z
**Status:** accepted
**Deciders:** proposal author (CaptainMcCrank), ratified by prd-agent-v1.0

#### Context

Promoted from `docs/inputs/product_proposal.md` §Open Questions Q1. The proposal author resolved this decision before the pipeline ran; recording here so downstream phases treat it as settled.

#### Decision

No secondary RF wardriving challenge. The optional low-power second AP described in §Architecture (Hardware) and §Tier 3 is removed from scope.

#### Consequences

- Eliminates venue-size and channel-space dependencies for the tier-3 experience.
- Simplifies hardware BOM to a single Pi 5 + one USB WiFi adapter.
- Tier-3 challenges are software-only (WASM crackme, exploit chain, timing attack, custom cipher, parameterized binaries).

---

### ADR-002: No Physical Props

**Date:** 2026-05-07T02:17:00Z
**Status:** accepted
**Deciders:** proposal author (CaptainMcCrank), ratified by prd-agent-v1.0

#### Context

Promoted from `docs/inputs/product_proposal.md` §Open Questions Q2. The proposal author resolved this decision before the pipeline ran; recording here so downstream phases treat it as settled.

#### Decision

No physical props (plastic monocles, foam cigars, novelty top hats) will be sourced or provided. Lounge flair is digital only (SVG overlays, CSS themes, sprite variants).

#### Consequences

- Eliminates procurement logistics and venue-coordination for physical items.
- The "physical lounge corner" described in §Operator's Lounge is reduced to a reserved seating area without costume elements.
- Digital flair (cigar + monocle + top hat SVG, tweed CSS theme, aristocrat sprites) remains in scope.

---

### ADR-003: Zero Chat Retention Beyond 24 Hours

**Date:** 2026-05-07T02:17:00Z
**Status:** accepted
**Deciders:** proposal author (CaptainMcCrank), ratified by prd-agent-v1.0

#### Context

Promoted from `docs/inputs/product_proposal.md` §Open Questions Q3. The proposal author resolved this decision before the pipeline ran; recording here so downstream phases treat it as settled.

#### Decision

All chat logs are deleted within 24 hours post-event. The `#operator-log` channel is exported for the operator's own records before deletion.

#### Consequences

- Aligns with the zero-PII identity model: no long-lived behavioral data.
- Operator retains their own commentary channel for portfolio use.
- Post-event analysis of chat activity is not possible unless the operator exports aggregate statistics (not message content) before the retention window closes.

---

### ADR-004: Publish App Source Post-Event

**Date:** 2026-05-07T02:17:00Z
**Status:** accepted
**Deciders:** proposal author (CaptainMcCrank), ratified by prd-agent-v1.0

#### Context

Promoted from `docs/inputs/product_proposal.md` §Open Questions Q4. The proposal author resolved this decision before the pipeline ran; recording here so downstream phases treat it as settled.

#### Decision

Publish source code for the apps after the event. Tier-3 challenge source (WASM crackmes, parameterized binaries, exploit-chain services) is held back until those challenges are rotated out of the active pool.

#### Consequences

- The project becomes a public portfolio piece and reference implementation.
- Community contributions and forks are possible after release.
- Tier-3 challenge integrity is preserved for future deployments by delaying their source publication.

---

### ADR-005: Product Scope Definition

**Date:** 2026-05-11
**Status:** accepted
**Deciders:** prd-agent-v1.0, CaptainMcCrank

#### Context

We need to define the scope of Conference WiFi Captive Portal v1.0 to guide implementation. The product proposal describes a comprehensive system with five interaction primitives, three tiers, and numerous sub-features. Discovery interviews clarified constraints (backpack deployment, battery power, up to 200 clients, no outbound internet, ALFA AWUS036ACH adapter) and closed 14 gaps.

#### Decision

Include in v1.0 (25 functional requirements total):

**Must Have (11):**
- FR-024: hostapd AP mode (ALFA AWUS036ACH)
- FR-001: DNS-hijack captive portal
- FR-015: Caddy reverse proxy
- FR-014: Container security model
- FR-003: Ed25519 identity system
- FR-002: Tier-1 crackme
- FR-004: Dashboard
- FR-016: Tiered service-visibility gating (no rate limiting)
- FR-013: Scoring system
- FR-010: IRC-style chat
- FR-025: Admin PWA

**Should Have (10):**
- FR-005: Tier-2 hidden LAN services (all 8–12)
- FR-018: Phonebook service
- FR-008: Hacker Jeopardy
- FR-009: FlappyGhost integration
- FR-022: Post-game chat lobby
- FR-011: Signal flares
- FR-012: Half-key matcher
- FR-023: Operator log channel
- FR-006: Tier-3 challenges
- FR-007: Operator's Lounge

**Nice to Have (4):**
- FR-017: Anonymous channel
- FR-019: Spectator mode
- FR-020: Downloadable keyfile
- FR-021: Jeopardy "ask the host"

Explicitly excluded from v1.0:
- Outbound internet routing — system is a fully isolated LAN
- Multi-Pi clustering — single device, accepted SPOF
- RF wardriving challenge — removed per ADR-001
- Physical props — removed per ADR-002
- Native mobile apps — browser-only for participants
- Persistent cross-event identity — ephemeral per event
- Venue map integration for flares — deferred

#### Consequences

**Positive:**
- Clear scope enables focused development across 6 implementation phases
- Must-have features form a viable deployment even without should-have features
- Phased implementation order means each phase produces a deployable system

**Negative:**
- Nice-to-have features may not land for first event if timeline is tight
- 200-client target carries high wireless risk that may force scope reduction
