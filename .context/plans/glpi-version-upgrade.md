---
status: ready
generated: 2026-10-01
agents:
  - type: "devops-specialist"
    role: "Update Dockerfiles and Docker Compose configurations"
  - type: "architect-specialist"
    role: "Review architecture consistency across all configs"
  - type: "code-reviewer"
    role: "Review all changes for quality and best practices"
  - type: "test-writer"
    role: "Validate Dockerfiles with hadolint and Helm chart with helm lint"
  - type: "documentation-writer"
    role: "Update all documentation references"
docs:
  - "project-overview.md"
  - "architecture.md"
  - "development-workflow.md"
  - "testing-strategy.md"
phases:
  - id: "phase-1"
    name: "Planning & Discovery"
    prevc: "P"
    agent: "architect-specialist"
  - id: "phase-2"
    name: "Implementation"
    prevc: "E"
    agent: "devops-specialist"
  - id: "phase-3"
    name: "Review & Validation"
    prevc: "R"
    agent: "code-reviewer"
  - id: "phase-4"
    name: "Verification"
    prevc: "V"
    agent: "test-writer"
---

# GLPI Version Upgrade 11.0.9 to 11.0.10 Plan

> Upgrade GLPI from version 11.0.9 to 11.0.10 across all Dockerfiles, Docker Compose files, Helm chart, and documentation.

## Task Snapshot
- **Primary goal:** Update all version references from 11.0.9 to 11.0.10 across the entire repository
- **Success signal:** All Dockerfiles pass hadolint, Helm chart passes lint, zero remaining references to 11.0.9
- **Key references:**
  - [Documentation Index](../docs/README.md)
  - [Agent Handbook](../agents/README.md)
  - [Plans Index](./README.md)

## Codebase Context
- **Total files analyzed:** 46
- **Total symbols discovered:** Docker images, Helm charts, Docker Compose services

## Agent Lineup
| Agent | Role in this plan | Playbook | First responsibility focus |
| --- | --- | --- | --- |
| Architect Specialist | Review architecture consistency | [Architect Specialist](../agents/architect-specialist.md) | Verify version consistency across all configs |
| Devops Specialist | Update Dockerfiles and compose files | [Devops Specialist](../agents/devops-specialist.md) | Update all version references |
| Code Reviewer | Review all changes | [Code Reviewer](../agents/code-reviewer.md) | Ensure quality and best practices |
| Test Writer | Validate with hadolint and helm lint | [Test Writer](../agents/test-writer.md) | Run all validation checks |
| Documentation Writer | Update documentation | [Documentation Writer](../agents/documentation-writer.md) | Update all doc references |

## Documentation Touchpoints
| Guide | File | Primary Inputs |
| --- | --- | --- |
| Project Overview | [project-overview.md](../docs/project-overview.md) | Version references |
| Architecture Notes | [architecture.md](../docs/architecture.md) | Image tags |
| Development Workflow | [development-workflow.md](../docs/development-workflow.md) | Build commands |
| Testing Strategy | [testing-strategy.md](../docs/testing-strategy.md) | Validation commands |

## Risk Assessment

### Identified Risks
| Risk | Probability | Impact | Mitigation Strategy | Owner (Agent) |
| --- | --- | --- | --- | --- |
| Missed version reference | Low | Medium | Grep for all 11.0.9 references after changes | `test-writer` |
| Hadolint failure | Low | Medium | Run hadolint on all Dockerfiles before committing | `test-writer` |
| Helm lint failure | Low | Medium | Run helm lint after chart changes | `test-writer` |

### Dependencies
- **Internal:** None
- **External:** GLPI 11.0.10 release must be available on GitHub
- **Technical:** Docker and Helm must be installed for testing

### Assumptions
- GLPI 11.0.10 release is available on GitHub
- PHP version (8.4.19) and Alpine version (3.22) remain unchanged
- No breaking changes in GLPI 11.0.10 that affect Docker configuration

## Resource Estimation

### Time Allocation
| Phase | Estimated Effort | Calendar Time | Team Size |
| --- | --- | --- | --- |
| Phase 1 - Planning | 0.5 person-days | 1 day | 1 person |
| Phase 2 - Implementation | 0.5 person-days | 1 day | 1 person |
| Phase 3 - Review | 0.25 person-days | 0.5 day | 1 person |
| Phase 4 - Verification | 0.25 person-days | 0.5 day | 1 person |
| **Total** | **1.5 person-days** | **3 days** | **1 person** |

### Required Skills
- Dockerfile knowledge
- Docker Compose knowledge
- Helm chart knowledge
- Hadolint and helm lint tools

## Working Phases

### Phase 1 — Planning & Discovery
> **Primary Agent:** `architect-specialist` - [Playbook](../agents/architect-specialist.md)

**Objective:** Identify all files that need version updates and plan the changes

**Tasks**

| # | Task | Agent | Status | Deliverable |
|---|------|-------|--------|-------------|
| 1.1 | Identify all files with version references | `architect-specialist` | completed | List of files to update |
| 1.2 | Verify GLPI 11.0.10 release availability | `architect-specialist` | completed | Confirmation of release |
| 1.3 | Document upgrade scope | `architect-specialist` | completed | This plan |

**Commit Checkpoint**
- After completing this phase, capture the agreed context and create a commit (for example, `git commit -m "chore(plan): complete phase 1 discovery"`).

---

### Phase 2 — Implementation
> **Primary Agent:** `devops-specialist` - [Playbook](../agents/devops-specialist.md)

**Objective:** Update all version references from 11.0.9 to 11.0.10

**Tasks**

| # | Task | Agent | Status | Deliverable |
|---|------|-------|--------|-------------|
| 2.1 | Update docker/php/Dockerfile (ENV VERSION) | `devops-specialist` | completed | Updated Dockerfile |
| 2.2 | Update docker/.env and docker/.env.example | `devops-specialist` | completed | Updated env files |
| 2.3 | Update docker/docker-compose.yml image tags | `devops-specialist` | completed | Updated compose file |
| 2.4 | Update docker/docker-compose-build.yml image tags | `devops-specialist` | completed | Updated build compose file |
| 2.5 | Update docker/nginx/Dockerfile base image tag | `devops-specialist` | completed | Updated nginx Dockerfile |
| 2.6 | Update helm/Chart.yaml appVersion | `devops-specialist` | completed | Updated Chart.yaml |
| 2.7 | Update helm/values.yaml version and image tags | `devops-specialist` | completed | Updated values.yaml |
| 2.8 | Update documentation files (README, AGENTS.md, etc.) | `devops-specialist` | completed | Updated documentation |

**Commit Checkpoint**
- Summarize progress, update cross-links, and create a commit documenting the outcomes of this phase (for example, `git commit -m "chore(plan): complete phase 2 implementation"`).

---

### Phase 3 — Review & Validation
> **Primary Agent:** `code-reviewer` - [Playbook](../agents/code-reviewer.md)

**Objective:** Review all changes for quality, consistency, and best practices

**Tasks**

| # | Task | Agent | Status | Deliverable |
|---|------|-------|--------|-------------|
| 3.1 | Review all Dockerfiles for best practices | `code-reviewer` | completed | Review feedback |
| 3.2 | Verify no remaining 11.0.9 references | `code-reviewer` | completed | Verification report |
| 3.3 | Check Helm chart consistency | `code-reviewer` | completed | Consistency report |

**Commit Checkpoint**
- Record the review evidence and create a commit signalling the review completion (for example, `git commit -m "chore(plan): complete phase 3 review"`).

---

### Phase 4 — Verification
> **Primary Agent:** `test-writer` - [Playbook](../agents/test-writer.md)

**Objective:** Run all validation checks to ensure quality

**Tasks**

| # | Task | Agent | Status | Deliverable |
|---|------|-------|--------|-------------|
| 4.1 | Run hadolint on all Dockerfiles | `test-writer` | completed | Hadolint passes |
| 4.2 | Run helm lint on chart | `test-writer` | completed | Helm lint passes |
| 4.3 | Verify zero remaining 11.0.9 references | `test-writer` | completed | Grep verification |
| 4.4 | Test local Docker build | `test-writer` | pending | Build verification |

**Commit Checkpoint**
- Record the validation evidence and create a commit signalling the handoff completion (for example, `git commit -m "chore(plan): complete phase 4 verification"`).

## Rollback Plan

### Rollback Triggers
- Critical bugs affecting core functionality
- Hadolint or helm lint failures
- Build failures

### Rollback Procedures
#### Phase 1 Rollback
- Action: Discard plan, restore previous documentation state
- Data Impact: None (no production changes)
- Estimated Time: < 1 hour

#### Phase 2 Rollback
- Action: Revert commits, restore previous version references
- Data Impact: None (version bump only)
- Estimated Time: < 1 hour

#### Phase 3 Rollback
- Action: Revert all changes, restore previous state
- Data Impact: None
- Estimated Time: < 1 hour

### Post-Rollback Actions
1. Document reason for rollback
2. Notify stakeholders
3. Schedule post-mortem
4. Update plan with lessons learned

## Evidence & Follow-up

### Artifacts to Collect
- Hadolint output
- Helm lint output
- Grep verification results
- Build test results

### Success Metrics
- Zero remaining references to 11.0.9
- All Dockerfiles pass hadolint
- Helm chart passes helm lint
- All documentation updated

### Follow-up Actions
| Action | Owner (Agent) | Due |
|--------|---------------|-----|
| Monitor GLPI 11.0.10 release notes | `devops-specialist` | Post-upgrade |
| Update AGENTS.md package versions if needed | `documentation-writer` | Post-upgrade |
