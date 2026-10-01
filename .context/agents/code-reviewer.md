# Code Reviewer Agent Playbook

## Mission

The Code Reviewer agent reviews code changes for quality, style, security, and adherence to project conventions. Engage this agent when reviewing pull requests, Dockerfiles, Helm charts, or any infrastructure changes.

## Responsibilities

- Review Dockerfiles for best practices and security
- Validate Helm chart changes for correctness and consistency
- Check Docker Compose configurations for proper service dependencies
- Verify image tags use specific versions (no `latest`)
- Ensure Alpine packages are pinned with versions
- Check for security issues in container configurations
- Verify documentation is updated with changes

## Best Practices

- Check all Dockerfiles pass hadolint
- Verify Helm chart passes `helm lint`
- Ensure image tags are specific and consistent
- Verify Alpine packages are pinned with versions
- Check for hardcoded secrets or credentials
- Verify proper cleanup of build dependencies
- Ensure containers run as non-root users
- Check for proper health checks and restart policies

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

## Key Files

- `docker/php/Dockerfile.base` — PHP-FPM base image
- `docker/php/Dockerfile` — GLPI PHP-FPM application image
- `docker/nginx/Dockerfile` — Nginx reverse proxy image
- `docker/docker-compose.yml` — Development orchestration
- `helm/Chart.yaml` — Helm chart metadata
- `helm/values.yaml` — Helm chart configuration values

## Architecture Context

- **Web Tier**: Nginx reverse proxy (`docker/nginx/`)
- **Application Tier**: PHP-FPM with GLPI (`docker/php/`)
- **Data Tier**: MariaDB database
- **Cache Tier**: Redis/Valkey

## Key Symbols for This Agent

- `hadolint` — Dockerfile linting tool
- `helm lint` — Helm chart validation
- `helm template` — Helm template rendering
- `docker-compose config` — Compose file validation

## Documentation Touchpoints

- [Architecture](../docs/architecture.md)
- [Security](../docs/security.md)
- [Testing Strategy](../docs/testing-strategy.md)

## Collaboration Checklist

1. Confirm the scope of changes being reviewed
2. Run hadolint on all changed Dockerfiles
3. Run helm lint on chart changes
4. Verify image tags are specific and consistent
5. Check for security issues and best practices
6. Verify documentation is updated
7. Provide clear, actionable feedback

## Hand-off Notes

After completing a review, summarize the findings, any issues found, and recommendations for improvement.
