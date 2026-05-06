# Diagnostic Playbook

This document provides step-by-step procedures for diagnosing common issues in this project.

## General Diagnostic Steps

### 1. Check Project Health

1. Read `project.manifest.yaml` and check `status.health`
2. Review open issues in the GitHub repository
3. Check the most recent CI/CD run status

### 2. Identify the Failing Component

1. Run the full test suite: `<command TBD>`
2. Note which tests fail
3. Map failing tests to their owning agent via `.agent-ownership.yaml`

### 3. Review Recent Changes

1. Check git log for recent commits
2. Identify commits since last successful build (`status.last_successful_build`)
3. Review reasoning files in `.agent-context/` for those commits

### 4. Consult Known Patterns

1. Check `.troubleshooting/common-failures.yaml` for matching error signatures
2. Search closed issues for similar problems
3. Review related issues linked in any matching patterns

---

## Component-Specific Diagnostics

### Ansible Playbook Issues

*To be populated by Ansible agent*

### Test Failures

*To be populated by Test agent*

### PXE Environment Issues

*To be populated by Experiment agent*

---

## Escalation Procedures

If self-correction fails after maximum attempts:

1. Ensure all diagnostic information is captured in the GitHub issue
2. Apply escalation labels as configured in manifest
3. Notify humans listed in `issue_lifecycle.notify_on_proposed`
4. Do not continue attempting fixes until human input is received
