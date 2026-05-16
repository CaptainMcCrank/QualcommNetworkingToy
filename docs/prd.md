# Product Requirements Document: Conference WiFi Captive Portal

**Version:** 1.0
**Date:** 2026-05-11
**Author:** prd-agent-v1.0
**Status:** Draft

---

## Executive Summary

This project builds a Raspberry Pi 5-based WiFi access point with a captive portal designed to serve as a social fabric for reverse-engineering-leaning conference audiences. The system deploys from a backpack with battery power and creates an isolated LAN hosting five composable interaction primitives — a tiered crackme portal, Hacker Jeopardy, FlappyGhost multiplayer, IRC-style chat, and a half-key skill matcher — all bound together by a zero-PII cryptographic identity model.

The design optimizes for authentic, curious discovery and ad-hoc community formation rather than gamified engagement metrics or corporate networking. A three-tier progression (web puzzle → hidden service discovery → hard RE challenges) self-selects participants by depth of interest, funneling the highest-signal attendees into the Operator's Lounge where the host can make natural professional connections.

The system targets up to 200 concurrent clients (subject to wireless radio validation), runs on battery for a full conference day, and is designed to be reusable across multiple events with ephemeral per-event identities and zero data retention beyond 24 hours post-event.

---

## Problem Statement

### Current Situation

Conference networking is sterile and contextless. Pure global chat channels die because there is no shared context to seed conversation. Technical conference attendees — particularly those in security and reverse engineering — lack natural mechanisms for authentic, skill-based community formation that rewards depth without gatekeeping.

### Impact

Missed connections between deeply skilled people who would benefit from knowing each other. Conference operators and hosts have no natural path to identify and connect with high-signal attendees without resorting to awkward approaches that feel like corporate networking or pitches. Casual attendees feel excluded by existing cliques, while skilled attendees have no way to surface their capabilities to peers.

### Opportunity

A portable WiFi access point that makes joining the network feel like the first scene of an interesting story. By combining cryptographic identity, tiered challenges, synchronous games, and physical-meetup mechanics on a single isolated LAN, the network itself becomes both a social catalyst and a portfolio piece demonstrating the operator's technical capability.

---

## Target Users

### Primary User: Conference Attendee (Casual)
- **Description:** Attendees who join the network out of curiosity. They clear tier 1 quickly, use chat, watch games, and enjoy the atmosphere.
- **Technical Level:** Novice to Intermediate
- **Goals:** Connect to the network, participate in chat and games, find interesting people
- **Pain Points:** Feeling excluded from technical cliques; no natural conversation starters at conferences

### Primary User: Conference Attendee (Explorer)
- **Description:** Attendees who probe hidden services, discover tier-2 challenges, and use skill tags to find peers with complementary interests.
- **Technical Level:** Intermediate to Expert
- **Goals:** Discover hidden services, collect tokens, find skill-matched peers
- **Pain Points:** No structured way to demonstrate skills or find peers at similar depth

### Primary User: Conference Attendee (Reverse Engineer)
- **Description:** Attendees who attempt tier-3 hard-gate challenges requiring 30+ minutes of focused reverse engineering work.
- **Technical Level:** Expert
- **Goals:** Solve hard challenges, earn prestige, access the Operator's Lounge
- **Pain Points:** No way to signal deep skill without self-promotion; no natural path to meet other experts

### Secondary User: Operator / Host
- **Description:** The person deploying and running the network. Uses Jeopardy hosting and the Lounge to build visibility and connect with top participants.
- **Technical Level:** Expert
- **Goals:** Establish technical credibility through hosting and authorship; identify and meet high-signal attendees; generate post-event professional conversations
- **Pain Points:** No low-cringe way to surface capabilities to potential employers/collaborators at conferences

---

## Product Vision

### Goals
1. Make joining the network feel like the first scene of an interesting story
2. Give curious people something to pull on, with depth that scales to skill
3. Create natural reasons for people to seek each other out physically
4. Reward depth without locking out casual users
5. Establish operator visibility through hosting and authorship
6. Funnel highest-signal participants into low-pressure introductions via the Operator's Lounge
7. Generate post-event conversations that lead to interviews without ever feeling like a pitch
8. Demonstrate the operator's technical capability as a portfolio piece
9. Create a reusable, conference-portable deployment (single Pi 5 in a backpack)

### Non-Goals (Out of Scope)
- Gamified engagement metrics — no dark patterns, no addictive loops
- Corporate networking features — no LinkedIn integration, no business card exchange
- PII collection — no email, phone, real name, or third-party login ever requested
- Outbound internet access — the system is a fully isolated LAN with no upstream connectivity
- Multi-Pi clustering or high availability — single device, single point of failure accepted
- Persistent cross-event identity — all identities are ephemeral, destroyed post-event
- Native mobile apps — all participant interfaces are browser-based
- Permanent data retention — zero chat/activity retention beyond 24 hours post-event (ADR-003)

### Success Metrics
| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Tier-2 adoption | A meaningful fraction of attendees reach tier 2 | Count of tier-2 identities vs. total tier-1 identities |
| Tier-3 adoption | A handful reach tier 3 and physically gather | Count of tier-3 identities + operator observation |
| Matcher success | Multiple matchmaker introductions lead to sustained conversation | Count of completed mutual QR scans |
| Operator outcome | Unprompted "let's talk after this" conversations from tier-3 attendees | Operator self-report |
| Inclusivity | Nobody feels the network is exclusionary | Informal feedback / absence of complaints |
| Tier-1 clearance time | < 1 minute for curious attendees | Time from first portal view to tier-1 badge |

---

## Functional Requirements

### Core Features

#### FR-001: DNS-Hijack Captive Portal
**Priority:** Must Have
**Description:** Pre-tier-1 clients are redirected to the portal page via DNS hijacking. All unresolved DNS queries resolve to the portal IP. Only the portal page is accessible before tier-1 clearance.
**User Story:** As a conference attendee connecting to the WiFi, I want to be immediately presented with the captive portal so that I know how to begin.
**Acceptance Criteria:**
- [ ] Any HTTP request from an unauthenticated client redirects to the portal page
- [ ] DNS hijack resolves all queries to the portal IP for unauthenticated clients
- [ ] Post-tier-1 clients get normal LAN DNS resolution
- [ ] Portal page loads within 2 seconds on first connection
**Dependencies:** FR-024 (hostapd AP mode)
**Source:** Proposal §Architecture (Network topology)

#### FR-002: Tier-1 Crackme Challenge
**Priority:** Must Have
**Description:** The portal presents a deliberately-too-polished corporate "accept terms" screen with a disabled Accept button. Users must find a hidden token (rotated across deployments) to enable it. Token hiding locations include HTTP headers, HTML comments, image alt text, console.log banners, robots.txt, and computed JS values.
**User Story:** As a curious attendee, I want to discover a hidden token so that I can unlock the network and prove I're paying attention.
**Acceptance Criteria:**
- [ ] Accept button is visually disabled until valid token is submitted
- [ ] At least 6 token-hiding mechanisms are implemented and rotatable
- [ ] Token validation runs client-side with visible source (learning experience)
- [ ] Successful submission triggers identity creation flow (FR-003)
- [ ] Average solve time for curious users is under 1 minute
**Dependencies:** FR-001
**Source:** Proposal §Primitive 1 — Tier 1

#### FR-003: Ed25519 Identity System
**Priority:** Must Have
**Description:** On tier-1 clear, the browser generates an Ed25519 keypair via WebCrypto API. Private key persists in IndexedDB. Public key + self-chosen handle is registered with the portal. All authenticated actions sign requests with the private key. Server stores only: pubkey, handle, tier, solved challenge IDs, scores, timestamps.
**User Story:** As an attendee, I want a cryptographic identity that doesn't require personal information so that I can participate fully without privacy concerns.
**Acceptance Criteria:**
- [ ] Ed25519 keypair generated via WebCrypto on first tier-1 clear
- [ ] Private key stored in IndexedDB (never transmitted)
- [ ] Handle selection with uniqueness check
- [ ] Signed cookie/JWT issued for subsequent requests
- [ ] Each app validates signatures independently with shared verification key
- [ ] No PII is ever requested or stored
- [ ] Clearing browser storage creates a new identity (no recovery without backup)
**Dependencies:** FR-002
**Source:** Proposal §Identity Model

#### FR-004: Participant Dashboard
**Priority:** Must Have
**Description:** Post-tier-1 landing page showing current tier, challenges found/remaining, leaderboard, available apps, and tier-specific content visibility.
**User Story:** As a participant, I want a dashboard showing my progress and available activities so that I know what to explore next.
**Acceptance Criteria:**
- [ ] Displays current tier badge (1/2/3) with visual flair
- [ ] Shows challenge progress (e.g., "12 hidden services exist. You've found 3.")
- [ ] Links to all tier-accessible apps (chat, Jeopardy, FlappyGhost, etc.)
- [ ] Displays leaderboard (top 10 prominent, full ranks available, no bottom-shaming)
- [ ] Content visibility changes based on tier (FR-016)
**Dependencies:** FR-003
**Source:** Proposal §Tier 1 (Reward), §Tier 2

#### FR-005: Tier-2 Hidden LAN Services
**Priority:** Should Have
**Description:** 8–12 discoverable services on the LAN, each in its own hardened container. Services include: Gopher server, Finger daemon, Telnet text adventure, mDNS-advertised services, custom DNS TXT records, MQTT broker, HTTP service with User-Agent gating, source-port-gated service, and phonebook service. Users collect partial tokens from multiple services and combine them for tier-2 promotion.
**User Story:** As an explorer, I want to discover hidden services using various network tools so that I can collect tokens and prove my discovery skills.
**Acceptance Criteria:**
- [ ] 8–12 distinct hidden services deployed in hardened containers
- [ ] Each service yields a partial token on successful interaction
- [ ] Token combination logic validates N-of-M partial tokens
- [ ] Tier-2 promotion on successful combined-token submission (signed with identity key)
- [ ] Services are discoverable through network scanning (nmap, avahi-browse, dig, etc.)
- [ ] Dashboard hint ("12 hidden services exist") drives curiosity without revealing specifics
**Dependencies:** FR-003, FR-014
**Source:** Proposal §Primitive 1 — Tier 2

#### FR-006: Tier-3 Hard-Gate Challenges
**Priority:** Should Have
**Description:** Genuinely difficult RE challenges requiring 30+ minutes of focused work. Challenge pool rotated to throttle answer-sharing. Per-user parameterized binaries keyed to the user's pubkey defeat answer-sharing entirely. Challenge types: WASM crackme, exploit chain (SQLi → hash dump → crack → flag), timing attack, custom stream cipher with key-scheduling bug.
**User Story:** As a reverse engineer, I want challenges that genuinely test my skills so that tier-3 prestige means something.
**Acceptance Criteria:**
- [ ] Per-user parameterized binaries generated from pubkey
- [ ] Flag derivation requires the user's specific binary (no sharing)
- [ ] Submission flow: derive flag → sign {flag, pubkey, timestamp} → submit
- [ ] Server verifies signature and per-user expected value
- [ ] At least 3 distinct challenge types available
- [ ] Estimated solve time: 30+ minutes for a competent RE
**Dependencies:** FR-003, FR-005 (tier-2 prerequisite)
**Source:** Proposal §Primitive 1 — Tier 3

#### FR-007: Operator's Lounge
**Priority:** Should Have
**Description:** Tier-3 exclusive features: `#lounge` chat channel, veterans wall (solve order), one-vouch invite system, aristocrat SVG flair (cigar + monocle + top hat), `looking`/`hiring` tags visible to other tier-3 users, office-hours flares scoped to lounge.
**User Story:** As a tier-3 solver, I want access to an exclusive space where everyone present has proven deep skill so that introductions are high-signal.
**Acceptance Criteria:**
- [ ] `#lounge` channel visible only to tier-3 identities
- [ ] Veterans wall lists all tier-3 handles in solve order
- [ ] First-blood badge for first solver
- [ ] Each tier-3 user gets exactly one vouch-invite token
- [ ] `looking`/`hiring` tags visible only to other tier-3 users
- [ ] Aristocrat SVG flair renders on tier-3 handles in all contexts
- [ ] Dark-wood/tweed CSS theme on tier-3 messages in chat
**Dependencies:** FR-006, FR-010
**Source:** Proposal §Operator's Lounge

#### FR-008: Hacker Jeopardy
**Priority:** Should Have
**Description:** WebSocket-based buzz-in trivia game running every :00. Categories targeted at RE/security audience. Host control panel for the operator. Team mode (physical table grouping). Round winner earns one question to the host. Spectator chat sidebar reuses the chat WebSocket fabric.
**User Story:** As a conference attendee, I want to participate in live trivia events so that there's a synchronous heartbeat to the conference network.
**Acceptance Criteria:**
- [ ] WebSocket buzz-in with millisecond-resolution latency on leaderboard
- [ ] Host control panel: advance questions, accept/reject answers, score
- [ ] Spectator chat sidebar (reuses chat infrastructure)
- [ ] Team formation support (physical table grouping)
- [ ] Half-hour scheduling (:00 cadence)
- [ ] Round winner gets "ask the host" mechanic
- [ ] Questions loaded from operator-authored JSON files
**Dependencies:** FR-003, FR-010
**Source:** Proposal §Primitive 2

#### FR-009: FlappyGhost Integration
**Priority:** Should Have
**Description:** Integration of the existing FlappyGhost game (Python Flask + WebSockets, 8 simultaneous players). Three integration points: identity adapter (validates portal's signed cookie/JWT, exposes pubkey + tier + handle), sprite gating (filter catalog by tier server-side), post-game chat hook (emit lobby state to shared bus for 15-min chat room).
**User Story:** As a participant, I want to play FlappyGhost with other attendees so that I have a small-group social mechanic beyond chat.
**Acceptance Criteria:**
- [ ] Identity adapter: Flask middleware validates portal JWT, exposes identity
- [ ] Sprite gating: tier-1 basic ghosts, tier-2 explorer ghosts, tier-3 aristocrat ghosts
- [ ] Sprite catalog filtered server-side (don't trust client-claimed tier)
- [ ] Post-game chat hook: lobby state emitted to shared bus
- [ ] 8-player lobbies with matchmaking
- [ ] Public URL accessible from tier 1 (no lockout from fun)
**Dependencies:** FR-003, FR-015
**Source:** Proposal §Primitive 3

#### FR-010: IRC-Style Chat
**Priority:** Must Have
**Description:** Multi-channel chat system with IRC aesthetics. Auto-spawned channels per scheduled talk (dies 1 hour after session ends). Interest channels that activate when ≥3 people tag in. Terminal aesthetic with `/me`, `/who`, slash commands. Who's-typing and who's-idle-but-present indicators. Pinned `#operator-log` for operator commentary.
**User Story:** As an attendee, I want contextual chat channels so that conversations have natural topics and the network feels alive.
**Acceptance Criteria:**
- [ ] Global channel + auto-spawned per-talk channels
- [ ] Interest channels activate at ≥3 interested users
- [ ] Slash commands: `/me`, `/who`, standard IRC-style
- [ ] Typing indicators and presence (idle/active)
- [ ] Terminal/IRC aesthetic (not Slack-like)
- [ ] `#operator-log` pinned channel (operator-only posting)
- [ ] Messages signed with user's identity key
**Dependencies:** FR-003
**Source:** Proposal §Primitive 4

#### FR-011: Signal Flares
**Priority:** Should Have
**Description:** Short-lived broadcasts: "I'm at [location] for [duration], want to talk about [topic]." Live list with auto-decay. Converts curiosity into conversation without formal organization.
**User Story:** As an attendee, I want to broadcast a short-lived "I'm here, let's talk" signal so that interested people can find me without formal meetup planning.
**Acceptance Criteria:**
- [ ] Flare creation: location + duration (5-30 min) + topic
- [ ] Auto-decay: flares disappear after stated duration
- [ ] Live list visible on dashboard
- [ ] Flares scoped by tier (lounge-only flares for tier 3)
- [ ] "Drop a flare for this group" button in post-game FlappyGhost lobby
**Dependencies:** FR-003, FR-004
**Source:** Proposal §Primitive 5 — Signal Flares

#### FR-012: Half-Key Skill Matcher
**Priority:** Should Have
**Description:** Each session gets a token paired to exactly one other live session, weighted by overlapping skill tags. Portal tells the user about their match's interests. Both must physically find each other and scan QR codes to unlock a reward. Forces physical introduction with pre-loaded conversation topic.
**User Story:** As an attendee, I want to be matched with someone who shares my interests so that I have a natural reason to seek them out physically.
**Acceptance Criteria:**
- [ ] Pairing algorithm weights by overlapping skill tags
- [ ] Each session paired to exactly one other live session
- [ ] Match notification shows interests of match (not identity)
- [ ] QR code mutual scan to confirm physical meetup
- [ ] Both parties receive reward on successful mutual scan
- [ ] Re-pairing when a matched session disconnects
**Dependencies:** FR-003, FR-018
**Source:** Proposal §Primitive 5 — Half-key Matcher

#### FR-013: Scoring System
**Priority:** Must Have
**Description:** Two parallel scores per identity: tier (1/2/3) as categorical gate, and points within tier for first-blood bonuses, time-to-solve, FlappyGhost wins, Jeopardy wins. Leaderboard shows first 10 prominently, full ranks available, no bottom-shaming. Opt-out flag for handles wanting progression without leaderboard presence.
**User Story:** As a participant, I want to see my progress and compete for prestige so that solving challenges feels rewarding.
**Acceptance Criteria:**
- [ ] Tier tracked as categorical (1/2/3)
- [ ] Points tracked: first-blood, time-to-solve, game wins
- [ ] Leaderboard: top 10 prominent, full ranks available
- [ ] No negative scoring, no bottom-shaming
- [ ] Opt-out flag for leaderboard visibility
- [ ] First-blood gets unique badge
**Dependencies:** FR-003
**Source:** Proposal §Scoring

#### FR-014: Container Security Model
**Priority:** Must Have
**Description:** Each application runs in its own Docker container on its own private Docker network. Containers cannot reach each other or the host except through the reverse proxy. Per-container hardening: read-only filesystem, non-root user (10000:10000), all capabilities dropped, no-new-privileges, memory and CPU limits, no privileged mode, no host networking, no Docker socket mount.
**User Story:** As the operator, I want each service isolated so that a compromised app cannot pivot to other services or the host.
**Acceptance Criteria:**
- [ ] One container per application
- [ ] Each container on its own Docker network
- [ ] `read_only: true` on all containers
- [ ] `user: "10000:10000"` (non-root)
- [ ] `cap_drop: ["ALL"]`
- [ ] `security_opt: ["no-new-privileges:true"]`
- [ ] Memory limit per container (≤256 MB default)
- [ ] CPU limit per container (≤0.5 cores default)
- [ ] No Docker socket mount, no host networking, no privileged mode
- [ ] Containers communicate only through Caddy reverse proxy
**Dependencies:** FR-015
**Source:** Proposal §Architecture (Container model)

#### FR-015: Caddy Reverse Proxy
**Priority:** Must Have
**Description:** Caddy is the only container on the AP-facing network. Handles captive portal redirect logic, LAN TLS with self-signed CA, and WebSocket reverse-proxying to backend containers.
**User Story:** As the system, I need a single ingress point that terminates TLS and routes traffic so that backend containers are never directly exposed to clients.
**Acceptance Criteria:**
- [ ] Caddy is the sole container on the AP-facing network
- [ ] Self-signed CA for LAN HTTPS
- [ ] Captive portal redirect for unauthenticated clients
- [ ] WebSocket proxying for chat, Jeopardy, FlappyGhost
- [ ] Route configuration for all backend services
- [ ] Automatic HTTPS redirect
**Dependencies:** FR-024
**Source:** Proposal §Architecture (Stack)

#### FR-016: Tiered Service-Visibility Gating
**Priority:** Must Have
**Description:** Tier progression gates which services and channels are visible/accessible. No rate limiting or connection caps. Tier 1: portal, dashboard, chat, FlappyGhost, Jeopardy. Tier 2: adds hidden services, phonebook, matcher, `#explorers` channel. Tier 3: adds lounge channel, veterans wall, vouch system.
**User Story:** As a participant, I want higher tiers to unlock new capabilities so that progression feels meaningful.
**Acceptance Criteria:**
- [ ] Tier-1 access: portal, dashboard, global chat, FlappyGhost, Jeopardy
- [ ] Tier-2 access: all tier-1 + hidden services, phonebook, matcher, `#explorers`
- [ ] Tier-3 access: all tier-2 + `#lounge`, veterans wall, vouch-invites
- [ ] No bandwidth throttling or connection limits at any tier
- [ ] Gating enforced server-side on each request (signed JWT includes tier)
- [ ] Unauthorized access attempts return appropriate error (not a crash)
**Dependencies:** FR-003
**Source:** Proposal §Tier 1–3 Rewards, reinterpreted per Discovery interview 2026-05-11

#### FR-017: Anonymous Channel
**Priority:** Nice to Have
**Description:** `#confessions` or `#overheard` channel that lowers stakes for first messages. Soft moderation: rate limits, slow mode, per-session muting. Channel can be disabled mid-event by operator.
**User Story:** As a shy attendee, I want an anonymous channel so that I can participate without social risk.
**Acceptance Criteria:**
- [ ] Anonymous channel where handle is not displayed to other users
- [ ] Rate limiting (e.g., 1 message per 30 seconds)
- [ ] Slow mode configurable by operator
- [ ] Per-session muting capability
- [ ] Operator can disable channel mid-event
- [ ] Messages still signed server-side (operator can trace abuse if needed)
**Dependencies:** FR-010
**Source:** Proposal §Primitive 4

#### FR-018: Phonebook Service
**Priority:** Should Have
**Description:** Tier-2+ users opt into showing skills, interests, and looking-for tags. Indexed by pubkey. The matcher feature (FR-012) uses this data for skill-weighted pairing.
**User Story:** As an explorer, I want to publish my skills and interests so that the matcher can pair me with relevant peers.
**Acceptance Criteria:**
- [ ] Opt-in skill tags (free-text or from a curated list)
- [ ] Opt-in "looking for" tags
- [ ] Indexed by pubkey, accessible to tier-2+ users
- [ ] Feeds data to half-key matcher (FR-012)
- [ ] Profile creation/editing via dashboard
**Dependencies:** FR-003, FR-005 (tier-2 gate)
**Source:** Proposal §Tier 2 (hidden services list)

#### FR-019: Spectator Mode
**Priority:** Nice to Have
**Description:** Low-frame-rate game-state streaming for FlappyGhost and Jeopardy. Clients not currently playing can watch active games. Reuses the chat-sidebar pattern.
**User Story:** As a spectator, I want to watch live games so that I can enjoy the spectacle without needing a slot.
**Acceptance Criteria:**
- [ ] Game state streamed to spectator endpoint
- [ ] Low frame rate (sufficient for entertainment, minimal bandwidth)
- [ ] Chat sidebar alongside spectator view (reuses chat infrastructure)
- [ ] No interaction capability from spectator view (watch-only)
**Dependencies:** FR-008, FR-009
**Source:** Proposal §Primitive 3 (Spectator mode)

#### FR-020: Downloadable Keyfile
**Priority:** Nice to Have
**Description:** Optional key export for cross-device portability. User can download their private key as a file and import it on another device to retain their identity.
**User Story:** As a participant with multiple devices, I want to export my key so that I can maintain my identity across devices.
**Acceptance Criteria:**
- [ ] "Download keyfile" button on dashboard
- [ ] Keyfile contains private key in a standard format
- [ ] Import mechanism on portal page
- [ ] Imported identity resumes with all progress intact
- [ ] Clear warning that losing the keyfile means losing the identity
**Dependencies:** FR-003
**Source:** Proposal §Identity Model

#### FR-021: Jeopardy "Ask the Host" Mechanic
**Priority:** Nice to Have
**Description:** Round winner earns the right to ask the host one question (technical or otherwise). Low-cringe, earned interaction path between participant and operator.
**User Story:** As a Jeopardy winner, I want a structured way to interact with the host so that I can start a conversation naturally.
**Acceptance Criteria:**
- [ ] Round winner highlighted on leaderboard
- [ ] "Ask the host" prompt displayed to winner
- [ ] Question submitted through chat or dedicated UI
- [ ] Host receives notification of incoming question
**Dependencies:** FR-008
**Source:** Proposal §Primitive 2

#### FR-022: Post-Game Chat Lobby
**Priority:** Should Have
**Description:** After each FlappyGhost match, the 8 players get a 15-minute persistent chat sidebar showing handles, tiers, and opted-in skill tags. Includes a "drop a flare for this group" button and a rematch button.
**User Story:** As a FlappyGhost player, I want to chat with my lobby after the game so that the 5-minute match becomes an 8-person introduction.
**Acceptance Criteria:**
- [ ] Post-game chat room persists for 15 minutes
- [ ] Shows handles, tier badges, and opted-in skill tags for all 8 players
- [ ] "Drop a flare" button creates a 20-minute flare for the group
- [ ] Rematch button keeps the same 8 together
- [ ] Room auto-closes after 15 minutes
**Dependencies:** FR-009, FR-011
**Source:** Proposal §Primitive 3 (Lobby)

#### FR-023: Operator Log Channel
**Priority:** Should Have
**Description:** Pinned `#operator-log` channel where the operator posts short commentary throughout the day. Operator-only posting. Exported for operator's records before 24-hour deletion (ADR-003).
**User Story:** As the operator, I want a pinned commentary channel so that I can build a low-key narrative presence without it being a "pitch."
**Acceptance Criteria:**
- [ ] `#operator-log` channel pinned in channel list
- [ ] Only the operator identity can post
- [ ] All participants can read
- [ ] Export mechanism (JSON/text) before retention deadline
- [ ] Included in 24-hour deletion policy (ADR-003)
**Dependencies:** FR-010
**Source:** Proposal §Primitive 4

#### FR-024: DHCP + hostapd AP Mode
**Priority:** Must Have
**Description:** Raspberry Pi 5 with ALFA AWUS036ACH running in AP mode via hostapd. DHCP server assigns addresses to clients. DNS hijack redirects unauthenticated clients to the captive portal.
**User Story:** As the system, I need to create a WiFi network that clients can join so that the captive portal experience begins.
**Acceptance Criteria:**
- [ ] hostapd configured for ALFA AWUS036ACH (RTL8812AU) in AP mode
- [ ] SSID configurable (event-specific naming)
- [ ] DHCP server assigns addresses from configured pool
- [ ] DNS server redirects unauthenticated clients to portal IP
- [ ] Post-authentication: standard LAN DNS resolution
- [ ] Design target: 200 concurrent clients (validated during experimentation; minimum viable: 35)
- [ ] Channel selection configurable (clean channel for venue)
**Dependencies:** None (foundation)
**Source:** Proposal §Architecture (Hardware, Network topology)

#### FR-025: Admin PWA
**Priority:** Must Have
**Description:** Progressive Web App for the operator, served over HTTPS with self-signed certificate. Shows real-time connected device count, per-client resource access, and system health. Primary management interface for backpack deployment (wired Ethernet may not be available).
**User Story:** As the operator running the system from a backpack, I want a mobile-friendly admin interface so that I can monitor the network from my phone without needing a wired connection.
**Acceptance Criteria:**
- [ ] PWA installable on mobile devices
- [ ] Self-signed SSL certificate (same CA as participant-facing TLS)
- [ ] Real-time connected device count (DHCP leases + authenticated identities)
- [ ] Per-client resource access view (which services each client is hitting)
- [ ] System health indicators (CPU, RAM, battery/power if available, container status)
- [ ] Accessible only to operator identity (authenticated, not tier-gated)
- [ ] Functions over the WiFi network (no wired connection required)
**Dependencies:** FR-003, FR-015
**Source:** Discovery interview 2026-05-11

### User Journeys

#### Journey 1: First-Time Attendee Joins the Network
**Trigger:** Attendee sees the SSID and connects their phone/laptop
**Steps:**
1. Device connects to WiFi AP
2. System assigns DHCP address, DNS hijack activates
3. Any HTTP request redirects to captive portal
4. User sees "corporate terms" page with disabled Accept button
5. User explores page source, headers, or other hints
6. User finds hidden token and submits it
7. System prompts for handle selection
8. Browser generates Ed25519 keypair, registers identity
9. System issues signed JWT, redirects to dashboard
10. Dashboard shows tier-1 badge, available apps, "12 hidden services exist"
**Success:** User has identity, full tier-1 access, knows what to explore next
**Failure Modes:** Token too hard to find (> 1 min); WebCrypto not supported; handle collision

#### Journey 2: Explorer Reaches Tier 2
**Trigger:** Tier-1 user sees "12 hidden services exist. You've found 0." on dashboard
**Steps:**
1. User runs network scanning tools (nmap, avahi-browse, dig, etc.)
2. User discovers hidden services on various ports/protocols
3. User interacts with each service to extract partial tokens
4. User collects N partial tokens from M different services
5. User combines tokens and submits (signed with identity key)
6. System verifies combination and signature
7. System promotes user to tier 2
8. Dashboard updates: new services visible, `#explorers` channel accessible
**Success:** User promoted to tier 2 with expanded access
**Failure Modes:** Service unreachable (container crashed); token combination invalid; insufficient tokens collected

#### Journey 3: Operator Monitors from Backpack
**Trigger:** Operator deploys Pi in backpack at conference venue
**Steps:**
1. Operator powers on Pi (battery pack)
2. Pi boots, hostapd starts, services come up
3. Operator opens admin PWA on phone (connects to AP WiFi)
4. PWA shows system health: 0 clients, all containers green
5. Attendees join; operator watches client count grow
6. Operator monitors per-client resource access
7. Operator posts in `#operator-log` as activity picks up
8. At :00, operator launches Jeopardy round from host control panel
**Success:** Operator has full visibility and control without wired access
**Failure Modes:** Battery dies; admin PWA unreachable; container OOM

---

## Non-Functional Requirements

### Performance
| Requirement | Specification |
|-------------|---------------|
| Portal page load | < 2 seconds on first connection |
| WebSocket latency (Jeopardy buzz-in) | < 50 ms round-trip on LAN |
| Identity creation | < 3 seconds (keygen + registration) |
| Dashboard render | < 1 second |
| Container boot time | < 30 seconds per container (cold start) |
| Full system boot | < 90 seconds from power-on to AP broadcasting |
| Concurrent WebSocket connections | Support 200 design target (minimum viable: 35) |

### Reliability
| Requirement | Specification |
|-------------|---------------|
| Uptime during event | System remains operational for one full conference day (12+ hours) on battery |
| Container recovery | Crashed containers auto-restart (Docker restart policy) |
| Data persistence | SQLite data survives container restart (named volumes) |
| Identity persistence | User identity survives system reboot (server-side pubkey store) |
| Graceful degradation | If a non-critical service (e.g., one hidden service) dies, all other services continue |

### Security
- **Authentication:** Ed25519 signature-based; signed JWT/cookie per session
- **Authorization:** Tier-based service-visibility gating (FR-016), enforced server-side
- **Data Protection:** No PII stored; zero retention beyond 24 hours (ADR-003); all data on encrypted SD card
- **Network Security:** Per-container isolation; Caddy as sole ingress; no inter-container communication; capabilities dropped; read-only filesystems
- **Anti-cheat:** Per-user parameterized tier-3 challenges; signed submissions; social anti-cheat (first-blood prestige)

### Scalability
- **Users:** Design target 200 concurrent clients; minimum viable 35
- **Data:** SQLite per app; event data is ephemeral (deleted within 24 hours)
- **Growth:** Not applicable — single-event deployments, no scaling beyond one device

---

## Technical Constraints

### Hardware
- **Platform:** Raspberry Pi 5, 4–8 GB RAM
- **WiFi Adapter:** ALFA AWUS036ACH (RTL8812AU chipset)
- **Storage:** 64 GB SD card
- **Power:** Battery pack (USB-C PD); minimum 12-hour runtime target for one conference day
- **Form Factor:** Backpack-portable; no external monitor or keyboard required during operation

### Software
- **Operating System:** Raspberry Pi OS (Debian Bookworm-based)
- **Container Runtime:** Docker with Docker Compose
- **Reverse Proxy:** Caddy
- **Identity Crypto:** Ed25519 (WebCrypto API client-side, server-side verification)
- **Storage Engine:** SQLite per application
- **Pubsub Bus:** NATS or Redis (deferred to TechStack Agent evaluation)
- **WiFi AP:** hostapd with RTL8812AU driver
- **FlappyGhost:** Python Flask + WebSockets (existing codebase, integration-only)

### Network
- **Connectivity:** WiFi AP mode only; fully isolated LAN; no upstream internet
- **Protocols:** HTTP/HTTPS, WebSocket, DNS, DHCP, mDNS, MQTT, Telnet, Finger, Gopher, custom TCP
- **Ports:** 80 (redirect), 443 (Caddy TLS), 53 (DNS), 67-68 (DHCP), 70 (Gopher), 79 (Finger), 1883 (MQTT), various high ports for hidden services
- **Ops Path:** Admin PWA over WiFi (primary); wired Ethernet optional fallback

### Environment
- **Location:** Indoor conference venues
- **Power:** Battery pack (USB-C PD); overnight charging between event days
- **Temperature:** Indoor ambient (15–35°C); heat dissipation in backpack is a risk
- **Deployment Duration:** Multi-day (2–4 days) with daily charge cycles

### Spanning Surface: Browser Clients
- All participant-facing UIs are HTML/JS/CSS served over HTTPS + WebSocket
- Client-side crypto requires WebCrypto API (modern browsers: Chrome 60+, Firefox 57+, Safari 11+)
- Self-signed CA: clients must accept certificate warning on first connection (captive portal flow mitigates this for HTTP → HTTPS redirect)
- Admin PWA must function on mobile browsers (operator's phone)

---

## Integration Requirements

### External Systems
| System | Integration Type | Data Exchanged |
|--------|-----------------|----------------|
| FlappyGhost (existing codebase) | Flask middleware adapter | Identity (pubkey, tier, handle), sprite catalog filtering |
| NATS/Redis (pubsub bus) | Event-driven messaging | Game state, lobby events, flare broadcasts, chat hooks |

### Internal Service Communication
| Service | Communicates With | Via |
|---------|-------------------|-----|
| Portal app | All services | Issues JWT; shared verification key |
| Jeopardy | Chat | Pubsub (spectator sidebar) |
| FlappyGhost | Chat | Pubsub (post-game lobby hook) |
| Flares | Dashboard, Chat | Pubsub (broadcast) |
| Matcher | Phonebook | Direct API (skill tags) |
| Admin PWA | hostapd, Docker API | System metrics collection |

---

## Assumptions and Risks

### Assumptions
- ALFA AWUS036ACH (RTL8812AU) works reliably with hostapd on Pi 5 with current kernel drivers
- Pi 5 (8 GB) has sufficient resources for ~15 Docker containers serving 200 concurrent WebSocket clients
- A USB-C PD battery pack can sustain 10–15W draw for 12+ hours (requires ~150-200Wh pack)
- Self-signed CA is acceptable for LAN TLS in a captive portal context
- FlappyGhost (existing codebase) is in a state where identity adapter integration is straightforward
- Conference attendees have modern browsers with WebCrypto support
- All challenge content (Jeopardy questions, crackme binaries, hidden-service puzzles) is authored by the operator pre-event and stored as config/data files
- Indoor venue has acceptable RF environment for WiFi AP operation

### Risks
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| ALFA adapter cannot serve 200 clients in AP mode | High | High | Experimentation-phase validation; accept lower ceiling or add second adapter |
| RTL8812AU driver instability on Pi 5 | Medium | High | Test in experimentation phase; have backup adapter (different chipset) identified |
| Battery insufficient for full conference day | Low | Medium | Size battery conservatively (200Wh); operator can hot-swap or find outlet |
| Heat buildup in backpack damages Pi or adapter | Medium | Medium | Ventilated compartment; temperature monitoring in admin PWA; throttle if needed |
| Participant exploits an app and pivots to host | Low | High | Per-container hardening (FR-014); no shared networks; read-only FS; cap_drop ALL |
| Self-signed CA causes excessive friction at tier-1 | Medium | Medium | Captive portal flow (HTTP redirect) avoids initial cert warning; clear instructions |
| Tier-3 answers shared despite parameterization | Low | Low | Per-user binaries defeat sharing; treat leaks as social signal, not security failure |
| Anonymous channel attracts harassment | Medium | Medium | Soft moderation: rate limits, slow mode, muting, channel disable capability |
| SQLite lock contention at 200 concurrent users | Medium | Medium | One SQLite DB per app (not shared); WAL mode; consider upgrade path to PostgreSQL |
| FlappyGhost integration more complex than estimated | Low | Medium | Game exists and is playable; integration is 3 defined touchpoints |

---

## Open Questions

- [ ] Exact battery pack model/capacity — needs to sustain 10-15W for 12+ hours
- [ ] Heat management strategy for backpack deployment (passive venting? active fan?)
- [ ] RTL8812AU driver source: in-kernel vs. aircrack-ng/rtl8812au — which is more stable on Pi 5?
- [ ] Actual concurrent client ceiling for ALFA AWUS036ACH in AP mode (experimentation must validate)
- [ ] Whether SQLite WAL mode is sufficient at 200 clients or if a lightweight DB (PostgreSQL in container) is needed
- [ ] Self-signed CA distribution strategy — can the portal serve the CA cert for one-click install?

---

## Appendix

### Glossary
| Term | Definition |
|------|------------|
| Tier | Categorical access level (1/2/3) gating which services are visible |
| Crackme | A deliberately vulnerable or puzzle-containing program designed to be reverse engineered |
| Captive Portal | A web page shown to newly connected WiFi clients before granting network access |
| Ed25519 | An elliptic-curve digital signature algorithm; used here for user identity |
| WebCrypto | Browser API for cryptographic operations (key generation, signing) |
| hostapd | Linux daemon that turns a WiFi adapter into an access point |
| Flare | A short-lived broadcast indicating physical location and conversation topic |
| Half-key Matcher | System that pairs two users by complementary skill tags and requires physical meetup |
| Operator's Lounge | Tier-3 exclusive space with high-signal networking features |
| PWA | Progressive Web App — a web page installable as a native-like app on mobile |

### References
- Proposal: `docs/inputs/product_proposal.md` (sha256 `789600305db2466432b336771ed19a6253cfeb32d334623f1fd4fda6e5e1357c`)
- FlappyGhost: https://github.com/CaptainMcCrank/FlappyGhost
- ADR-001: No RF Wardriving Challenge (DECISIONS.md)
- ADR-002: No Physical Props (DECISIONS.md)
- ADR-003: Zero Chat Retention Beyond 24 Hours (DECISIONS.md)
- ADR-004: Publish App Source Post-Event (DECISIONS.md)
