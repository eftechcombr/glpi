# GLPI Helm Chart

[GLPI](https://glpi-project.org/) is an open-source IT Asset Management, Service Desk system, and Issue Tracking System. This Helm chart simplifies the deployment of GLPI on Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installation

```bash
helm repo add eftechcombr https://eftechcombr.github.io/glpi/
helm repo update
helm install my-glpi eftechcombr/glpi
```

## Configuration

The following table lists the configurable parameters of the GLPI chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `glpi.language` | Default language for GLPI | `en_US` |
| `glpi.phpfpm.image.repository` | PHP-FPM image repository | `eftechcombr/glpi` |
| `glpi.phpfpm.image.tag` | PHP-FPM image tag | `php-fpm-11.0.7` |
| `glpi.phpfpm.replicaCount` | Number of PHP-FPM pods | `1` |
| `glpi.nginx.image.repository` | Nginx image repository | `eftechcombr/glpi` |
| `glpi.nginx.image.tag` | Nginx image tag | `nginx-11.0.7` |
| `glpi.persistence.files.enabled` | Enable persistence for GLPI data | `true` |
| `glpi.persistence.files.size` | Size of data volume | `10Gi` |
| `mariadb.enabled` | Deploy internal MariaDB | `true` |
| `mariadb.auth.rootPassword` | MariaDB root password | `glpi` |
| `redis.enabled` | Deploy internal Redis for caching | `true` |
| `ingress.enabled` | Enable ingress controller | `false` |

## Persistence

This chart provides persistence for:
1. **Files**: Main GLPI data (`/var/lib/glpi`)
2. **Marketplace**: Plugin data (`/var/www/html/marketplace`)
3. **Config**: GLPI configuration files (`/etc/glpi/config`)

If using multiple replicas for PHP-FPM, ensure your StorageClass supports `ReadWriteMany` (RWX).

## Database

By default, the chart deploys MariaDB. For production, it is recommended to use an external database by setting `mariadb.enabled: false` and providing connection details in `glpi.jobs.dbConfigure`.

---
*Developed by [EFTech](https://eftech.com.br)*
