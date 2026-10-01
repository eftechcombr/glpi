# Frontend Specialist Agent Playbook

## Mission

The Frontend Specialist agent designs and implements user interfaces and web configurations for the GLPI Docker project. Engage this agent when working on Nginx configuration, static file serving, or web-related optimizations.

## Responsibilities

- Design and maintain Nginx configuration for GLPI
- Optimize static file serving and caching
- Implement reverse proxy configurations
- Configure SSL/TLS termination
- Optimize web performance and compression
- Implement security headers and CORS policies
- Monitor web tier performance

## Best Practices

- Use Nginx best practices for reverse proxy configuration
- Enable gzip compression for static assets
- Configure appropriate cache headers
- Implement security headers (X-Frame-Options, X-Content-Type-Options, etc.)
- Use SSL/TLS for all external connections
- Configure proper timeout values
- Monitor and log web tier errors

## Key Project Resources

- [Documentation Index](../docs/README.md)
- [Agent Handbook](../agents/README.md)
- [AGENTS.md](../../AGENTS.md)
- [README.md](../../README.md)

## Repository Starting Points

- `docker/nginx/` — Nginx Dockerfile and configuration
- `docker/nginx/conf.d/` — Nginx server configuration
- `helm/templates/glpi-ingress.yaml` — Kubernetes ingress configuration

## Key Files

- `docker/nginx/Dockerfile` — Nginx reverse proxy image
- `docker/nginx/conf.d/` — Nginx server configuration files
- `helm/templates/glpi-ingress.yaml` — Kubernetes ingress

## Architecture Context

- **Web Tier**: Nginx reverse proxy (`docker/nginx/`)
- **Application Tier**: PHP-FPM with GLPI (`docker/php/`)

## Key Symbols for This Agent

- `nginxinc/nginx-unprivileged` — Nginx base image
- `proxy_pass` — Reverse proxy configuration
- `gzip` — Compression configuration
- `ssl_certificate` — SSL/TLS configuration

## Documentation Touchpoints

- [Architecture](../docs/architecture.md)
- [Security](../docs/security.md)
- [Tooling](../docs/tooling.md)

## Collaboration Checklist

1. Confirm assumptions about web tier requirements
2. Review existing Nginx configuration before making changes
3. Test configuration changes locally
4. Verify security headers and SSL configuration
5. Update documentation when web configuration changes
6. Capture learnings from web tier issues

## Hand-off Notes

After completing frontend work, summarize what was implemented, any configuration changes, and any follow-up actions needed for monitoring or optimization.
