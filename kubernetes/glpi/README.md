# GLPI Helm Chart

[GLPI](https://glpi-project.org/) is an open-source IT Asset Management, Service Desk system, and Issue Tracking System. This Helm chart simplifies the deployment of GLPI on Kubernetes.

## Prerequisites

- Kubernetes 1.21+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installation

```bash
helm repo add eftechcombr https://eftechcombr.github.io/glpi/
helm repo update
helm install my-glpi eftechcombr/glpi
```

## Configuration

The following table lists the configurable parameters of the GLPI chart and their default values. For a complete reference, see `values.yaml`.

### Global Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.namespace` | Namespace for deployment (uses release namespace if empty) | `""` |
| `global.createNamespace` | Create the Namespace resource | `false` |

### GLPI Application

| Parameter | Description | Default |
|-----------|-------------|---------|
| `glpi.version` | GLPI version to deploy | `"11.0.8"` |
| `glpi.language` | Default language for GLPI | `en_US` |

### PHP-FPM Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `glpi.phpfpm.image.repository` | PHP-FPM image repository | `eftechcombr/glpi` |
| `glpi.phpfpm.image.tag` | PHP-FPM image tag | `php-fpm-11.0.8` |
| `glpi.phpfpm.image.pullPolicy` | PHP-FPM image pull policy | `IfNotPresent` |
| `glpi.phpfpm.replicaCount` | Number of PHP-FPM pods | `1` |
| `glpi.phpfpm.resources.limits.cpu` | PHP-FPM container CPU limit | `1000m` |
| `glpi.phpfpm.resources.limits.memory` | PHP-FPM container memory limit | `512Mi` |
| `glpi.phpfpm.resources.requests.cpu` | PHP-FPM container CPU request | `250m` |
| `glpi.phpfpm.resources.requests.memory` | PHP-FPM container memory request | `256Mi` |
| `glpi.phpfpm.livenessProbe.enabled` | Enable PHP-FPM liveness probe | `true` |
| `glpi.phpfpm.readinessProbe.enabled` | Enable PHP-FPM readiness probe | `true` |

### Nginx Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `glpi.nginx.image.repository` | Nginx image repository | `eftechcombr/glpi` |
| `glpi.nginx.image.tag` | Nginx image tag | `nginx-11.0.8` |
| `glpi.nginx.image.pullPolicy` | Nginx image pull policy | `IfNotPresent` |
| `glpi.nginx.replicaCount` | Number of Nginx pods | `1` |
| `glpi.nginx.resources.limits.cpu` | Nginx container CPU limit | `500m` |
| `glpi.nginx.resources.limits.memory` | Nginx container memory limit | `256Mi` |
| `glpi.nginx.resources.requests.cpu` | Nginx container CPU request | `100m` |
| `glpi.nginx.resources.requests.memory` | Nginx container memory request | `128Mi` |
| `glpi.nginx.livenessProbe.enabled` | Enable Nginx liveness probe | `true` |
| `glpi.nginx.readinessProbe.enabled` | Enable Nginx readiness probe | `true` |
| `glpi.nginx.service.type` | Nginx service type | `ClusterIP` |
| `glpi.nginx.service.port` | Nginx service port | `80` |
| `glpi.nginx.service.targetPort` | Nginx container target port | `8080` |

### GLPI Paths

| Parameter | Description | Default |
|-----------|-------------|---------|
| `glpi.paths.marketplace` | Marketplace plugins directory | `/var/www/html/marketplace` |
| `glpi.paths.var` | Variable data directory | `/var/lib/glpi` |
| `glpi.paths.config` | Configuration directory | `/etc/glpi/config` |

### Persistence

| Parameter | Description | Default |
|-----------|-------------|---------|
| `glpi.persistence.files.enabled` | Enable persistence for GLPI files | `true` |
| `glpi.persistence.files.storageClass` | Files volume storage class | `""` |
| `glpi.persistence.files.accessMode` | Files volume access mode | `ReadWriteOnce` |
| `glpi.persistence.files.size` | Files volume size | `10Gi` |
| `glpi.persistence.marketplace.enabled` | Enable persistence for marketplace | `true` |
| `glpi.persistence.marketplace.size` | Marketplace volume size | `2Gi` |
| `glpi.persistence.etc.enabled` | Enable persistence for config | `true` |
| `glpi.persistence.etc.size` | Config volume size | `50Mi` |

### Init Jobs

| Parameter | Description | Default |
|-----------|-------------|---------|
| `glpi.jobs.verifyDir.enabled` | Create required GLPI directories | `true` |
| `glpi.jobs.dbInstall.enabled` | Install GLPI database schema (fresh installs) | `true` |
| `glpi.jobs.dbUpgrade.enabled` | Upgrade GLPI database schema (upgrades) | `true` |
| `glpi.jobs.dbConfigure.enabled` | Configure GLPI database connection | `true` |
| `glpi.jobs.cacheConfigure.enabled` | Configure GLPI Redis cache settings | `true` |

### CronJob

| Parameter | Description | Default |
|-----------|-------------|---------|
| `glpi.cronjob.enabled` | Enable scheduled maintenance cronjob | `true` |
| `glpi.cronjob.schedule` | CronJob schedule (cron format) | `"*/2 * * * *"` |

### GLPI Security Context

| Parameter | Description | Default |
|-----------|-------------|---------|
| `glpi.podSecurityContext.fsGroup` | Pod-level fsGroup (www-data) | `82` |
| `glpi.securityContext.runAsNonRoot` | Run as non-root user | `true` |
| `glpi.securityContext.runAsUser` | User ID (www-data) | `82` |
| `glpi.securityContext.capabilities.drop` | Dropped capabilities | `["ALL"]` |

### MariaDB Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `mariadb.enabled` | Deploy internal MariaDB | `true` |
| `mariadb.image.repository` | MariaDB image repository | `mariadb` |
| `mariadb.image.tag` | MariaDB image tag | `"11.4"` |
| `mariadb.image.pullPolicy` | MariaDB image pull policy | `IfNotPresent` |
| `mariadb.replicaCount` | Number of MariaDB replicas | `1` |
| `mariadb.auth.rootPassword` | MariaDB root password | `glpi` |
| `mariadb.auth.database` | Database name for GLPI | `glpi` |
| `mariadb.auth.username` | Username for GLPI | `glpi` |
| `mariadb.auth.password` | Password for GLPI user | `glpi` |
| `mariadb.primary.resources.limits.cpu` | MariaDB CPU limit | `1000m` |
| `mariadb.primary.resources.limits.memory` | MariaDB memory limit | `2Gi` |
| `mariadb.primary.resources.requests.cpu` | MariaDB CPU request | `250m` |
| `mariadb.primary.resources.requests.memory` | MariaDB memory request | `256Mi` |
| `mariadb.persistence.enabled` | Enable persistence for MariaDB | `true` |
| `mariadb.persistence.size` | MariaDB volume size | `10Gi` |
| `mariadb.service.type` | MariaDB service type | `ClusterIP` |
| `mariadb.service.port` | MariaDB service port | `3306` |
| `mariadb.podSecurityContext.fsGroup` | Pod-level fsGroup | `1001` |
| `mariadb.securityContext.runAsNonRoot` | Run as non-root | `true` |
| `mariadb.securityContext.runAsUser` | User ID | `1001` |

### Redis Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `redis.enabled` | Deploy internal Redis for caching | `true` |
| `redis.image.repository` | Redis image repository | `redis` |
| `redis.image.tag` | Redis image tag | `"7.4-alpine"` |
| `redis.image.pullPolicy` | Redis image pull policy | `IfNotPresent` |
| `redis.replicaCount` | Number of Redis replicas | `1` |
| `redis.resources.limits.cpu` | Redis CPU limit | `500m` |
| `redis.resources.limits.memory` | Redis memory limit | `256Mi` |
| `redis.resources.requests.cpu` | Redis CPU request | `100m` |
| `redis.resources.requests.memory` | Redis memory request | `128Mi` |
| `redis.service.type` | Redis service type | `ClusterIP` |
| `redis.service.port` | Redis service port | `6379` |
| `redis.podSecurityContext.fsGroup` | Pod-level fsGroup | `1001` |
| `redis.securityContext.runAsNonRoot` | Run as non-root | `true` |
| `redis.securityContext.runAsUser` | User ID | `999` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress host rules | `[{host: glpi.example.local, paths: [{path: /, pathType: Prefix}]}]` |
| `ingress.tls` | Ingress TLS configuration | `[]` |

### External Database

| Parameter | Description | Default |
|-----------|-------------|---------|
| `externalDatabase.host` | External database hostname | `""` |
| `externalDatabase.database` | External database name | `""` |
| `externalDatabase.username` | External database username | `""` |
| `externalDatabase.password` | External database password | `""` |

### Service Account

| Parameter | Description | Default |
|-----------|-------------|---------|
| `serviceAccount.create` | Create service account | `true` |
| `serviceAccount.automount` | Automount API credentials | `true` |
| `serviceAccount.name` | Service account name | `""` |

### Other

| Parameter | Description | Default |
|-----------|-------------|---------|
| `imagePullSecrets` | Image pull secrets | `[]` |
| `nameOverride` | Override chart name | `""` |
| `fullnameOverride` | Override full name | `""` |
| `podAnnotations` | Pod annotations | `{}` |
| `podLabels` | Pod labels | `{}` |
| `nodeSelector` | Node selector for pod assignment | `{}` |
| `tolerations` | Pod tolerations | `[]` |
| `affinity` | Pod affinity rules | `{}` |

## Persistence

This chart provides persistence for:
1. **Files**: Main GLPI data (`/var/lib/glpi`)
2. **Marketplace**: Plugin data (`/var/www/html/marketplace`)
3. **Config**: GLPI configuration files (`/etc/glpi/config`)

If using multiple replicas for PHP-FPM, ensure your StorageClass supports `ReadWriteMany` (RWX).

## Database

By default, the chart deploys MariaDB. For production, it is recommended to use an external database by setting `mariadb.enabled: false` and providing connection details via the `externalDatabase` section:

```yaml
mariadb:
  enabled: false

externalDatabase:
  host: my-db-host.example.com
  database: glpi
  username: glpi
  password: mySecurePassword
```

## Initialization Jobs

The chart includes Helm hook jobs that run during install/upgrade:

| Job | Hook | Weight | Description |
|-----|------|--------|-------------|
| `glpi-verify-dir` | post-install, post-upgrade | 5 | Create required GLPI directories |
| `mariadb-timezone` | post-install, post-upgrade | 7 | Populate MariaDB timezone data |
| `glpi-db-install` | post-install | 10 | Install GLPI database schema (fresh installs) |
| `glpi-db-upgrade` | post-upgrade | 10 | Upgrade GLPI database schema (upgrades) |
| `glpi-db-configure` | post-install, post-upgrade | 20 | Configure GLPI database connection |
| `glpi-cache-configure` | post-install, post-upgrade | 30 | Configure GLPI Redis cache settings |

Jobs can be individually disabled via `glpi.jobs.<name>.enabled: false`.

## Security Contexts

All components are configured with secure defaults:
- **GLPI (PHP-FPM/Nginx)**: Runs as non-root user `www-data` (uid 82), drops all capabilities
- **MariaDB**: Runs as non-root user (uid 1001) with `fsGroup: 1001`
- **Redis**: Runs as non-root user (uid 999) with `fsGroup: 1001`

---

---

*Developed by [EFTech](https://eftech.com.br)*
