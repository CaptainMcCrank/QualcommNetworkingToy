# AI Agent Operating Protocol

This document defines the standard operating procedures that ALL agents in the multi-agent reproducible build system must follow. Individual agent prompts extend this protocol with role-specific responsibilities.

---

## Core Principles

1. **Git is the source of truth** - All work, decisions, and state changes are committed
2. **Human-verified closure** - Agents propose fixes; humans verify and close issues
3. **Institutional memory** - All troubleshooting creates searchable documentation
4. **Explicit handoffs** - Phase transitions are signaled through manifest updates

---

## 1. Project Manifest Integration

### Reading the Manifest

At the start of every task, read `project.manifest.yaml` to understand:

```yaml
# Key sections to check
identity:
  uuid: <project identifier>
  name: <project name>

status:
  current_phase: <which phase is active>
  health: <healthy | degraded | failed>

self_correction:
  max_attempts: <maximum fix attempts before escalation>
  cooldown_seconds: <wait time between attempts>
```

### Updating the Manifest

Update relevant sections when:
- Starting work on a phase (set `phases.<phase>.started_at`)
- Completing a phase (set `phases.<phase>.completed_at`, `completed_by`)
- Changing project health status
- Adding version pinning information
- Recording your agent in the `agents` list

**Example update when starting work:**
```yaml
agents:
  - id: "<your-agent-id>"
    role: <your-role>
    first_contribution: "<ISO 8601 timestamp>"
    last_contribution: "<ISO 8601 timestamp>"

phases:
  <current_phase>:
    started_at: "<ISO 8601 timestamp>"
```

---

## 2. Ownership Tracking

### Claiming Artifacts

When you create or significantly modify an artifact, update `.agent-ownership.yaml`:

```yaml
artifacts:
  <path/to/artifact>:
    owner: "<your-agent-id>"
    last_modified: "<ISO 8601 timestamp>"
    commit: "<commit SHA>"
```

### Checking Ownership

Before modifying an artifact owned by another agent:
1. Check if the owner agent should be notified
2. Document why you're modifying another agent's artifact
3. Update ownership if you're taking responsibility

---

## 3. Git Conventions

### Commit Message Format

All commits must follow this structure:

```
[<agent-id>] <brief description>

<detailed explanation if needed>

Agent-ID: <your-agent-id>
Parent-Artifact: <artifact that triggered this work, if any>
Confidence: <0.0-1.0>
References: <issue numbers, PRD sections, or other references>
```

**Example:**
```
[test-agent-v1.0] Add smoke tests for WiFi AP functionality

Creates comprehensive validation script for hostapd, dnsmasq,
and captive portal components.

Agent-ID: test-agent-v1.0
Parent-Artifact: roles/wifi_ap/tasks/main.yml
Confidence: 0.92
References: PRD-section-3.2, #47
```

### Branch Strategy

- Work on the default branch unless instructed otherwise
- Tag phase completions: `<phase>-complete-v<version>`
- Never force push to main/master

---

## 4. GitHub Issue Lifecycle

### When to File Issues

File a GitHub issue when:
- A test fails that you cannot immediately fix
- You encounter an error during deployment
- You discover a defect in another agent's artifact
- You need human input on a decision

### Issue Format

```markdown
## Summary
<Brief description of the problem>

## Error Context
- **Agent:** <your-agent-id>
- **Phase:** <current phase>
- **Artifact:** <file or component affected>
- **Error Signature:** <unique identifier for this error type>

## Reproduction Steps
1. <step 1>
2. <step 2>

## Diagnostic Information
<relevant logs, command outputs>

## Attempted Fixes
- <what you tried and why it didn't work>

## Proposed Solution
<if you have one>
```

### Issue Labels

Apply appropriate labels:
- `agent-filed` - Issue created by an agent
- `<agent-id>` - Which agent filed it
- `phase-<name>` - Which phase
- `fix-proposed` - When you believe you've fixed it
- `needs-human` - Requires human intervention
- `regression` - Previously fixed issue has returned

### Self-Correction Loop

When a test fails:

1. **Attempt fix** (up to `self_correction.max_attempts` from manifest)
2. **Wait** `self_correction.cooldown_seconds` between attempts
3. **Document** each attempt in the issue
4. **If fixed:** Apply `fix-proposed` label, do NOT close
5. **If max attempts reached:** Apply `needs-human` label, stop attempting

```
CRITICAL: Agents NEVER close their own issues.
Humans verify fixes and close issues.
```

### Regression Handling

If an error signature matches a previously closed issue:

1. **Reopen** the original issue (do not create a new one)
2. **Apply** the `regression` label
3. **Document** what changed since the original fix
4. **Reference** the original fix commit

---

## 5. Reasoning Documentation

### Location

Each agent maintains reasoning documentation in:
```
.agent-context/<agent-id>-reasoning.md
```

### Content Structure

```markdown
# <Agent Name> Reasoning Log

## <ISO 8601 timestamp> - <Decision Title>

**Context:** <What situation prompted this decision?>

**Options considered:**
1. **Option A**: <description>
   - Pros: <benefits>
   - Cons: <drawbacks>

2. **Option B**: <description>
   - Pros: <benefits>
   - Cons: <drawbacks>

**Decision:** Option <X>

**Rationale:** <Why this option was chosen>

**Confidence:** <0.0-1.0>

**Assumptions:**
- <assumption 1>
- <assumption 2>

**Revisit if:**
- <condition that would invalidate this decision>
```

---

## 6. Troubleshooting Knowledge Base

### Lessons Learned

When you successfully resolve a non-trivial issue, create:
```
.AgentLessonsLearned/YYYY-MM-DD_<descriptive-name>.md
```

**Only create after:**
- Successfully diagnosing root cause
- Implementing a verified solution
- Confirming fix with tests

### Context Acquisition

When you discover valuable system information, create:
```
.ContextAcquisition/<category>/<descriptive-name>.<ext>
```

Categories:
- `system_profiles/` - Hardware/OS facts (JSON)
- `critical_discoveries/` - Important findings (Markdown)
- `environment_maps/` - Topology/dependency graphs (YAML/DOT)
- `quick_context.yaml` - Latest aggregate summary

### Consulting Knowledge Base

Before troubleshooting:
1. Search `.AgentLessonsLearned/` for similar errors
2. Load `.ContextAcquisition/quick_context.yaml` for system facts
3. Check if error signature matches any closed issues
4. Apply relevant lessons to accelerate diagnosis

---

## 7. Phase Transitions

### Signaling Completion

When your phase is complete:

1. **Update manifest:**
```yaml
status:
  current_phase: "<next_phase>"

phases:
  <your_phase>:
    completed_at: "<ISO 8601 timestamp>"
    completed_by: "<your-agent-id>"
  <next_phase>:
    started_at: "<ISO 8601 timestamp>"
```

2. **Commit with tag:**
```bash
git add project.manifest.yaml
git commit -m "[<agent-id>] Complete <phase>, handoff to <next-agent>

Phase <phase> complete. Ready for <next_phase>.

Agent-ID: <your-agent-id>
Confidence: <score>"

git tag "<phase>-complete-v1.0"
git push origin <branch> --tags
```

3. **Verify handoff artifacts exist:**
- All outputs documented in your agent prompt
- Ownership recorded in `.agent-ownership.yaml`
- No unresolved issues blocking next phase

### Receiving Handoff

When starting your phase:

1. Verify predecessor phase is marked complete in manifest
2. Check for any open issues from predecessor
3. Read predecessor's reasoning documentation
4. Validate expected input artifacts exist

---

## 8. Input/Output Contracts

### Inputs

Each agent must document:
- What artifacts it expects
- Which predecessor agent creates them
- How to validate inputs are present and correct

### Outputs

Each agent must document:
- What artifacts it creates
- Which successor agent consumes them
- Acceptance criteria for outputs

### Validation

Before starting work:
```yaml
# Pseudo-code for input validation
for each expected_input:
  if not exists(expected_input):
    file_issue("Missing input: {expected_input}")
    halt()
  if not valid(expected_input):
    file_issue("Invalid input: {expected_input} - {validation_error}")
    halt()
```

---

## 9. Secrets Management

### Never Commit Secrets

The following must NEVER be committed:
- Passwords
- API keys
- Private keys
- Tokens
- Credentials files

### Referencing Secrets

Use environment variables or vault references:
```yaml
# Good
password: "{{ lookup('env', 'DB_PASSWORD') }}"
api_key: "{{ vault_api_key }}"

# Bad
password: "actual_password_here"
```

### If Secrets Are Discovered

If you encounter committed secrets:
1. File an issue immediately with `security` label
2. Do not propagate the secret further
3. Recommend rotation of the exposed credential

---

## 10. Error Handling

### Classification

Classify errors to accelerate diagnosis:

| Category | Indicators | First Check |
|----------|------------|-------------|
| Network | "Connection refused", "timed out" | `ping`, connectivity |
| Permission | "Permission denied" | `sudo`, file ownership |
| Dependency | "ModuleNotFoundError" | package versions |
| Resource | "No space left" | `df -h`, `free -h` |
| Configuration | "Syntax error" | `--syntax-check` |
| State | "Already exists" | previous deployments |

### Escalation Path

1. **Self-diagnosis** - Use error classification
2. **Knowledge base** - Check lessons learned
3. **Self-correction** - Attempt fixes (up to max_attempts)
4. **Issue filing** - Document for human review
5. **Escalation labels** - Apply `needs-human` if blocked

---

## 11. Agent Identity

### Agent ID Format

```
<role>-agent-v<major>.<minor>
```

Examples:
Shared (both flows):
- `initialization-agent-v1.0`
- `prd-agent-v1.0`
- `techstack-agent-v1.0`
- `validation-agent-v1.0`

IoT flow:
- `experiment-agent-v1.0`
- `test-agent-v1.0`
- `ansible-agent-v1.0`

WebApp / service flow:
- `webdev-experiment-agent-v1.0`
- `webdev-review-agent-v1.0`
- `webdev-test-agent-v1.0`
- `webdev-build-agent-v1.0`

### Tracking in Manifest

Register yourself in `project.manifest.yaml` on first contribution:
```yaml
agents:
  - id: "<your-agent-id>"
    role: <role>
    first_contribution: "<ISO 8601 timestamp>"
    last_contribution: "<ISO 8601 timestamp>"
```

Update `last_contribution` on each commit.

---

## 12. Pipeline Awareness

### Agent Sequence

```
┌──────────────────────────────────────────────────────────────────────┐
│ GREENFIELD PIPELINE (Agents 00-06)                                   │
│                                                                      │
│ Routes based on identity.project_type in project.manifest.yaml       │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ Initialization Agent (00) ─── shared ───────────────────────────     │
│         ↓                                                            │
│ PRD Agent (01) ──────────── shared ───────────────────────────       │
│         ↓                                                            │
│ TechStack Agent (02) ────── shared ───────────────────────────       │
│         ↓                                                            │
│    ┌────┴────┐                                                       │
│    │ Route on│                                                       │
│    │ project │                                                       │
│    │  _type  │                                                       │
│    └─┬────┬──┘                                                       │
│      │    │                                                          │
│  [iot]  [webapp]                                                     │
│      │    │                                                          │
│      │    │                                                          │
│  ┌───┴──────────────┐  ┌───┴──────────────────┐                     │
│  │   IoT FLOW       │  │   WebDev FLOW         │                    │
│  ├──────────────────┤  ├──────────────────────┤                     │
│  │ Experiment (03)  │  │ WebDev Experiment(03)│                     │
│  │       ↓          │  │       ↓              │                     │
│  │ Test (04)        │  │ WebDev Review (03B)  │                     │
│  │       ↓          │  │       ↓              │                     │
│  │ Ansible (05)     │  │ WebDev Test (04)     │                     │
│  │       ↓          │  │       ↓              │                     │
│  │ Validation (06)  │  │ WebDev Build (05)    │                     │
│  └──────────────────┘  │       ↓              │                     │
│                        │ WebDev Validation(06)│                     │
│                        └──────────────────────┘                     │
│         ↓                       ↓                                    │
│ [DEPLOYED SYSTEM]     [DEPLOYED WEB APP]                             │
└──────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────┐
│ POST-DEPLOYMENT & MAINTENANCE                                        │
├──────────────────────────────────────────────────────────────────────┤
│ Deployment & Troubleshooting Agent (06B)                             │
│   └── Post-deployment diagnostics, rollback, recovery                │
│                                                                      │
│ Issue Watcher Agent (07)                                             │
│   └── Monitors GitHub issues, triages, recommends action             │
│                                                                      │
│ Brownfield Adoption Agent (08)                                       │
│   └── Adopts existing projects into pipeline (one-time)              │
│                                                                      │
│ Feature Development Agent (09)                                       │
│   └── Issue-driven features and bug fixes                            │
│                                                                      │
│ Feature Evolution Agent (10)                                         │
│   └── Requirements-driven feature evolution                          │
└──────────────────────────────────────────────────────────────────────┘
```

### Flow Routing

The pipeline forks after Agent 02 (TechStack) based on `identity.project_type` in `project.manifest.yaml`:

| `project_type` | Agent 03 | Agent 03B | Agent 04 | Agent 05 | Agent 06 |
|-----------------|----------|-----------|----------|----------|----------|
| `iot` | `03_Experiment_Agent.md` | N/A | `04_Test_Agent.md` | `05_Ansible_Agent.md` | `06_Validation_Agent.md` |
| `webapp` | `03_WebDev_Experiment_Agent.md` | `03B_WebDev_Review_Agent.md` | `04_WebDev_Test_Agent.md` | `05_WebDev_Build_Agent.md` | `06_WebDev_Validation_Agent.md` |

**IoT flow phases:** `experimentation` → `test_development` → `build_automation` → `validation`.

**WebDev flow phases:** `experimentation` → `design_review` → `test_development` → `build_automation` → `validation`.

### Agent Selection Guide

| Situation | Agent |
|-----------|-------|
| New project from idea | Start with Agent 00 (Initialization) |
| Existing project needs pipeline | Agent 08 (Brownfield Adoption) |
| GitHub issue needs fixing | Agent 09 (Feature Development) |
| Requirements document for evolution | Agent 10 (Feature Evolution) |
| Deployed system needs troubleshooting | Agent 06B (Deployment & Troubleshooting) |
| Want to monitor issues automatically | Agent 07 (Issue Watcher) |

### Cross-Agent Communication

Agents communicate through:
1. **Git commits** - Permanent record of changes
2. **Manifest updates** - Phase status and metadata
3. **Ownership file** - Artifact responsibility
4. **GitHub issues** - Problems and discussions
5. **Knowledge base** - Lessons and context

Direct agent-to-agent communication does not exist. All state is persisted in the repository.

---

## Quick Reference Checklist

Before starting work:
- [ ] Read `project.manifest.yaml`
- [ ] Verify predecessor phase is complete
- [ ] Check for blocking issues
- [ ] Load relevant context from knowledge base
- [ ] Validate expected inputs exist

During work:
- [ ] Update ownership for artifacts you create/modify
- [ ] Document reasoning for significant decisions
- [ ] Commit frequently with proper format
- [ ] File issues for problems you cannot resolve

After completing work:
- [ ] Update manifest with phase completion
- [ ] Tag the completion commit
- [ ] Verify all outputs exist
- [ ] Ensure no unresolved blocking issues
- [ ] Push changes and tags
