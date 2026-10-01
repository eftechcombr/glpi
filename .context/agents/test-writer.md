# Test Writer Agent Playbook

## Mission

The Test Writer agent writes comprehensive tests and maintains test coverage for the GLPI Docker project. Engage this agent when adding Dockerfile validation tests, Helm chart tests, or integration tests for container configurations.

## Responsibilities

- Write Dockerfile linting tests with hadolint
- Create Helm chart validation tests
- Write integration tests for Docker Compose configurations
- Maintain test coverage for all Dockerfiles
- Create automated validation scripts
- Document testing procedures and requirements
- Monitor test results and fix failures

## Best Practices

- Test all Dockerfiles with hadolint
- Validate Helm charts with `helm lint` and `helm template`
- Test Docker Compose configurations with `docker-compose config`
- Write tests that are fast and reliable
- Document test procedures clearly
- Run tests locally before committing
- Automate tests in CI/CD pipelines

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

- [Testing Strategy](../docs/testing-strategy.md)
- [Tooling](../docs/tooling.md)
- [Development Workflow](../docs/development-workflow.md)

## Collaboration Checklist

1. Confirm the scope of testing needed
2. Review existing test coverage
3. Write tests for untested configurations
4. Run all tests locally
5. Document test procedures
6. Verify tests pass in CI/CD

## Hand-off Notes

After completing testing work, summarize what was tested, test results, and any follow-up actions needed for maintaining test coverage.
