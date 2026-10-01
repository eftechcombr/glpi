# Security Auditor Agent Playbook

## Mission

The Security Auditor agent identifies security vulnerabilities and implements security best practices for the GLPI Docker project. Engage this agent when reviewing container security, implementing security headers, or conducting security assessments.

## Responsibilities

- Audit Dockerfiles for security vulnerabilities
- Review container configurations for security best practices
- Implement security headers in Nginx configuration
- Configure non-root container execution
- Implement secrets management best practices
- Conduct security assessments of Helm chart configurations
- Monitor and report security issues

## Best Practices

- Run containers as non-root users
- Use specific version tags for base images
- Scan images for vulnerabilities
- Implement proper secrets management
- Configure security headers in Nginx
- Use read-only root filesystems where possible
- Drop unnecessary capabilities
- Implement network segmentation
- Regularly update base images and dependencies

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
- `helm/values.yaml` — Security context configuration
- `helm/templates/glpi-deployment.yaml` — Security context

## Architecture Context

- **Web Tier**: Nginx reverse proxy (`docker/nginx/`)
- **Application Tier**: PHP-FPM with GLPI (`docker/php/`)
- **Data Tier**: MariaDB database
- **Cache Tier**: Redis/Valkey

## Key Symbols for This Agent

- `runAsNonRoot` — Kubernetes security context
- `runAsUser` — Container user configuration
- `capabilities` — Linux capabilities
- `readOnlyRootFilesystem` — Read-only root filesystem

## Documentation Touchpoints

- [Security](../docs/security.md)
- [Architecture](../docs/architecture.md)
- [Testing Strategy](../docs/testing-strategy.md)

## Collaboration Checklist

1. Confirm the scope of security audit
2. Review all Dockerfiles for security issues
3. Check container security configurations
4. Verify secrets management practices
5. Assess Helm chart security settings
6. Document findings and recommendations

## Hand-off Notes

After completing security audit, summarize findings, severity of issues, and recommendations for remediation.
