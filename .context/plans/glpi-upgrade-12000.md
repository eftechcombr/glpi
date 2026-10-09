---
status: ready
progress: 100
generated: 2026-10-09
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
lastUpdated: "2026-10-09T12:16:41.031Z"
---

# GLPI Version Upgrade 11.0.11 to 12.0.0 Plan

> Upgrade GLPI from version 11.0.11 to 12.0.0 across all Dockerfiles, Docker Compose files, Helm chart, and documentation.

## Task Snapshot
- **Primary goal:** Update all version references from 11.0.11 to 12.0.0 across the entire repository
- **Success signal:** Zero remaining references to 11.0.11 in production files; hadolint passes on all Dockerfiles; helm lint passes; all documentation updated
- **Key references:**
  - [GLPI 12.0.0 Release](https://github.com/glpi-project/glpi/releases/tag/12.0.0)
  - [Documentation Index](../docs/README.md)
  - [Agent Handbook](../agents/README.md)

## Codebase Context
- **Total files to update:** 13
- **Current version:** 11.0.11
- **Target version:** 12.0.0
- **Release type:** Major release (GLPI 12.0.0)

## Agent Lineup
| Agent | Role in this plan | Playbook | First responsibility focus |
| --- | --- | --- | --- |
| Devops Specialist | Execute version upgrade across all files | [Devops Specialist](../agents/devops-specialist.md) | Update all version references from 11.0.11 to 12.0.0 |
| Code Reviewer | Review all changes for correctness | [Code Reviewer](../agents/code-reviewer.md) | Verify no 11.0.11 references remain; validate hadolint and lint checks |

## Documentation Touchpoints
| Guide | File | Primary Inputs |
| --- | --- | --- |
| Project Overview | [project-overview.md](../docs/project-overview.md) | Version references in stack description |
| Development Workflow | [development-workflow.md](../docs/development-workflow.md) | Release tags and image tags |

## Risk Assessment

### Identified Risks
| Risk | Probability | Impact | Mitigation Strategy | Owner (Agent) |
| --- | --- | --- | --- | --- |
| Missing version references | Low | High | Grep for all 11.0.11 patterns after changes | `devops-specialist` |
| Hadolint failures | Low | Medium | Run hadolint on all Dockerfiles after changes | `devops-specialist` |
| Helm chart version mismatch | Low | Medium | Verify Chart.yaml and values.yaml are in sync | `code-reviewer` |

### Dependencies
- **Internal:** None
- **External:** GLPI 12.0.0 release is available on GitHub
- **Technical:** Docker, hadolint, helm available for validation

### Assumptions
- GLPI 12.0.0 release is available on GitHub (confirmed)
- PHP version (`8.5.11-fpm-alpine3.24`) and Nginx version (`1.31.6-alpine3.24-slim`) are compatible
- Database schema migration is handled via `database:update`

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
| 1.1 | Identify all files with 11.0.11 references | `devops-specialist` | completed | List of 13 files requiring updates |
| 1.2 | Verify GLPI 12.0.0 release availability | `devops-specialist` | completed | Confirmation of release on GitHub |
| 1.3 | Plan execution order (Dockerfiles, compose, helm, docs) | `devops-specialist` | completed | Execution plan |

**Commit Checkpoint**
- No commit needed for planning phase

---

### Phase 2 — Execution
> **Primary Agent:** `devops-specialist` - [Playbook](../agents/devops-specialist.md)

**Objective:** Update all version references from 11.0.11 to 12.0.0 across the repository.

**Tasks**

| # | Task | Agent | Status | Deliverable |
|---|------|-------|--------|-------------|
| 2.1 | Update `docker/php/Dockerfile` (ENV VERSION=12.0.0) | `devops-specialist` | pending | Updated Dockerfile |
| 2.2 | Update `docker/.env` and `docker/.env.example` (VERSION="12.0.0") | `devops-specialist` | pending | Updated env files |
| 2.3 | Update `docker/docker-compose.yml` (image tags) | `devops-specialist` | pending | Updated compose file |
| 2.4 | Update `docker/docker-compose-build.yml` (image tags) | `devops-specialist` | pending | Updated build compose file |
| 2.5 | Update `docker/nginx/Dockerfile` (FROM eftechcombr/glpi:php-fpm-12.0.0) | `devops-specialist` | pending | Updated nginx Dockerfile |
| 2.6 | Update `helm/Chart.yaml` (appVersion: "12.0.0", version bump) | `devops-specialist` | pending | Updated Chart.yaml |
| 2.7 | Update `helm/values.yaml` (version, image tags) | `devops-specialist` | pending | Updated values.yaml |
| 2.8 | Update `README.md` (image tags) | `devops-specialist` | pending | Updated README |
| 2.9 | Update `helm/README.md` (version references) | `devops-specialist` | pending | Updated helm README |
| 2.10 | Update `AGENTS.md` (build commands) | `devops-specialist` | pending | Updated AGENTS.md |
| 2.11 | Update `.context` docs | `devops-specialist` | pending | Updated context docs |
| 2.12 | Run hadolint on all Dockerfiles | `devops-specialist` | pending | Hadolint passes |

**Commit Checkpoint**
- `git commit -m "chore: upgrade GLPI to 12.0.0"`

---

### Phase 3 — Validation
> **Primary Agent:** `code-reviewer` - [Playbook](../agents/code-reviewer.md)

**Objective:** Verify all changes are correct and complete.

**Tasks**

| # | Task | Agent | Status | Deliverable |
|---|------|-------|--------|-------------|
| 3.1 | Grep for remaining 11.0.11 references | `code-reviewer` | pending | Zero remaining references in codebase |
| 3.2 | Verify hadolint passes on all Dockerfiles | `code-reviewer` | pending | Hadolint clean |
| 3.3 | Verify helm lint passes | `code-reviewer` | pending | Helm lint clean |
| 3.4 | Verify docker-compose config parses correctly | `code-reviewer` | pending | Compose config clean |
| 3.5 | Verify all documentation is updated | `code-reviewer` | pending | Documentation complete |

**Commit Checkpoint**
- `git commit -m "chore(validation): verify GLPI 12.0.0 upgrade"`

## Execution History

> Last updated: 2026-10-09T12:16:41.031Z | Progress: 100%

### phase-2 [DONE]
- Started: 2026-10-09T12:16:41.031Z
- Completed: 2026-10-09T12:16:41.031Z

- [x] Step 1: Step 1 *(2026-10-09T12:16:41.031Z)*
  - Output: All configuration files updated from 11.0.11 to 12.0.0
  - Notes: All files updated, hadolint passed, helm lint passed, docker-compose config passed


## Rollback Plan

### Rollback Triggers
- Critical bugs affecting core functionality
- Hadolint or lint failures that cannot be resolved
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
