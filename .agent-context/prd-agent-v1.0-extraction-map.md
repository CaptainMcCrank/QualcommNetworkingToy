# Proposal Extraction Map

**Source:** docs/inputs/product_proposal.md
**Source SHA256:** 789600305db2466432b336771ed19a6253cfeb32d334623f1fd4fda6e5e1357c
**Extracted at:** 2026-05-07T02:17:00Z
**Extracted by:** prd-agent-v1.0

---

## Confidence Legend
- **explicit** — the proposal states this directly; cite the section.
- **inferred** — derived from context but not stated outright; needs user confirmation.
- **gap** — the proposal does not address this; Phase 1 must ask.
- **decided** — the proposal contains an explicit, resolved decision (typically in an embedded decisions log or ADR-style section). Treat as settled; cite the entry. Do **not** ask the user to re-confirm in Phase 1 — that wastes interview time on already-closed questions.

---

## Problem Statement
| Field | Value | Confidence | Source (§ / page) |
|-------|-------|------------|-------------------|
| Current situation | Conference networking is sterile and contextless. `"The reason most conference chats die: no context. Pure global chat is sterile."` Conference attendees lack natural mechanisms for authentic, skill-based community formation. | explicit | §Intro, §Primitive 4 |
| Impact | Missed connections between deeply skilled people; operators (hosts) have no natural path to identify and connect with high-signal attendees; conferences feel transactional rather than exploratory. Casual users feel excluded by cliquishness or gate-keeping. | confirmed | §Goals, §Risks & Mitigations. **Confirmed:** 2026-05-11 |
| Opportunity | A Raspberry Pi 5 WiFi access point with a captive portal that creates `"authentic, curious discovery and ad-hoc community formation"` through five composable interaction primitives, a cryptographic identity model, and a half-hour event rhythm. The network itself becomes the operator's portfolio. | explicit | §Intro, §Goals |

## Target Users
| Persona | Description | Technical Level | Confidence | Source |
|---------|-------------|-----------------|------------|--------|
| Conference Attendee (Casual) | Attendees who join the network out of curiosity. Clear tier 1 quickly, use chat, watch games. | Novice–Intermediate | explicit | §Tier 1, §Risks ("Casual users feel locked out") |
| Conference Attendee (Explorer) | Attendees who probe hidden services, discover tier-2 challenges, use skill tags. | Intermediate–Expert | explicit | §Tier 2, §Half-key Matcher |
| Conference Attendee (Reverse Engineer) | Attendees who attempt tier-3 hard-gate challenges. `"30+ minutes of focused work for a competent reverse engineer."` | Expert | explicit | §Tier 3 |
| Operator / Host | The person running the network. Uses Jeopardy hosting and the Lounge to build visibility and connect with top participants. `"Establish operator visibility through hosting and authorship."` | Expert | explicit | §Goals (Operator-facing), §Operator's Lounge |

## Goals & Non-Goals
- **Goals (explicit):**
  - Make joining the network feel like `"the first scene of an interesting story"` (§Goals)
  - Give curious people something to pull on, with `"depth that scales to skill"` (§Goals)
  - Create natural reasons for physical meetups (§Goals)
  - Reward depth without locking out casual users (§Goals)
  - Establish operator visibility through hosting and authorship (§Goals)
  - Funnel highest-signal participants into `"low-pressure introductions"` via Operator's Lounge (§Goals)
  - Generate post-event conversations that lead to interviews `"without ever feeling like a pitch"` (§Goals)

- **Goals (confirmed 2026-05-11):**
  - Demonstrate the operator's technical capability as a portfolio piece
  - Create a reusable, conference-portable deployment (single Pi 5 in a backpack)

- **Non-goals (explicit):**
  - `"not gamified engagement metrics"` (§Intro)
  - `"not corporate networking"` (§Intro)
  - No PII collection — `"No email, phone, real name, or third-party login is ever requested"` (§Identity Model)
  - No permanent data retention (§Open Questions, resolved: zero retention beyond 24h)

- **Non-goals (confirmed by interview):**
  - No internet uplink / outbound traffic routing — fully isolated LAN, no upstream internet. **Confirmed:** 2026-05-11. Note: proposal's "standard outbound rate limit" language refers to LAN traffic shaping, not internet passthrough.
  - No multi-Pi clustering or high-availability. **Confirmed:** 2026-05-11.
  - No persistent cross-event identity (identities are ephemeral per-event). **Confirmed:** 2026-05-11.
  - No native mobile app — all participant UIs are browser-based. Operator admin surface is a PWA (see FR-025).

## Success Metrics
| Metric | Target | Measurement | Confidence | Source |
|--------|--------|-------------|------------|--------|
| Tier-2 adoption | `"A meaningful fraction of attendees reached tier 2"` | Count of tier-2 identities vs. total tier-1 identities | explicit (qualitative) | §Success Criteria |
| Tier-3 adoption | `"A handful reached tier 3 and physically gathered in the lounge corner"` | Count of tier-3 identities + physical lounge presence | explicit (qualitative) | §Success Criteria |
| Matcher success | `"Multiple matchmaker introductions led to sustained conversation"` | Count of completed matches (both QR scans) | explicit (qualitative) | §Success Criteria |
| Operator outcome | `"The operator ended the day with a small set of unprompted 'let's talk after this' conversations from tier-3 attendees"` | Operator self-report | explicit (qualitative) | §Success Criteria |
| Inclusivity | `"Nobody felt the network was exclusionary; everyone with curiosity got somewhere"` | Informal feedback / absence of complaints | explicit (qualitative) | §Success Criteria |
| Tier-1 clearance time | `"< 1 minute"` for curious attendees | Time from first portal view to tier-1 badge | explicit | §Tier 1, §Risks |

**Note:** All success criteria are qualitative. Phase 1 should discuss whether to quantify (e.g., "meaningful fraction" → ">30% of tier-1 users reach tier 2") or leave qualitative given the single-event nature.

## Candidate Functional Requirements
| Tentative ID | Feature | Priority (proposed) | Confidence | Source |
|---|---|---|---|---|
| FR-001 | DNS-hijack captive portal: pre-tier-1 clients see only the portal page | Must | explicit | §Architecture (Network topology) |
| FR-002 | Tier-1 crackme: hidden-token discovery unlocks network access + identity creation | Must | explicit | §Primitive 1 — Tier 1 |
| FR-003 | Ed25519 identity system: browser-side keypair generation via WebCrypto, handle selection, signed-cookie/JWT auth | Must | explicit | §Identity Model |
| FR-004 | Dashboard: shows tier, challenges found, leaderboard, available apps | Must | explicit | §Tier 1 (Reward), §Tier 2 |
| FR-005 | Tier-2 hidden LAN services: 8–12 discoverable services, partial-token collection, tier promotion | Should | explicit | §Primitive 1 — Tier 2 |
| FR-006 | Tier-3 hard-gate challenges: per-user parameterized binaries, 30-min+ RE challenges, signed submission | Should | explicit | §Primitive 1 — Tier 3 |
| FR-007 | Operator's Lounge: tier-3-exclusive channel, veterans wall, one-vouch invite, aristocrat flair, `looking`/`hiring` tags | Should | explicit | §Operator's Lounge |
| FR-008 | Hacker Jeopardy: WebSocket buzz-in, host control panel, spectator sidebar, team mode, half-hour cadence | Should | explicit | §Primitive 2 |
| FR-009 | FlappyGhost integration: identity adapter, sprite gating by tier, post-game chat hook, lobby system | Should | explicit | §Primitive 3 |
| FR-010 | IRC-style chat: auto-spawned per-talk channels, interest channels, anonymous channel, slash commands, typing/presence indicators | Must | explicit | §Primitive 4 |
| FR-011 | Signal flares: short-lived location/topic broadcasts, auto-decay, optional venue-map pin | Should | explicit | §Primitive 5 — Signal Flares |
| FR-012 | Half-key matcher: skill-weighted pair matching, QR-code mutual scan for physical meetup | Should | explicit | §Primitive 5 — Half-key Matcher |
| FR-013 | Scoring system: tier progression (1/2/3) + in-tier points, leaderboard, first-blood bonuses, opt-out flag | Must | explicit | §Scoring |
| FR-014 | Container security model: one container per app, per-container hardening (read-only FS, non-root, cap_drop ALL, mem/cpu limits, isolated networks) | Must | explicit | §Architecture (Container model) |
| FR-015 | Caddy reverse proxy: captive-portal redirect, LAN TLS (self-signed CA), WebSocket proxying | Must | explicit | §Architecture (Stack) |
| FR-016 | Tiered service-visibility gating: tier 1 sees portal/dashboard/chat/FlappyGhost/Jeopardy; tier 2 adds hidden services/phonebook/matcher/#explorers; tier 3 adds lounge/veterans wall/vouch system. No rate limiting or connection caps. | Must | reinterpreted from §Tier 1–3 Rewards; confirmed 2026-05-11 |
| FR-017 | Anonymous channel (`#confessions`): rate limits, slow mode, per-session muting, disable mid-event | Nice | explicit | §Primitive 4 |
| FR-018 | Phonebook service: skill tags, interests, looking-for tags, indexed by pubkey | Should | explicit | §Tier 2 (hidden services list) |
| FR-019 | Spectator mode: low-frame-rate game-state streaming for FlappyGhost and Jeopardy | Nice | explicit | §Primitive 3 (Spectator mode) |
| FR-020 | Downloadable keyfile for cross-device identity portability | Nice | explicit | §Identity Model |
| FR-021 | Jeopardy "ask the host one question" mechanic for round winners | Nice | explicit | §Primitive 2 |
| FR-022 | Post-game chat lobby: 15-min persistent sidebar after FlappyGhost match, "drop a flare" button, rematch | Should | explicit | §Primitive 3 (Lobby) |
| FR-023 | Operator log channel (`#operator-log`): pinned, operator-only posting, exported post-event | Should | explicit | §Primitive 4 |
| FR-024 | DHCP + hostapd AP mode: Pi 5 as wireless access point | Must | explicit | §Architecture (Hardware, Network topology) |
| FR-025 | Admin PWA: self-signed SSL, connected-device count, resource-access monitoring per client | Must | confirmed | Discovery interview 2026-05-11 |

## Constraints (matched to project_type: iot)

### Hardware
- **Platform:** Raspberry Pi 5, 4–8 GB RAM (§Architecture — Hardware) — **explicit**
- **WiFi:** ALFA AWUS036ACH (RTL8812AU chipset), `hostapd` AP mode — **confirmed** 2026-05-11
- **Storage:** 64 GB SD card — **confirmed** 2026-05-11
- **Secondary AP:** Removed from scope — **decided** (ADR-001)
- **Peripherals:** None beyond WiFi adapter — **explicit**
- **Battery pack:** portable deployment in a backpack — **confirmed** 2026-05-11

### Network
- **Topology:** Pi acts as AP; DNS hijack for unresolved queries; tiered access post-authentication (§Architecture — Network topology) — **explicit**
- **Concurrent clients:** Up to 200 (aspirational target). Proposal sized for ~35; user raised to 200 as a design target. **Confirmed:** 2026-05-11. **Risk: the ALFA AWUS036ACH in AP mode may not reliably serve 200 concurrent clients on a single radio. Experimentation phase must validate this ceiling.**
- **Protocols:** HTTP/HTTPS, WebSocket, DNS, DHCP, mDNS, MQTT, Telnet, Finger, Gopher, custom TCP — **explicit** (scattered across §Tier 2, §Architecture)
- **Ops path:** Wired Ethernet for admin access surviving RF issues (§Architecture — Wireless concerns) — **explicit**

### Software / Runtime
- **Container runtime:** Docker, one container per app, isolated networks (§Architecture — Container model) — **explicit**
- **Reverse proxy:** Caddy (§Architecture — Stack) — **explicit**
- **Auth model:** Signed cookie / JWT with shared verification key, no central session store (§Architecture — Stack) — **explicit**
- **Storage:** SQLite per app in named volumes (§Architecture — Stack) — **explicit**
- **OS:** Raspberry Pi OS (Debian-based) — **confirmed** 2026-05-11
- **Pubsub:** NATS or Redis, optional (§Architecture — Stack) — **explicit**, choice deferred to TechStack Agent (confirmed 2026-05-11)

### Environment
- **Location:** Indoor — **confirmed** 2026-05-11
- **Deployment form factor:** Backpack-portable with battery pack — **confirmed** 2026-05-11. This changes the deployment model from a stationary, mains-powered device to a mobile, battery-constrained system.
- **Power:** Battery pack (capacity/model is a **gap**). Continuous mains power is NOT assumed.
- **Temperature:** Indoor ambient — **inferred**, likely correct given indoor-only deployment

### Spanning surface: browser-based clients
The IoT device serves web applications to browser clients. While `project_type` is correctly `iot`, the following web-surface constraints apply:
- All user-facing primitives are browser-based (HTML/JS/CSS over HTTPS + WebSocket)
- Client-side crypto depends on WebCrypto API (modern browsers only)
- Self-signed CA means users must accept a certificate warning or the portal must handle this gracefully
- **Target browser matrix** is a **gap** — the proposal does not specify minimum browser versions

## Assumptions the proposal makes (and we should validate)
1. Pi 5 has sufficient CPU/RAM headroom for ~15 Docker containers + hostapd + Caddy simultaneously **at 200 concurrent clients** — **needs sizing validation in experimentation phase; 200 is a 6x increase over proposal's original 35**
2. The ALFA AWUS036ACH (RTL8812AU) can reliably serve 200 concurrent clients in AP mode — **HIGH RISK; single-radio 802.11ac adapters typically max out around 30-50 stable AP clients. 200 may require multiple adapters, a commercial AP, or accepting a lower ceiling. Experimentation phase must validate.**
3. `hostapd` will work reliably with the ALFA AWUS036ACH on Pi 5 — **the RTL8812AU has had driver issues historically (aircrack-ng/rtl8812au driver vs. in-kernel driver); needs experimentation-phase validation**
4. Flask-SocketIO at 8 connections per FlappyGhost lobby is within budget — **likely true; but at 200 total clients, up to 25 concurrent lobbies, so ~200 WebSocket connections for FlappyGhost alone**
5. Self-signed CA is acceptable for LAN TLS — **most modern browsers show aggressive warnings; captive portal HTTP → HTTPS redirect flow needs careful UX design**
6. ~~35 concurrent users is the design ceiling~~ — **UPDATED: design target is now 200. Confirmed 2026-05-11.**
7. All challenge content (Jeopardy questions, crackme binaries, hidden-service puzzles) is authored by the operator pre-event — **not stated, needs confirmation**
8. The event is single-day or multi-day but ephemeral — **not stated**
9. FlappyGhost (github.com/CaptainMcCrank/FlappyGhost) exists as a working codebase that needs integration, not greenfield — **proposal says "pre-PRD" suggesting early stage**
10. Battery pack can sustain Pi 5 + ALFA adapter + Docker workload for the duration of the event — **NEW assumption from confirmed deployment model; battery capacity and runtime are gaps**

## Gaps Phase 1 must close

### Closed gaps
- ~~Gap 4: USB WiFi adapter~~ → ALFA AWUS036ACH. **Closed by interview:** 2026-05-11.
- ~~Gap 7: Admin/monitoring tooling~~ → Admin PWA with self-signed SSL showing connected devices and resource access. **Closed by interview:** 2026-05-11. Added as FR-025.
- ~~Gap 10: Outbound internet~~ → No outbound internet; fully isolated LAN. **Closed by interview:** 2026-05-11.
- ~~Gap 13: OS image~~ → Raspberry Pi OS. **Closed by interview:** 2026-05-11.

### Open gaps
All gaps closed. Remaining deferred items:
- **Pubsub choice (NATS vs Redis)** — deferred to TechStack Agent. **Closed by interview:** 2026-05-11.
- **Battery pack capacity/model** — not specified by user; no hard budget limit means sizing is an experimentation-phase concern. Minimum runtime target: one full conference day (~12 hours) based on multi-day deployment with overnight charging.

### Additionally closed (interview rounds 2-3, 2026-05-11)
- ~~Gap 1: Budget~~ → No hard limit. **Closed by interview:** 2026-05-11.
- ~~Gap 2: Timeline~~ → Target: other 2026 event (not DEF CON). **Closed by interview:** 2026-05-11.
- ~~Gap 3: SD card~~ → 64 GB. **Closed by interview:** 2026-05-11.
- ~~Gap 4: Quantified metrics~~ → Keep qualitative; this is a single-event social experiment. **Closed by interview:** 2026-05-11.
- ~~Gap 5: Jeopardy content~~ → Operator authors questions, stored as JSON config files, no editor UI needed. **Closed by interview:** 2026-05-11.
- ~~Gap 6: FlappyGhost state~~ → Playable game exists. Integration work is additive (identity adapter, sprite gating, chat hook). **Closed by interview:** 2026-05-11.
- ~~Gap 7: Hidden services count~~ → All 8–12 for v1.0. **Closed by interview:** 2026-05-11.
- ~~Gap 8: Event duration~~ → Multi-day (2–4 days). **Closed by interview:** 2026-05-11.
- ~~Gap 9: Pubsub~~ → Deferred to TechStack Agent. **Closed by interview:** 2026-05-11.
- ~~Gap 11: Tier gating model~~ → Service visibility only. No rate limiting or connection caps. Tier = access control. **Closed by interview:** 2026-05-11.

## Architecture Pre-Loads (for the TechStack Agent)

| Domain | Decision | Scope | Source |
|--------|----------|-------|--------|
| Compute platform | Raspberry Pi 5, 4–8 GB RAM | component | §Architecture — Hardware |
| Wireless | ALFA AWUS036ACH (RTL8812AU), `hostapd` AP mode | component | §Architecture — Hardware, confirmed 2026-05-11 |
| Reverse proxy / ingress | Caddy (captive portal redirect, LAN TLS, WebSocket proxying) | component | §Architecture — Stack |
| Container runtime | Docker, one container per app, per-container hardening | project-wide | §Architecture — Container model |
| Container isolation | Each app on its own private Docker network; no inter-container communication except through reverse proxy | project-wide | §Architecture — Container model |
| Container hardening | `read_only: true`, `user: "10000:10000"`, `cap_drop: ["ALL"]`, `security_opt: ["no-new-privileges:true"]`, mem/cpu limits, no privileged, no host networking, no docker socket mount | project-wide | §Architecture — Container model |
| Auth model | Signed cookie / JWT issued by portal app on tier-1 clear; each app validates independently with shared verification key; no central session store | project-wide | §Architecture — Stack |
| Identity crypto | Ed25519 keypair via browser WebCrypto API | component | §Identity Model |
| Storage | SQLite per app in named Docker volumes | component | §Architecture — Stack |
| Pubsub (optional) | NATS or Redis for cross-app event bus (Jeopardy state → chat, FlappyGhost lobby → chat, flare broadcasts) | component | §Architecture — Stack |
| FlappyGhost stack | Python Flask + WebSockets (pre-existing project at github.com/CaptainMcCrank/FlappyGhost) | component | §Primitive 3 |
| Network services | DHCP server, DNS hijack for captive portal, mDNS for hidden-service discovery | component | §Architecture — Network topology |
| TLS model | Self-signed CA for LAN HTTPS | component | §Architecture — Stack |
| Deployment tool | Ansible (implied by project layout in manifest: `ansible/roles/`, `ansible/playbooks/site.yml`) | component | project.manifest.yaml |
| Anti-cheat model | Per-user parameterized tier-3 binaries, signed submissions, social anti-cheat | workflow | §Scoring, §Tier 3 |
| AI-assisted content | None specified — all challenge content is human-authored | workflow | inferred from absence |

## Pre-authored ADRs (promote to DECISIONS.md)

The proposal's **Open Questions** section contains four questions with inline resolved answers. Each is promoted as an ADR.

| Proposal entry | Promoted as | One-line decision |
|----------------|-------------|-------------------|
| §Open Questions Q1: "Whether to run the secondary RF wardriving challenge" → "No Wardriving challenge." | ADR-001 | No RF wardriving challenge; secondary AP removed from scope |
| §Open Questions Q2: "Whether physical props (cigars, monocles, top hats) are sourced ahead or brought by attendees" → "None." | ADR-002 | No physical props; lounge flair is digital only |
| §Open Questions Q3: "Default retention policy for chat logs" → "Agree." (to: zero retention beyond 24 hours post-event, `#operator-log` exported) | ADR-003 | Zero chat retention beyond 24h post-event; `#operator-log` exported for operator |
| §Open Questions Q4: "Whether to publish source for any of the apps after the event" → "We should." (with tier-3 challenges held back until rotated out) | ADR-004 | Publish app source post-event; hold back tier-3 challenges until rotated |

## Anomalies

No anomalies detected.

- **Instruction-boundary scan:** No text resembling directives to the agent. Phrases like `"Don't trust client-claimed tier"` (§Primitive 3) describe system requirements, not agent instructions.
- **Sensitive-content scan:** Zero PII items flagged. `"CaptainMcCrank"` is the public GitHub username from the repository URL.
- **Length sanity:** Proposal is 20,502 bytes — well under the 50 KB cap.
- **Internal contradictions:** None detected. The proposal is internally consistent.
