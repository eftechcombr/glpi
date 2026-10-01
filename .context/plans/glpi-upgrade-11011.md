---
status: ready
generated: 2026-10-01
agents:
  - type: "devops-specialist"
    role: "Execute version upgrade across all configuration files"
  - type: "code-reviewer"
    role: "Review all changes for correctness and completeness"
docs:
  - "project-overview.md"
  - "development-workflow.md"
phases:
  - id: "phase-1"
    name: "Planning"
    prevc: "P"
    agent: "devops-specialist"
  - id: "phase-2"
    name: "Execution"
    prevc: "E"
    agent: "devops-specialist"
  - id: "phase-3"
    name: "Validation"
    prevc: "V"
    agent: "code-reviewer"
---

# GLPI Version Upgrade 11.0.10 to 11.0.11 Plan

> Upgrade GLPI from version 11.0.10 to 11.0.11 across all Dockerfiles, Docker Compose files, Helm chart, and documentation.

## Task Snapshot
- **Primary goal:** Update all version references from 11.0.10 to 11.0.11 across the entire repository
- **Success signal:** Zero remaining references to 11.0.10 in production files; hadolint passes on all Dockerfiles; all documentation updated
- **Key references:**
  - [GLPI 11.0.11 Release](https://github.com/glpi-project/glpi/releases/tag/11.0.11)
  - [Documentation Index](../docs/README.md)
  - [Agent Handbook](../agents/README.md)

## Codebase Context
- **Total files to update:** 12
- **Current version:** 11.0.10
- **Target version:** 11.0.11
- **Release type:** Security release (17 commits since 11.0.10)

## Agent Lineup
| Agent | Role in this plan | Playbook | First responsibility focus |
| --- | --- | --- | --- |
| Devops Specialist | Execute version upgrade across all files | [Devops Specialist](../agents/devops-specialist.md) | Update all version references from 11.0.10 to 11.0.11 |
| Code Reviewer | Review all changes for correctness | [Code Reviewer](../agents/code-reviewer.md) | Verify no 11.0.10 references remain; validate hadolint passes |

## Documentation Touchpoints
| Guide | File | Primary Inputs |
| --- | --- | --- |
| Project Overview | [project-overview.md](../docs/project-overview.md) | Version references in stack description |
| Development Workflow | [development-workflow.md](../docs/development-workflow.md) | Release tags and image tags |

## Risk Assessment

### Identified Risks
| Risk | Probability | Impact | Mitigation Strategy | Owner (Agent) |
| --- | --- | --- | --- | --- |
| Missing version references | Low | High | Grep for all 11.0.10 patterns after changes | `devops-specialist` |
| Hadolint failures | Low | Medium | Run hadolint on all Dockerfiles after changes | `devops-specialist` |
| Helm chart version mismatch | Low | Medium | Verify Chart.yaml and values.yaml are in sync | `code-reviewer` |

### Dependencies
- **Internal:** None
- **External:** GLPI 11.0.11 release is available on GitHub
- **Technical:** Docker and hadolint available for validation

### Assumptions
- GLPI 11.0.11 release is available on GitHub (confirmed)
- No breaking changes in GLPI 11.0.11 that affect Docker configuration
- PHP version (8.4.19) and Alpine version (3.22) remain unchanged

## Resource Estimation

### Time Allocation
| Phase | Estimated Effort | Calendar Time | Team Size |
| --- | --- | --- | --- |
| Phase 1 - Planning | 0.5 hour | 1 hour | 1 person |
| Phase 2 - Execution | 1 hour | 1-2 hours | 1 person |
| Phase 3 - Validation | 0.5 hour | 1 hour | 1 person |
| **Total** | **2 hours** | **3-4 hours** | **-** |

### Required Skills
- Docker and Docker Compose
- Helm chart configuration
- YAML editing
- Hadolint for Dockerfile linting

## Working Phases

### Phase 1 — Planning
> **Primary Agent:** `devops-specialist` - [Playbook](../agents/devops-specialist.md)

**Objective:** Identify all files requiring version updates and plan the execution order.

**Tasks**

| # | Task | Agent | Status | Deliverable |
|---|------|-------|--------|-------------|
| 1.1 | Identify all files with 11.0.10 references | `devops-specialist` | completed | List of 12 files requiring updates |
| 1.2 | Verify GLPI 11.0.11 release availability | `devops-specialist` | completed | Confirmation of release on GitHub |
| 1.3 | Plan execution order (Dockerfiles first, then compose, then helm, then docs) | `devops-specialist` | completed | Execution plan |

**Commit Checkpoint**
- No commit needed for planning phase

---

### Phase 2 — Execution
> **Primary Agent:** `devops-specialist` - [Playbook](../agents/devops-specialist.md)

**Objective:** Update all version references from 11.0.10 to 11.0.11 across the repository.

**Tasks**

| # | Task | Agent | Status | Deliverable |
|---|------|-------|--------|-------------|
| 2.1 | Update `docker/php/Dockerfile` (ENV VERSION=11.0.11) | `devops-specialist` | pending | Updated Dockerfile |
| 2.2 | Update `docker/.env` and `docker/.env.example` (VERSION="11.0.11") | `devops-specialist` | pending | Updated env files |
| 2.3 | Update `docker/docker-compose.yml` (image tags) | `devops-specialist` | pending | Updated compose file |
| 2.4 | Update `docker/docker-compose-build.yml` (image tags) | `devops-specialist` | pending | Updated build compose file |
| 2.5 | Update `docker/nginx/Dockerfile` (FROM eftechcombr/glpi:php-fpm-11.0.11) | `devops-specialist` | pending | Updated nginx Dockerfile |
| 2.6 | Update `helm/Chart.yaml` (appVersion: "11.0.11") | `devops-specialist` | pending | Updated Chart.yaml |
| 2.7 | Update `helm/values.yaml` (version, image tags) | `devops-specialist` | pending | Updated values.yaml |
| 2.8 | Update `index.yaml` (appVersion: 11.0.11 for chart 2.11.6) | `devops-specialist` | pending | Updated index.yaml |
| 2.9 | Update `README.md` (image tags) | `devops-specialist` | pending | Updated README |
| 2.10 | Update `helm/README.md` (version references) | `devops-specialist` | pending | Updated helm README |
| 2.11 | Update `AGENTS.md` (build commands) | `devops-specialist` | pending | Updated AGENTS.md |
| 2.12 | Run hadolint on all Dockerfiles | `devops-specialist` | pending | Hadolint passes |

**Commit Checkpoint**
- `git commit -m "chore: upgrade GLPI from 11.0.10 to 11.0.11"`

---

### Phase 3 — Validation
> **Primary Agent:** `code-reviewer` - [Playbook](../agents/code-reviewer.md)

**Objective:** Verify all changes are correct and complete.

**Tasks**

| # | Task | Agent | Status | Deliverable |
|---|------|-------|--------|-------------|
| 3.1 | Grep for remaining 11.0.10 references | `code-reviewer` | pending | Zero remaining references |
| 3.2 | Verify hadolint passes on all Dockerfiles | `code-reviewer` | pending | Hadolint clean |
| 3.3 | Verify all documentation is updated | `code-reviewer` | pending | Documentation complete |
| 3.4 | Verify Helm chart version consistency | `code-reviewer` | pending | Chart.yaml and values.yaml in sync |

**Commit Checkpoint**
- `git commit -m "chore(validation): verify GLPI 11.0.11 upgrade"`

## Rollback Plan

### Rollback Triggers
- Critical bugs affecting core functionality
- Hadolint failures that cannot be resolved
- Build failures after upgrade

### Rollback Procedures
#### Phase 2 Rollback
- Action: `git revert` the upgrade commit
- Data Impact: None (no production changes)
- Estimated Time: < 1 hour

#### Phase 3 Rollback
- Action: `git revert` both upgrade and validation commits
- Data Impact: None
- Estimated Time: < 1 hour

### Post-Rollback Actions
1. Document reason for rollback
2. Investigate root cause
3. Fix issues and retry upgrade

## Evidence & Follow-up

### Artifacts to Collect
- Grep output showing zero 11.0.10 references
- Hadolint output showing clean passes
- List of all modified files

### Success Metrics
- Zero remaining 11.0.10 references in production files
- Hadolint passes on all 3 Dockerfiles
- All documentation updated to reference 11.0.11
- Helm chart version consistency verified

### Follow-up Actions
| Action | Owner (Agent) | Due |
|--------|---------------|-----|
| Monitor GLPI 11.0.11 for any hotfixes | `devops-specialist` | Ongoing |
| Update AGENTS.md package versions if needed | `devops-specialist` | As needed |
