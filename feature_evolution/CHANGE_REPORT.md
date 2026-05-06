# Change Report: <Feature> Evolution

**Date:** <ISO 8601>
**Agent:** feature-evolution-agent-v1.0
**Evolution Type:** Enhancement / Refactor / Integration / Migration

---

## Situation

**Context:** <What triggered this evolution - the problem or opportunity>

**Requirements Source:** <path to requirements document or "inline">

---

### Environment Preparation

**PXE Targets Prepared:**

| Device | Model | Reset Time | Deploy Time | Baseline Tests |
|--------|-------|------------|-------------|----------------|
| pxe-01 | Pi 5 | <timestamp> | <duration> | PASS |
| pxe-02 | Pi 4 | <timestamp> | <duration> | PASS |

**Baseline Playbook:** <git SHA at deployment>
**Baseline Captured:** <ISO 8601>

---

**Primary Target:** <hostname used for evolution work>
**Secondary Targets:** <other devices used for verification>

**Pre-Evolution State:**
- <Key aspect of system before changes>
- <Another key aspect>
- <Configuration state>

**Historical Context:**
- <Relevant lessons learned applied>
- <Previous evolution history if applicable>

---

## Task

**Objective:** <Clear statement of what needed to change>

**Requirements Addressed:**

| ID | Requirement | Priority |
|----|-------------|----------|
| REQ-001 | <description> | Must Have |
| REQ-002 | <description> | Should Have |

**Acceptance Criteria:**
- [ ] <criterion 1 - measurable>
- [ ] <criterion 2 - measurable>
- [ ] <criterion 3 - measurable>

**Scope Boundaries:**
- In scope: <what was included>
- Out of scope: <what was explicitly excluded>

---

## Action

**Approach:** <High-level description of the approach taken>

### Phase A: <Name> (e.g., "Configuration Updates")

**Duration:** <time spent>

**What was done:**
- <Action 1>
- <Action 2>

**Key decision:** <Decision made and rationale>

### Phase B: <Name> (e.g., "Service Modifications")

**Duration:** <time spent>

**What was done:**
- <Action 1>
- <Action 2>

**Key decision:** <Decision made and rationale>

### Key Decisions Summary

| # | Decision | Rationale | Alternatives Considered |
|---|----------|-----------|-------------------------|
| 1 | <decision> | <why> | <other options> |
| 2 | <decision> | <why> | <other options> |

### Challenges Overcome

1. **<Challenge 1>:**
   - Problem: <what went wrong>
   - Resolution: <how it was fixed>
   - Time spent: <duration>

2. **<Challenge 2>:**
   - Problem: <what went wrong>
   - Resolution: <how it was fixed>

### Failed Approaches

| Approach | Why It Failed | Lesson Learned |
|----------|---------------|----------------|
| <approach 1> | <reason> | <insight> |

---

## Result

**Outcome:** Success / Partial Success / Requires Follow-up

### Requirements Status

| ID | Status | Verification Method |
|----|--------|---------------------|
| REQ-001 | Complete | <how verified> |
| REQ-002 | Complete | <how verified> |

### Changes Made

| File | Change | Lines Changed |
|------|--------|---------------|
| <path> | <description> | +X / -Y |

### Test Results

**Baseline (before):**
- Total: X tests
- Passed: X
- Failed: 0

**Final (after):**
- Total: Y tests (X existing + Z new)
- Passed: Y
- Failed: 0
- Regressions: None

### Performance Impact

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| <metric> | <value> | <value> | <delta> |

---

## Artifacts

### Evolution Archive

**Location:** `.FeatureEvolution/<date>_<feature>/`

**Contents:**
- `requirements_analysis.md` - Parsed requirements and gap analysis
- `current_state_discovery.md` - SSH discovery results
- `impact_assessment.md` - Regression risk analysis
- `evolution_plan.md` - Approved modification strategy
- `experiment_log.md` - Incremental change log
- `working_solution.md` - Final validated approach
- `before_state/` - Pre-modification snapshots
- `after_state/` - Post-modification snapshots

### Playbook Changes

| File | Change Type |
|------|-------------|
| `roles/feature_<name>/tasks/main.yml` | Modified |
| `roles/feature_<name>/defaults/main.yml` | Modified |
| `roles/feature_<name>/tests/smoke_test.yml` | Modified |

### Knowledge Base Updates

- Lessons Learned: <path or "None">
- Context Acquisition: <path or "None">

---

## Migration Guide

**For devices already running this feature:**

### Method: <In-place upgrade / Manual steps required>

**Steps:**
1. <step 1>
2. <step 2>
3. <step 3>

**Expected downtime:** <duration>

**Verification:**
```bash
<verification commands>
```

**Rollback if needed:**
```bash
<rollback commands>
```

---

## Lessons Learned

1. **<Insight 1>:** <What was learned>
2. **<Insight 2>:** <What was learned>

**Recommendations for future evolutions:**
- <recommendation 1>
- <recommendation 2>

---

## Sign-off

| Aspect | Status |
|--------|--------|
| Requirements addressed | Complete |
| Tests passing | Yes |
| Regressions | None |
| Documentation | Complete |
| Playbooks synchronized | Yes |
| Migration guide | Created |

**Evolution completed by:** feature-evolution-agent-v1.0
**Validation device:** <hostname>
**Total duration:** <time from start to finish>

---

*Generated by feature-evolution-agent-v1.0*
