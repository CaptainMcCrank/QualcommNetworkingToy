# QualcommNetworkingToy

Qualcomm networking toy project

## Project Status

| Phase | Status |
|-------|--------|
| Initialization | Complete |
| PRD | Not Started |
| Tech Stack Evaluation | Not Started |
| Experimentation | Not Started |
| Test Development | Not Started |
| Build Automation (Ansible) | Not Started |
| Testing | Not Started |
| Stable | Not Started |

## Quick Links

- [Product Requirements](docs/prd.md)
- [Project Manifest](project.manifest.yaml)
- [Architectural Decisions](DECISIONS.md)
- [Agent Protocol](docs/agent-protocol.md)

## Repository Structure
```
├── ansible/          # Reproducible build playbooks
│   ├── inventory/    # Host inventory
│   ├── roles/        # Ansible roles
│   └── playbooks/    # Playbook files
├── docs/             # Documentation
│   ├── inputs/       # User-supplied input artifacts
│   └── test_catalog/ # Test specifications
├── src/              # Source code
├── tests/            # Unit, smoke, and integration tests
├── .agent-context/   # Agent reasoning and logs
├── .troubleshooting/ # Diagnostic resources
└── .build-artifacts/ # Build outputs and checksums
```

## For Humans

This project is maintained by a multi-agent AI system with human oversight.

- **Issues labeled `fix-proposed`** are awaiting human verification before closure
- **Issues labeled `needs-human`** require human intervention
- **To provide feedback**, comment on any issue or PR

## For Agents

Read [docs/agent-protocol.md](docs/agent-protocol.md) before performing any work.
