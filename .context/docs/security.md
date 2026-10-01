# Security & Compliance Notes

## Security & Compliance Notes

Security is a core concern for this project. All containers run as non-root users, images use specific version tags, and secrets are managed through environment variables and Kubernetes Secrets.

## Authentication & Authorization

- **GLPI**: Built-in user authentication with role-based access control
- **MariaDB**: Username/password authentication
- **Redis/Valkey**: No authentication (internal network only)
- **Kubernetes**: Service accounts with RBAC

## Secrets & Sensitive Data

- **Environment variables**: Stored in `.env` files (git-ignored)
- **Kubernetes Secrets**: Used for database credentials in production
- **Helm Secrets**: Support for external secret management (Doppler, Vault, etc.)
- **Image tags**: Specific versions only (no `latest`)

## Compliance & Policies

- **Non-root containers**: All containers run as non-root users
- **Read-only root filesystem**: Supported in Helm chart
- **Capability dropping**: All capabilities dropped in Kubernetes
- **Network policies**: Internal service communication only

## Incident Response

- **Monitoring**: Health checks and probes in Kubernetes
- **Backups**: Automated CronJob-based backups to S3
- **Logging**: Container logs accessible via `kubectl logs`
- **Escalation**: Defined in GLPI ticketing system
