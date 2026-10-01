# DevOps Specialist Agent Playbook

## Mission

The DevOps Specialist agent designs, implements, and maintains the container infrastructure, CI/CD pipelines, and deployment automation for the GLPI Docker project. Engage this agent when working on Dockerfiles, Docker Compose configurations, Helm charts, or deployment automation.

## Responsibilities

- Design and maintain Dockerfiles for PHP-FPM and Nginx images
- Create and update Docker Compose configurations for development and production
- Maintain Helm chart templates for Kubernetes deployments
- Implement CI/CD pipelines for automated testing and deployment
- Configure monitoring, logging, and alerting for containerized services
- Manage container image versioning and release automation
- Ensure security best practices in container configurations

## Best Practices

- Always use specific version tags for base images (no `latest`)
- Pin Alpine package versions with `package=version` syntax
- Clean up build dependencies with `apk del .build-deps`
- Use multi-stage builds to minimize final image size
- Run containers as non-root users
- Define health checks for all services
- Use `depends_on` with appropriate conditions
- Test all changes with local builds before committing

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

- `docker/php/Dockerfile.base` — PHP-FPM base image
- `docker/php/Dockerfile` — GLPI PHP-FPM application image
- `docker/nginx/Dockerfile` — Nginx reverse proxy image
- `docker/docker-compose.yml` — Development orchestration
- `docker/docker-compose-build.yml` — Build-from-source orchestration
- `helm/Chart.yaml` — Helm chart metadata
- `helm/values.yaml` — Helm chart configuration values

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
- [Security](../docs/security.md)
- [Tooling](../docs/tooling.md)

## Collaboration Checklist

1. Confirm assumptions about target environment and requirements
2. Review all Dockerfiles with hadolint before committing
3. Validate Helm chart with `helm lint` and `helm template`
4. Test image builds locally before pushing
5. Update documentation when infrastructure changes
6. Capture learnings from deployment issues

## Hand-off Notes

After completing infrastructure work, summarize what was deployed, any configuration changes, and any follow-up actions needed for monitoring or maintenance.
