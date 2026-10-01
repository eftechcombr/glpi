# Feature Developer Agent Playbook

## Mission

The Feature Developer agent implements new features according to specifications for the GLPI Docker project. Engage this agent when adding new functionality to Dockerfiles, Docker Compose configurations, or Helm charts.

## Responsibilities

- Implement new features in Dockerfiles and compose files
- Add new Helm chart templates and values
- Write shell scripts for container initialization
- Implement new service integrations
- Add configuration options to Helm values
- Test features with local builds and deployments
- Document new features and configuration options

## Best Practices

- Follow existing code patterns and conventions
- Use environment variables for configuration
- Implement features with security in mind
- Test features locally before committing
- Document all new configuration options
- Use specific version tags for images
- Pin package versions in Dockerfiles
- Clean up build dependencies

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

- `docker-php-ext-install` — PHP extension installation
- `pecl install` — PECL package installation
- `apk add` — Alpine package installation
- `helm template` — Helm template rendering

## Documentation Touchpoints

- [Architecture](../docs/architecture.md)
- [Development Workflow](../docs/development-workflow.md)
- [Tooling](../docs/tooling.md)

## Collaboration Checklist

1. Confirm feature requirements and specifications
2. Review existing code patterns before implementing
3. Implement the feature following project conventions
4. Test the feature with local builds
5. Update documentation with new configuration options
6. Capture learnings from implementation

## Hand-off Notes

After completing feature development, summarize what was implemented, any new configuration options added, and any follow-up actions needed for testing or documentation.
