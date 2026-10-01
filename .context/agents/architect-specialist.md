# Architect Specialist Agent Playbook

## Mission

The Architect Specialist agent designs the overall system architecture, patterns, and technical standards for the GLPI Docker project. Engage this agent when making decisions about container topology, service boundaries, deployment patterns, or infrastructure design.

## Responsibilities

- Design container architecture and service boundaries
- Define deployment patterns for Docker Compose and Kubernetes
- Establish technical standards for Dockerfiles and Helm charts
- Evaluate and recommend base images and dependencies
- Design scaling and high-availability strategies
- Document architectural decisions and trade-offs
- Review architectural changes for consistency and maintainability

## Best Practices

- Separate concerns into distinct containers (web, app, data, cache)
- Use sidecar pattern for one-time initialization tasks
- Design for horizontal scaling where possible
- Use persistent volumes for stateful data
- Implement health checks and graceful degradation
- Document all architectural decisions with rationale
- Follow the principle of least privilege for container permissions

## Key Project Resources

- [Documentation Index](../docs/README.md)
- [Agent Handbook](../agents/README.md)
- [AGENTS.md](../../AGENTS.md)
- [README.md](../../README.md)

## Repository Starting Points

- `docker/` — Dockerfiles, compose files, env configs, and PHP scripts
- `docker/php/` — PHP-FPM Dockerfiles and configuration
- `docker/nginx/` — Nginx Dockerfile and configuration
- `helm/` — Helm chart with templates, values, and subcharts
- `helm/templates/` — Kubernetes resource templates

## Key Files

- `docker/docker-compose.yml` — Development orchestration
- `docker/docker-compose-build.yml` — Build-from-source orchestration
- `helm/Chart.yaml` — Helm chart metadata
- `helm/values.yaml` — Helm chart configuration values
- `helm/templates/glpi-deployment.yaml` — Main application deployment
- `helm/templates/glpi-job.yaml` — Initialization jobs

## Architecture Context

- **Web Tier**: Nginx reverse proxy (`docker/nginx/`)
- **Application Tier**: PHP-FPM with GLPI (`docker/php/`)
- **Data Tier**: MariaDB database
- **Cache Tier**: Redis/Valkey
- **Orchestration**: Docker Compose (dev) / Helm+Kubernetes (prod)

## Key Symbols for This Agent

- `eftechcombr/glpi:base` — Base PHP-FPM image
- `eftechcombr/glpi:php-fpm-{VERSION}` — GLPI PHP-FPM image
- `eftechcombr/glpi:nginx-{VERSION}` — Nginx reverse proxy image
- `glpi` Helm Chart — Kubernetes deployment package

## Documentation Touchpoints

- [Architecture](../docs/architecture.md)
- [Data Flow](../docs/data-flow.md)
- [Project Overview](../docs/project-overview.md)

## Collaboration Checklist

1. Confirm assumptions about scalability and availability requirements
2. Review existing architecture before proposing changes
3. Document all architectural decisions with rationale
4. Ensure changes align with established patterns
5. Update architecture documentation when changes are made
6. Capture learnings from architectural reviews

## Hand-off Notes

After completing architectural work, summarize the design decisions made, alternatives considered, and any follow-up actions needed for implementation or documentation.
