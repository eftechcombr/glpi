# Backend Specialist Agent Playbook

## Mission

The Backend Specialist agent designs and implements server-side architecture, APIs, and database interactions for the GLPI Docker project. Engage this agent when working on PHP-FPM configuration, database schemas, or backend service integration.

## Responsibilities

- Design and maintain PHP-FPM configuration for GLPI
- Optimize database queries and schema design
- Implement backend service integrations
- Configure database connections and pooling
- Design caching strategies for backend data
- Implement data validation and sanitization
- Monitor backend performance and optimize bottlenecks

## Best Practices

- Use environment variables for configuration (no hardcoded values)
- Implement proper error handling and logging
- Use prepared statements for database queries
- Cache frequently accessed data in Redis/Valkey
- Follow GLPI's coding standards and conventions
- Test database migrations before deploying
- Monitor slow queries and optimize indexes

## Key Project Resources

- [Documentation Index](../docs/README.md)
- [Agent Handbook](../agents/README.md)
- [AGENTS.md](../../AGENTS.md)
- [README.md](../../README.md)

## Repository Starting Points

- `docker/php/` — PHP-FPM Dockerfiles and configuration
- `docker/php/scripts/` — PHP scripts for GLPI initialization
- `helm/templates/glpi-configmap.yaml` — GLPI configuration
- `helm/templates/glpi-deployment.yaml` — Application deployment

## Key Files

- `docker/php/Dockerfile.base` — PHP-FPM base image with extensions
- `docker/php/Dockerfile` — GLPI PHP-FPM application image
- `docker/php/scripts/glpi-db-install.sh` — Database installation script
- `docker/php/scripts/glpi-db-configure.sh` — Database configuration script
- `docker/php/scripts/glpi-cache-configure.sh` — Cache configuration script

## Architecture Context

- **Application Tier**: PHP-FPM with GLPI (`docker/php/`)
- **Data Tier**: MariaDB database
- **Cache Tier**: Redis/Valkey

## Key Symbols for This Agent

- `docker-php-ext-install` — PHP extension installation
- `pecl install redis` — Redis extension installation
- `glpi-db-install.sh` — Database schema creation
- `glpi-db-configure.sh` — Database connection configuration
- `glpi-cache-configure.sh` — Cache configuration

## Documentation Touchpoints

- [Architecture](../docs/architecture.md)
- [Data Flow](../docs/data-flow.md)
- [Glossary](../docs/glossary.md)

## Collaboration Checklist

1. Confirm assumptions about database schema and data flow
2. Review existing backend code before making changes
3. Test database migrations locally before deploying
4. Update documentation when backend interfaces change
5. Capture learnings from performance issues

## Hand-off Notes

After completing backend work, summarize what was implemented, any database changes, and any follow-up actions needed for monitoring or optimization.
