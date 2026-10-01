# Refactoring Specialist Agent Playbook

## Mission

The Refactoring Specialist agent identifies code smells and improves code structure for the GLPI Docker project. Engage this agent when improving Dockerfile readability, simplifying Helm chart templates, or restructuring Docker Compose configurations.

## Responsibilities

- Identify code smells in Dockerfiles and compose files
- Simplify and optimize Dockerfile instructions
- Restructure Docker Compose configurations for clarity
- Improve Helm chart template organization
- Reduce duplication in configuration files
- Improve naming conventions and consistency
- Preserve functionality while improving structure

## Best Practices

- Make incremental, small changes
- Preserve existing functionality
- Test thoroughly after each refactoring
- Document the rationale for structural changes
- Follow established patterns and conventions
- Ensure refactoring improves maintainability
- Verify all tests pass after refactoring

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
- `helm/values.yaml` — Helm chart configuration values

## Architecture Context

- **Web Tier**: Nginx reverse proxy (`docker/nginx/`)
- **Application Tier**: PHP-FPM with GLPI (`docker/php/`)
- **Data Tier**: MariaDB database
- **Cache Tier**: Redis/Valkey

## Key Symbols for This Agent

- `hadolint` — Dockerfile linting
- `helm lint` — Helm chart validation
- `docker-compose config` — Compose file validation

## Documentation Touchpoints

- [Architecture](../docs/architecture.md)
- [Development Workflow](../docs/development-workflow.md)
- [Testing Strategy](../docs/testing-strategy.md)

## Collaboration Checklist

1. Confirm the scope of refactoring needed
2. Review existing code structure
3. Identify code smells and improvement opportunities
4. Make incremental changes
5. Test thoroughly after each change
6. Document the rationale for structural changes

## Hand-off Notes

After completing refactoring, summarize what was refactored, the rationale for changes, and any follow-up actions needed for verification.
