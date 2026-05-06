# Conference WiFi Captive Portal — Proposal

A Raspberry Pi 5 access point with a captive portal that doubles as a social fabric for a reverse-engineering-leaning audience. The design optimizes for *authentic, curious discovery and ad-hoc community formation* — not gamified engagement metrics, not corporate networking. Five composable primitives cover the full interaction-shape space (solo, pair, small group, mass), tied together by a single cryptographic identity and a half-hour event rhythm.

---

## Goals

**Participant-facing**
- Make joining the network feel like the first scene of an interesting story.
- Give curious people something to pull on, with depth that scales to skill.
- Create natural reasons for people to seek each other out physically.
- Reward depth without locking out casual users.

**Operator-facing (host)**
- Establish operator visibility through hosting (Jeopardy, tournaments) and authorship (the network *is* the portfolio).
- Funnel the highest-signal participants into low-pressure introductions through the Operator's Lounge.
- Generate post-event conversations that lead to interviews without ever feeling like a pitch.

---

## The Five Primitives

| Primitive | Interaction shape | Role |
|---|---|---|
| Tiered crackme captive portal | Solo discovery | Sets tone; self-selects depth |
| Hacker Jeopardy (every :00) | Mass spectacle | Synchronous heartbeat; operator stage |
| FlappyGhost (every :30) | Small group (8) | Ad-hoc meetup primitive |
| Half-key skill matcher | Pair | Forces high-signal physical introductions |
| IRC-style chat + signal flares | Async + ephemeral broadcast | Connective tissue and spontaneous meetups |

Each primitive does one job. Together they reinforce each other through a shared identity, shared scoring, and shared cosmetics.

---

## Identity Model (cross-cutting)

Pure cryptographic identity. No email, phone, real name, or third-party login is ever requested.

- On first tier-1 clear, the browser generates an Ed25519 keypair via WebCrypto. Private key persists in IndexedDB. Public key plus a self-chosen handle is registered with the portal.
- All authenticated actions across all apps sign their requests with the privkey.
- Optional **download keyfile** for cross-device portability.
- Clearing browser storage = new identity, no recovery (backup is opt-in).
- Server-side record per identity is minimal: pubkey, handle, tier, set of solved challenge IDs, scores, timestamps.

This gives persistent identity, full auditability of solves, and zero PII exposure. The pubkey is the user.

---

## Primitive 1 — Tiered Crackme Captive Portal

A three-tier progression where solving each tier unlocks more of the network. Sets the tone in the first 30 seconds.

### Tier 1 — The Web App

Every curious person clears this in under a minute. Tone-setter, not a gate.

The portal page presents as a deliberately-too-polished corporate "accept terms" screen. The terms are subtly off (clauses like "you agree to be reverse engineered"). The Accept button is disabled. Enabling requires finding and submitting a token hidden somewhere in plain sight — rotated across deployments to keep it fresh:

- An HTTP response header (e.g., `X-Shibboleth: <token>`)
- A base64 string inside an HTML comment
- The `alt` text of a 1×1 pixel
- A `console.log` banner that prints the token via JS
- A `robots.txt` entry pointing to `/.well-known/the-real-token`
- A token computed from a small JS function the user can read

The validator runs client-side and its source is visible — readable as a learning experience for the shape of harder puzzles. Submit the token, get the welcome screen, choose a handle, browser quietly generates the keypair, dropped onto the dashboard with a tier-1 badge.

**Reward:** Full LAN access, standard outbound rate limit, hidden services become *discoverable*, all standard apps unlocked.

### Tier 2 — Hidden LAN Services

The dashboard tells you "12 hidden services exist on this network. You've found 0." That's the only hint.

Concrete service ideas (each its own hardened container):

- **Gopher server** on port 70 serving ASCII-art riddles. Just running gopher in 2026 is a flag for "you found something."
- **Finger daemon** (RFC 1288): `finger operator@gateway` returns a vCard containing a token piece.
- **Telnet/nc text adventure** on a high port — short Zork-style traversal ending in a token.
- **mDNS-advertised services** with deliberately weird names (`_crackme._tcp`, `_confessional._tcp`). `avahi-browse` users find them instantly.
- **Custom DNS server** returning interesting `TXT` records for `puzzle.local`-style queries.
- **MQTT broker** publishing live Jeopardy state and dripping puzzle pieces on `tokens/scattered/+`.
- **HTTP service on a high port** that responds normally to a browser but differently to `curl` with a specific User-Agent.
- **A service that only responds when source port matches a pattern** (rewards `nmap --source-port`).
- **Phone book service** indexed by pubkey. Tier-2+ users opt into showing skills, interests, and looking-for tags. The matcher feature lives here.

**Progression:** Collect N partial tokens from M services, combine them, submit signed with your key. Server verifies, promotes to tier 2.

**Reward:** Higher rate limit; access to `#explorers` chat; tier-3 challenge pack downloadable; sprite catalog (FlappyGhost) unlocks explorer-themed ghosts.

### Tier 3 — The Hard Gate

Should actually be hard — 30+ minutes of focused work for a competent reverse engineer. Rotate the challenge pool to throttle answer-sharing:

- **WASM crackme** with mild anti-debugging, virtualized instruction set, flag buried inside.
- **Exploit chain**: deliberately vulnerable LAN service requiring SQLi → weak hash dump → offline crack (bcrypt with low cost — laptop-feasible, no GPU farm) → authenticated endpoint → final flag.
- **Side-channel timing attack** against a service that compares MACs naively.
- **Hidden low-power second AP** somewhere in the venue. Its SSID/beacon hints at a tier-3-only HTTP service. RF wardriving in microcosm.
- **Custom stream cipher** with a subtle key-scheduling bug.
- **Per-user parameterized binaries**: each tier-2 solver who downloads the tier-3 pack gets a binary unique to their pubkey, with a flag derived from that key. Defeats answer-sharing entirely.

**Submission flow:** Derive the flag, sign `{flag, pubkey, timestamp}` with the privkey, submit. Server verifies signature and per-user expected value, promotes.

**Reward:** Operator's Lounge access (next section).

### The Operator's Lounge

The payoff and the place where the operator's job-finding play quietly lives.

- Handles render with **cigar + monocle + top hat** SVG flair layered over the avatar. Subtle dark-wood/tweed CSS theme on tier-3 messages in chat.
- `#lounge` channel becomes visible. Operator lives there between rounds. Conversation is automatically high-signal because everyone present cleared a 30-minute RE challenge.
- **Veterans wall** lists all tier-3 handles publicly in solve order. First-blood gets a unique badge. People compete for top slots.
- Tier-3 folks can set a single `looking` or `hiring` tag visible to other tier-3 folks. Trust in this subset is high — this is where real introductions happen.
- **One-vouch invite**: each tier-3 solver gets exactly one token to grant tier-3 to someone they personally vouch for. Creates social currency without diluting prestige.
- **Office-hours flares** scoped to the lounge: "back-corner table 3–4pm if anyone wants to talk firmware exploitation."
- **Physical lounge**: rope off a corner of the venue, stock with cheap props (plastic monocles, foam cigars, novelty top hats). Tier-3 folks wear them physically. Digital flair becomes a real-world signal. The network bleeds into meatspace, which is the entire point.

---

## Primitive 2 — Hacker Jeopardy

Synchronous heartbeat. Every :00 there is a *thing happening now*. The operator hosts.

- WebSocket buzz-in with millisecond latency surfaced on the leaderboard. Someone will try to MITM it; embrace it as a bonus category for "most creative cheat."
- Categories that land with this crowd: "name the obfuscator," "0day or CVE," "guess the arch from this disassembly," "famous malware: real or fabricated," "decompile this in your head."
- Team mode where teams form *physically* (huddled at a table) beats solo for social outcomes.
- Round winner gets to ask the host one question, technical or otherwise. Earned, mutual, low-cringe way for someone to talk to the operator.
- Spectator chat sidebar runs on the same WebSocket fabric used by chat — written once, used twice.

---

## Primitive 3 — FlappyGhost Integration

Reference: <https://github.com/CaptainMcCrank/FlappyGhost> — Python Flask + WebSockets, up to 8 simultaneous players, selectable ghost sprites, captive-portal-native, Ansible-deployed. Project is pre-PRD; this proposal assumes integration work happens during its initial development phases.

FlappyGhost fills the missing primitive: **small-group synchronous play**. Jeopardy is mass-spectator. The matcher and flares are 1:1 or 1:few. An 8-player lobby is small enough that everyone gets identified, big enough to feel like a *room*. Drops in cleanly:

### Sprite selector becomes the tier flair system

The cleanest integration point. The existing sprite picker is the carrier for prestige cosmetics — same flair the user's chat handle wears.

- **Tier 1**: basic ghost roster
- **Tier 2**: explorer-themed ghosts (pith helmet, goggles, lantern), unlocked when hidden-service tokens are collected
- **Tier 3**: aristocrat ghosts (monocle, top hat, lit cigar)
- **First-blood / weekly champions**: gold-trim or animated variant

Sprite catalog is filtered server-side based on the validated identity's tier. Don't trust client-claimed tier.

### Lobby = ad-hoc meetup primitive

After every match:

- Lobby chat sidebar persists for 15 minutes.
- The 8 players see each others' handles, tiers, and any opted-in skill tags.
- A "drop a flare for this group" button converts the post-game chat into a 20-minute "we're at table 4 keeping it going" flare.
- Rematch button keeps the same 8 together.

Every 5-minute match becomes an 8-person introduction. With 5–35 active clients, expect 1–4 lobbies concurrently. Pi 5 with Flask-SocketIO at 8 connections per lobby is well within budget.

### Discovery integration

- Public FlappyGhost URL is on the dashboard from tier 1. Don't lock anyone out of fun.
- *Specific lobby codes* are puzzle answers — "Lobby `0xC0FFEE` — solve this to join."
- Tier-3-only lounge tournaments where everyone flies aristocrat ghosts. Operator commentates: another stage moment.

### Spectator mode

The other clients (up to ~27 not currently playing) can watch. Stream low-frame-rate game state to a public viewer with the same chat-sidebar pattern Jeopardy uses. Reuse the harness.

### Required integration work

Three things, in order, since the project is pre-PRD:

1. **Identity adapter** — Flask middleware that validates the captive portal's signed cookie/JWT and exposes pubkey + tier + handle. ~50 lines.
2. **Sprite gating** — read tier from validated identity, filter sprite catalog server-side before sending to client.
3. **Post-game chat hook** — emit lobby state into the shared chat bus (NATS/Redis) when a match ends, so the chat container can spin up the 15-minute lobby room.

Everything else (tournaments, spectator mode, leaderboard etching, lobby-code puzzles) is additive and can land in later phases without blocking core integration.

---

## Primitive 4 — IRC-style Chat

Connective tissue. The reason most conference chats die: no context. Pure global chat is sterile. The fixes:

- Auto-spawned channels per scheduled talk (live during the session, dies an hour after).
- Interest channels that lobby into existence when ≥3 people tag in (`#firmware`, `#fuzzing`, `#crypto`).
- One **anonymous channel** (`#confessions` or `#overheard`) that lowers stakes for first messages and seeds activity everywhere else.
- IRC vibes over Slack vibes: `/me`, `/who`, slash commands, terminal aesthetic. Slack clones get ignored by this audience.
- Show *who's typing* and *who's idle but present*. The authentic-presence signal that makes a room feel alive.
- Pinned `#operator-log` channel where the operator posts short, opinionated commentary across the day. Becomes a low-key portfolio without ever being one.

---

## Primitive 5 — Half-key Matcher & Signal Flares

### Half-key matcher

Each session gets a token paired to exactly one other live session, weighted by overlapping skill tags. Portal tells you: "your match is interested in firmware fuzzing and is somewhere in this building — find them, scan each other's QR, you both unlock X." Forces a physical introduction with a pre-loaded conversation topic. Highest-leverage single mechanic for community formation.

### Signal flares

Short-lived broadcasts: "I'm at table 4 for the next 20 min, want to talk about $TOPIC." Or "free for a 15-min pair on $X." Live list, optionally pinned to a venue map, auto-decays. Converts curiosity into conversation without anyone having to organize.

---

## Event Cadence

Half-hour rhythm gives the network a heartbeat:

- **:00** — Hacker Jeopardy round (operator hosts, mass spectacle)
- **:30** — FlappyGhost qualifier lobbies (small-group play)
- **Continuous** — chat, flares, matcher, hidden-service discovery, crackme tiers

Cross-pollinates audiences. People who don't buzz in still want to fly a ghost. People who can't dodge still want trivia. Both surface chat activity and feed back into the discovery layer.

---

## Architecture

### Hardware

- Raspberry Pi 5 (4–8 GB RAM)
- USB WiFi adapter with reliable AP mode (`hostapd` compatible)
- Optional secondary low-power AP for the tier-3 wardriving challenge

### Network topology

- Captive portal hijacks DNS for unresolved queries; pre-tier-1 clients see only the portal IP.
- Post-tier-1: standard outbound rate limit, full LAN reachability.
- Post-tier-2: bumped rate limit; tier-3 challenge pack accessible.
- Post-tier-3: lounge-only services and channels.

### Container model

Each app is its own Docker container, each on its own private Docker network. They cannot reach each other or the host except through the reverse proxy.

Per-container hardening (defense in depth — Pi 5 has the headroom):

```yaml
# illustrative; not literal compose
services:
  app:
    image: app:tag
    read_only: true
    user: "10000:10000"
    cap_drop: ["ALL"]
    security_opt: ["no-new-privileges:true"]
    networks: [app_internal]
    mem_limit: 256m
    cpus: "0.5"
    # no privileged, no host networking, no docker socket mount
```

### Stack

- **Caddy** as the only container on the AP-facing network. Handles captive portal redirect, LAN TLS (self-signed CA, optionally gated by a meta-puzzle), and WebSocket reverse-proxying.
- **One container per app** (Jeopardy, FlappyGhost, chat, matcher, flares, phonebook, plus each hidden service).
- **Auth**: signed cookie / JWT issued by the portal app on tier-1 clear. Each app validates independently with the shared verification key — no central session store.
- **Storage**: SQLite per app in a named volume. 35 concurrent clients does not need Postgres.
- **Optional bus**: NATS or Redis for cross-app pubsub (Jeopardy state mirroring into chat, FlappyGhost lobby chat handoff, flare broadcasts).
- **Resource caps** per container so a runaway app cannot kill the host.

### Wireless concerns

The Pi 5 will laugh at 35 concurrent WebSocket clients with light traffic. The real risk is the wireless side:

- Pick a clean channel; expect interference at any decent-sized venue.
- Have a wired ops path to the Pi so admin access survives RF chaos.
- Channel scan beforehand and during the event.

---

## Scoring

Two parallel scores per identity:

- **Tier** (1/2/3) — categorical, the gate.
- **Points** within tier — first-blood bonuses, time-to-solve, optional easter eggs, host-flagged creative solutions, FlappyGhost wins, Jeopardy round wins.

Leaderboard surfaces "first 10 solvers" prominently (the prestigious slots) and shows full ranks but never shames the bottom. No negative scoring. Opt-out flag for handles that want progression without leaderboard presence.

Anti-cheat is mostly social: per-user parameterized tier-3 challenges, signed submissions everywhere, first-blood prestige to incentivize solo solves.

---

## Phasing

A pragmatic build order that keeps the project useful at every stage. Each phase is a viable deployment.

**Phase 0 — Foundation**
- Pi 5 imaged, hostapd + DHCP + DNS hijack working, captive portal serves a placeholder.
- Container model and Caddy reverse proxy in place. One sample app passes hardening checks.

**Phase 1 — Identity + Tier 1**
- Ed25519 identity flow, handle selection, signed-cookie auth.
- Tier-1 crackme on the captive portal. Dashboard shell.
- Outcome: people can join, get an identity, see a tier-1 badge.

**Phase 2 — Chat + Flares**
- IRC-style chat with auto-spawned per-talk channels, anonymous channel, slash commands.
- Signal flares.
- Outcome: the network has connective tissue. Already useful even without games.

**Phase 3 — Hacker Jeopardy**
- Buzz-in WebSocket protocol, host control panel, spectator chat sidebar.
- Half-hour scheduling.
- Outcome: synchronous heartbeat, operator visibility.

**Phase 4 — FlappyGhost integration**
- Identity adapter, sprite gating, post-game chat hook.
- Lobby system live.
- Outcome: small-group play primitive online.

**Phase 5 — Tier 2 hidden services + matcher + phonebook**
- Roll out 8–12 hidden services. Token combination logic. Phonebook with skill tags.
- Half-key matcher live.
- Outcome: discovery layer fully active. Forced physical introductions.

**Phase 6 — Tier 3 + Operator's Lounge**
- Per-user parameterized hard challenges. Lounge channel, veterans wall, vouch-invites, aristocrat sprites.
- Physical lounge corner with props.
- Outcome: full prestige loop. Operator's job-finding play active.

---

## Risks & Mitigations

| Risk | Mitigation |
|---|---|
| Wireless interference at the venue | Channel scan, wired ops path, secondary low-power AP for redundancy |
| A clever participant exploits an app and pivots | Per-container hardening, no shared networks, no host privileges, read-only filesystems, mem/cpu caps |
| Tier-3 answers get shared in `#confessions` | Per-user parameterized binaries; rotate challenges; treat shared answers as a social signal not a security failure |
| Casual users feel locked out | Tier 1 takes <1 minute; standard apps fully usable at tier 1; tier system is a depth dial, not a gate |
| Privacy concerns | Pubkey-only identity; no PII collected; data deleted post-event; this policy stated plainly on the captive portal |
| Operator not present when Jeopardy round triggers | Round can be auto-hosted (script) or skipped without breaking the cadence |
| Anonymous channel attracts harassment | Soft moderation: rate limits, slow mode, per-session muting, channel can be disabled mid-event |
| Conference WiFi being treated as hostile by participants' MDM | Print "this is a research-y conference network — your corp laptop will be unhappy" notice on the portal; offer guest-tier path |

---

## Success Criteria

The event was a success if, by the end:

- A meaningful fraction of attendees reached tier 2.
- A handful reached tier 3 and physically gathered in the lounge corner.
- Multiple matchmaker introductions led to sustained conversation.
- The operator (host) ended the day with a small set of unprompted "let's talk after this" conversations from tier-3 attendees.
- Nobody felt the network was *exclusionary*; everyone with curiosity got somewhere.

---

## Open Questions

- Whether to run the secondary RF wardriving challenge (depends on venue size and channel space).: No Wardriving challenge. 
- Whether physical props (cigars, monocles, top hats) are sourced ahead or brought by attendees.: None.
- Default retention policy for chat logs — recommend zero retention beyond 24 hours post-event, with `#
operator-log` exported for the operator's own records.: Agree.
- Whether to publish source for any of the apps after the event (recommended yes, with the tier-3 challenges held back until they're rotated out).: We should.  
