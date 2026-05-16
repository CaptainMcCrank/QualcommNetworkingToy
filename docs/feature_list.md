# Feature List: Conference WiFi Captive Portal

**Generated:** 2026-05-11
**From PRD:** docs/prd.md

---

## Feature Prioritization Matrix

| ID | Feature | Priority | Effort | Testing Category |
|----|---------|----------|--------|------------------|
| FR-024 | DHCP + hostapd AP mode | Must Have | High | Smoke, Integration, Chaos |
| FR-001 | DNS-hijack captive portal | Must Have | Medium | Smoke, Integration |
| FR-015 | Caddy reverse proxy | Must Have | Medium | Smoke, Integration, Security |
| FR-014 | Container security model | Must Have | High | Security, Chaos |
| FR-003 | Ed25519 identity system | Must Have | High | Smoke, Integration, Security |
| FR-002 | Tier-1 crackme | Must Have | Medium | Smoke |
| FR-004 | Dashboard | Must Have | Medium | Smoke, Integration |
| FR-016 | Tiered service-visibility gating | Must Have | Medium | Smoke, Integration, Security |
| FR-013 | Scoring system | Must Have | Medium | Smoke, Integration |
| FR-010 | IRC-style chat | Must Have | High | Smoke, Integration, Performance |
| FR-025 | Admin PWA | Must Have | High | Smoke, Integration |
| FR-005 | Tier-2 hidden LAN services | Should Have | High | Smoke, Integration, Security |
| FR-018 | Phonebook service | Should Have | Low | Smoke |
| FR-008 | Hacker Jeopardy | Should Have | High | Smoke, Integration, Performance |
| FR-009 | FlappyGhost integration | Should Have | Medium | Smoke, Integration |
| FR-022 | Post-game chat lobby | Should Have | Medium | Integration |
| FR-011 | Signal flares | Should Have | Medium | Smoke |
| FR-012 | Half-key matcher | Should Have | High | Smoke, Integration |
| FR-023 | Operator log channel | Should Have | Low | Smoke |
| FR-016 | Tiered rate limiting (now: visibility gating) | Must Have | Medium | Integration, Security |
| FR-006 | Tier-3 hard-gate challenges | Should Have | High | Smoke, Security |
| FR-007 | Operator's Lounge | Should Have | Medium | Integration |
| FR-017 | Anonymous channel | Nice to Have | Low | Smoke, Security |
| FR-019 | Spectator mode | Nice to Have | Medium | Integration, Performance |
| FR-020 | Downloadable keyfile | Nice to Have | Low | Smoke |
| FR-021 | Jeopardy "ask the host" | Nice to Have | Low | Smoke |

---

## Testing Categories

### Smoke Tests
Quick validation that core functionality works.
- FR-024: hostapd starts, DHCP assigns address, SSID visible
- FR-001: HTTP request from new client redirects to portal
- FR-015: Caddy serves portal page over HTTPS
- FR-003: Keypair generation succeeds, handle registration works, JWT issued
- FR-002: Token discoverable, submission enables Accept button
- FR-004: Dashboard renders with tier badge and app links
- FR-016: Tier-1 user sees only tier-1 services; tier-2 sees tier-2 services
- FR-013: Points increment on challenge solve; leaderboard renders
- FR-010: Chat message sent and received by another client
- FR-025: Admin PWA loads, shows connected device count
- FR-005: At least one hidden service responds correctly
- FR-018: Phonebook profile creation and retrieval
- FR-008: Jeopardy round starts, buzz-in registers
- FR-009: FlappyGhost lobby joins with portal identity
- FR-011: Flare created, appears in list, decays after duration
- FR-012: Matcher pairs two sessions with overlapping tags
- FR-023: Operator can post to #operator-log
- FR-006: Tier-3 binary downloads, parameterized to pubkey
- FR-017: Anonymous message posts without visible handle
- FR-020: Keyfile downloads and imports on another device
- FR-021: Round winner sees "ask the host" prompt

### Integration Tests
Validate service interactions.
- FR-001 ↔ FR-024: DNS hijack correctly intercepts pre-auth clients
- FR-003 ↔ FR-002: Tier-1 solve triggers identity creation flow
- FR-003 ↔ FR-016: JWT tier claim correctly gates service access
- FR-015 ↔ FR-014: Caddy routes to containers on isolated networks
- FR-009 ↔ FR-003: FlappyGhost identity adapter validates portal JWT
- FR-009 ↔ FR-010: Post-game lobby chat hook emits to shared bus
- FR-008 ↔ FR-010: Jeopardy spectator sidebar appears in chat
- FR-012 ↔ FR-018: Matcher reads skill tags from phonebook
- FR-005 ↔ FR-013: Hidden service token collection updates score
- FR-022 ↔ FR-011: Post-game "drop a flare" creates a live flare
- FR-025 ↔ FR-024: Admin PWA shows real-time DHCP lease count
- FR-004 ↔ FR-016: Dashboard content updates on tier promotion

### System Tests
End-to-end user journey validation.
- Journey 1: First-time attendee joins → clears tier 1 → lands on dashboard
- Journey 2: Explorer discovers services → collects tokens → promotes to tier 2
- Journey 3: Operator deploys from backpack → monitors via admin PWA → hosts Jeopardy round
- Journey 4: Two users create phonebook profiles → matcher pairs them → mutual QR scan completes
- Journey 5: 8 players join FlappyGhost lobby → play match → post-game chat activates → flare dropped

### Performance Tests
Load and stress testing.
- FR-024: WiFi stability at 35, 100, 150, 200 concurrent clients
- FR-010: Chat message delivery latency at 200 concurrent users
- FR-008: Jeopardy buzz-in latency at 50 concurrent buzzers
- FR-009: FlappyGhost frame rate with 8 players + 25 spectators
- FR-015: Caddy throughput under 200 concurrent HTTPS connections
- FR-025: Admin PWA update frequency under load (device count, resource access)
- System-wide: CPU/RAM usage at 200 concurrent clients across all services

### Security Tests
Vulnerability and access control testing.
- FR-014: Container escape attempts (verify no inter-container communication)
- FR-016: Tier spoofing (modify JWT tier claim — server must reject)
- FR-003: Identity forgery (submit requests with invalid signatures)
- FR-005: Hidden service container hardening verification (read-only FS, non-root, no caps)
- FR-006: Tier-3 answer sharing attempt (verify per-user parameterization)
- FR-017: Anonymous channel abuse (verify rate limiting, muting)
- FR-015: Caddy TLS configuration (no weak ciphers, no plaintext fallback except portal redirect)
- FR-025: Admin PWA access from non-operator identity (must be rejected)

### Chaos Tests
Failure injection and resilience testing.
- Container crash during active Jeopardy round — other services unaffected
- Container crash during FlappyGhost match — game handles disconnection gracefully
- hostapd restart — clients reconnect; identities persist
- SQLite database corruption on one service — other services unaffected
- Battery power fluctuation — system remains stable
- Docker daemon restart — containers recover via restart policy
- SD card full — system degrades gracefully (logs stop, services continue)
- RF interference simulation — connection drops and reconnections under load

---

## Implementation Order

Based on dependencies and risk, implement in this order:

### Phase 0: Foundation
1. **FR-024**: DHCP + hostapd AP mode (ALFA AWUS036ACH)
2. **FR-015**: Caddy reverse proxy with self-signed CA
3. **FR-014**: Container security model (hardening template)

### Phase 1: Identity + Tier 1
4. **FR-001**: DNS-hijack captive portal
5. **FR-003**: Ed25519 identity system
6. **FR-002**: Tier-1 crackme
7. **FR-004**: Dashboard
8. **FR-016**: Tiered service-visibility gating
9. **FR-013**: Scoring system

### Phase 2: Chat + Flares + Admin
10. **FR-010**: IRC-style chat
11. **FR-023**: Operator log channel
12. **FR-011**: Signal flares
13. **FR-025**: Admin PWA

### Phase 3: Hacker Jeopardy
14. **FR-008**: Hacker Jeopardy
15. **FR-021**: Jeopardy "ask the host" mechanic

### Phase 4: FlappyGhost Integration
16. **FR-009**: FlappyGhost integration
17. **FR-022**: Post-game chat lobby
18. **FR-019**: Spectator mode

### Phase 5: Tier 2 — Discovery Layer
19. **FR-005**: Tier-2 hidden LAN services (all 8–12)
20. **FR-018**: Phonebook service
21. **FR-012**: Half-key skill matcher
22. **FR-017**: Anonymous channel

### Phase 6: Tier 3 — Hard Gate + Lounge
23. **FR-006**: Tier-3 hard-gate challenges
24. **FR-007**: Operator's Lounge
25. **FR-020**: Downloadable keyfile

---

## Dependency Graph

```
FR-024 (hostapd AP)
   │
   ├── FR-015 (Caddy reverse proxy)
   │      │
   │      ├── FR-014 (Container security)
   │      │      │
   │      │      └── FR-005 (Hidden services) ──── FR-018 (Phonebook)
   │      │             │                              │
   │      │             └── FR-006 (Tier-3 challenges) └── FR-012 (Matcher)
   │      │                    │
   │      │                    └── FR-007 (Operator's Lounge)
   │      │
   │      └── FR-025 (Admin PWA)
   │
   └── FR-001 (DNS-hijack portal)
          │
          └── FR-002 (Tier-1 crackme)
                 │
                 └── FR-003 (Identity system)
                        │
                        ├── FR-004 (Dashboard)
                        │      │
                        │      └── FR-011 (Flares)
                        │
                        ├── FR-016 (Tier gating)
                        │
                        ├── FR-013 (Scoring)
                        │
                        ├── FR-010 (Chat)
                        │      │
                        │      ├── FR-023 (Operator log)
                        │      ├── FR-017 (Anonymous channel)
                        │      └── FR-008 (Jeopardy)
                        │             │
                        │             └── FR-021 (Ask the host)
                        │
                        ├── FR-009 (FlappyGhost)
                        │      │
                        │      ├── FR-022 (Post-game lobby)
                        │      └── FR-019 (Spectator mode)
                        │
                        └── FR-020 (Keyfile download)
```

---

## Acceptance Criteria Summary

### Must Have Features (All must pass for v1.0)

| Feature | Acceptance Test |
|---------|-----------------|
| FR-024 | hostapd broadcasts SSID; DHCP assigns address; client connects |
| FR-001 | Unauthenticated HTTP request redirects to portal page |
| FR-015 | Caddy serves HTTPS with self-signed cert; proxies WebSocket |
| FR-014 | All containers run as non-root, read-only FS, caps dropped, isolated networks |
| FR-003 | Ed25519 keypair generated; handle registered; JWT issued; signed requests validate |
| FR-002 | Hidden token discoverable; submission enables Accept; tier-1 granted |
| FR-004 | Dashboard shows tier, progress, leaderboard, available apps |
| FR-016 | Tier-1 user cannot access tier-2 services; tier changes gate correctly |
| FR-013 | Points increment on solve; leaderboard displays correctly |
| FR-010 | Chat messages sent/received; channels create/destroy; slash commands work |
| FR-025 | Admin PWA shows device count and resource access; operator-only auth |

### Should Have Features (Target for v1.0)

| Feature | Acceptance Test |
|---------|-----------------|
| FR-005 | 8+ hidden services respond; partial tokens extractable; combination promotes to tier 2 |
| FR-018 | Skill tags stored; phonebook queryable by tier-2+ users |
| FR-008 | Jeopardy round runs; buzz-in registers; host panel controls game |
| FR-009 | FlappyGhost validates portal identity; sprites gated by tier |
| FR-022 | Post-game lobby chat persists 15 min; flare button works |
| FR-011 | Flare created; appears in live list; auto-decays |
| FR-012 | Two users matched by skill overlap; QR scan completes pairing |
| FR-023 | Operator posts to #operator-log; all users can read |
| FR-006 | Per-user binary generated; flag derived; signed submission validates |
| FR-007 | Tier-3 users see #lounge; veterans wall populated; vouch token works |

### Nice to Have Features (Post v1.0 if time permits)

| Feature | Acceptance Test |
|---------|-----------------|
| FR-017 | Anonymous messages post without handle; rate limit enforced |
| FR-019 | Spectators view game state stream; chat sidebar visible |
| FR-020 | Keyfile downloads; reimport on another device restores identity |
| FR-021 | Round winner sees prompt; host receives question |
