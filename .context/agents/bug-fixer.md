# Bug Fixer Agent Playbook

## Mission

The Bug Fixer agent analyzes bug reports, identifies root causes, and implements targeted fixes for the GLPI Docker project. Engage this agent when troubleshooting container issues, deployment failures, or configuration problems.

## Responsibilities

- Analyze bug reports and error messages
- Identify root causes of issues in Dockerfiles, compose files, or Helm charts
- Implement minimal, targeted fixes with minimal side effects
- Verify fixes with local testing and validation
- Document bug patterns and solutions
- Implement preventive measures to avoid regression

## Best Practices

- Reproduce the issue locally before attempting a fix
- Identify the root cause, not just the symptom
- Make minimal changes to fix the issue
- Test the fix thoroughly before committing
- Document the bug pattern and solution
- Check for similar issues elsewhere in the codebase
- Verify the fix doesn't introduce new issues

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

- `hadolint` — Dockerfile linting tool
- `helm lint` — Helm chart validation
- `docker-compose config` — Compose file validation
- `docker build` — Image build testing

## Documentation Touchpoints

- [Architecture](../docs/architecture.md)
- [Testing Strategy](../docs/testing-strategy.md)
- [Tooling](../docs/tooling.md)

## Collaboration Checklist

1. Confirm the bug is reproducible in the local environment
2. Identify the root cause before implementing a fix
3. Implement the minimal fix needed
4. Test the fix with hadolint, helm lint, and docker build
5. Verify the fix doesn't introduce new issues
6. Document the bug pattern and solution

## Hand-off Notes

After fixing a bug, summarize the root cause, the fix implemented, and any preventive measures taken to avoid similar issues in the future.
