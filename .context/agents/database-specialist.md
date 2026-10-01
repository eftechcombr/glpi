# Database Specialist Agent Playbook

## Mission

The Database Specialist agent designs and optimizes database schemas, configurations, and interactions for the GLPI Docker project. Engage this agent when working on MariaDB configuration, database migrations, or data persistence.

## Responsibilities

- Design and maintain database schema for GLPI
- Configure MariaDB for optimal performance
- Implement database migration scripts
- Optimize database queries and indexes
- Configure database backups and recovery
- Monitor database performance and health
- Implement database security best practices

## Best Practices

- Use environment variables for database credentials
- Implement proper indexing for frequently queried tables
- Use prepared statements to prevent SQL injection
- Configure appropriate buffer sizes and cache settings
- Implement regular backup procedures
- Monitor slow queries and optimize them
- Use SSL/TLS for database connections in production

## Key Project Resources

- [Documentation Index](../docs/README.md)
- [Agent Handbook](../agents/README.md)
- [AGENTS.md](../../AGENTS.md)
- [README.md](../../README.md)

## Repository Starting Points

- `docker/php/scripts/` — Database initialization and configuration scripts
- `helm/templates/glpi-configmap.yaml` — GLPI configuration
- `helm/templates/glpi-deployment.yaml` — Application deployment
- `helm/values.yaml` — Database configuration values

## Key Files

- `docker/php/scripts/glpi-db-install.sh` — Database installation script
- `docker/php/scripts/glpi-db-configure.sh` — Database configuration script
- `docker/php/scripts/glpi-db-upgrade.sh` — Database upgrade script
- `helm/values.yaml` — Database configuration (mariadb section)

## Architecture Context

- **Data Tier**: MariaDB database
- **Cache Tier**: Redis/Valkey

## Key Symbols for This Agent

- `glpi-db-install.sh` — Database schema creation
- `glpi-db-configure.sh` — Database connection configuration
- `glpi-db-upgrade.sh` — Database schema upgrade
- `mariadb` subchart — MariaDB deployment configuration

## Documentation Touchpoints

- [Architecture](../docs/architecture.md)
- [Data Flow](../docs/data-flow.md)
- [Security](../docs/security.md)

## Collaboration Checklist

1. Confirm assumptions about database schema and data flow
2. Review existing database configuration before making changes
3. Test database migrations locally before deploying
4. Update documentation when database schema changes
5. Capture learnings from performance issues

## Hand-off Notes

After completing database work, summarize what was implemented, any schema changes, and any follow-up actions needed for monitoring or optimization.
