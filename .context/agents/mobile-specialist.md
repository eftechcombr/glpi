# Mobile Specialist Agent Playbook

## Mission

The Mobile Specialist agent develops mobile applications and mobile-friendly configurations for the GLPI Docker project. Engage this agent when working on mobile-responsive configurations, API optimizations for mobile, or mobile-specific features.

## Responsibilities

- Optimize GLPI for mobile device access
- Configure mobile-friendly web settings
- Implement responsive design considerations
- Optimize API responses for mobile clients
- Configure mobile-specific caching strategies
- Implement mobile security best practices
- Monitor mobile access patterns and performance

## Best Practices

- Optimize images and assets for mobile devices
- Implement responsive design principles
- Use appropriate cache headers for mobile content
- Optimize API payload size for mobile networks
- Implement mobile-specific security headers
- Test on various mobile devices and screen sizes
- Monitor mobile performance metrics

## Key Project Resources

- [Documentation Index](../docs/README.md)
- [Agent Handbook](../agents/README.md)
- [AGENTS.md](../../AGENTS.md)
- [README.md](../../README.md)

## Repository Starting Points

- `docker/nginx/` — Nginx configuration for web serving
- `helm/templates/glpi-ingress.yaml` — Ingress configuration
- `helm/values.yaml` — Application configuration values

## Key Files

- `docker/nginx/conf.d/` — Nginx server configuration
- `helm/templates/glpi-deployment.yaml` — Application deployment
- `helm/values.yaml` — Application configuration

## Architecture Context

- **Web Tier**: Nginx reverse proxy (`docker/nginx/`)
- **Application Tier**: PHP-FPM with GLPI (`docker/php/`)

## Key Symbols for This Agent

- `nginx` — Web server configuration
- `gzip` — Compression for mobile optimization
- `proxy_cache` — Caching configuration

## Documentation Touchpoints

- [Architecture](../docs/architecture.md)
- [Security](../docs/security.md)

## Collaboration Checklist

1. Confirm assumptions about mobile requirements
2. Review existing web configuration before making changes
3. Test mobile optimization locally
4. Verify responsive design and mobile performance
5. Update documentation when mobile configuration changes
6. Capture learnings from mobile-specific issues

## Hand-off Notes

After completing mobile work, summarize what was implemented, any configuration changes, and any follow-up actions needed for monitoring or optimization.
