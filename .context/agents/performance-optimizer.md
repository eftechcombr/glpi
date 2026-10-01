# Performance Optimizer Agent Playbook

## Mission

The Performance Optimizer agent identifies bottlenecks and optimizes performance for the GLPI Docker project. Engage this agent when experiencing slow builds, slow deployments, or resource utilization issues.

## Responsibilities

- Identify performance bottlenecks in Docker builds
- Optimize Docker image build times
- Optimize container startup times
- Configure resource limits and requests
- Implement caching strategies for builds and runtime
- Monitor and optimize resource utilization
- Implement performance best practices

## Best Practices

- Use multi-stage builds to reduce image size
- Minimize layers in Dockerfiles
- Use `.dockerignore` to reduce build context
- Leverage Docker layer caching
- Configure appropriate resource limits
- Use Alpine-based images for smaller size
- Optimize Nginx and PHP-FPM configurations
- Implement proper caching headers

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
- `helm/values.yaml` — Resource limits and requests

## Architecture Context

- **Web Tier**: Nginx reverse proxy (`docker/nginx/`)
- **Application Tier**: PHP-FPM with GLPI (`docker/php/`)
- **Data Tier**: MariaDB database
- **Cache Tier**: Redis/Valkey

## Key Symbols for This Agent

- `docker build` — Image build optimization
- `apk add --no-cache` — Package installation optimization
- `docker-php-ext-install` — PHP extension optimization
- `resources` — Kubernetes resource limits

## Documentation Touchpoints

- [Architecture](../docs/architecture.md)
- [Tooling](../docs/tooling.md)
- [Testing Strategy](../docs/testing-strategy.md)

## Collaboration Checklist

1. Confirm performance issues and bottlenecks
2. Measure current performance metrics
3. Identify optimization opportunities
4. Implement optimizations
5. Measure performance after optimization
6. Document performance improvements

## Hand-off Notes

After completing performance optimization, summarize what was optimized, performance metrics before and after, and any follow-up actions needed for continued monitoring.
