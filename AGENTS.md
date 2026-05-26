# AGENTS.md - Development Guidelines for GLPI Docker

## Overview

This repository contains Docker and Kubernetes configurations for deploying GLPI (an IT asset management system). The project consists of:
- PHP-FPM base image (`docker/php/Dockerfile.base`)
- PHP-FPM application image (`docker/php/Dockerfile`)
- Nginx reverse proxy (`docker/nginx/Dockerfile`)
- Docker Compose configurations for development and production
- Helm chart for Kubernetes deployment (`kubernetes/glpi/`)

## Build Commands

### Build Images Locally

```bash
# Build all images using docker-compose-build.yml
cd docker
docker-compose -f docker-compose-build.yml build

# Build specific image
docker build -t eftechcombr/glpi:base -f docker/php/Dockerfile.base docker/php/
docker build -t eftechcombr/glpi:php-fpm-11.0.7 -f docker/php/Dockerfile docker/php/
docker build -t eftechcombr/glpi:nginx-11.0.7 -f docker/nginx/Dockerfile docker/nginx/
```

### Run Containers

```bash
# Development mode (uses pre-built images)
cd docker
docker-compose up -d

# Build and run (creates images from Dockerfiles)
cd docker
docker-compose -f docker-compose-build.yml up -d
```

### Run Tests / Linting

```bash
# Lint Dockerfile.base with Hadolint
hadolint docker/php/Dockerfile.base

# Lint all Dockerfiles
hadolint docker/php/Dockerfile.base
hadolint docker/php/Dockerfile
hadolint docker/nginx/Dockerfile

# Docker lint via Docker CLI
docker build --check docker/php/
docker build --check docker/nginx/

# Scan for secrets (via hadolint --secret)
hadolint --secret docker/php/Dockerfile.base
```

DeepSource is also configured for automated linting via `.deepsource.toml` (docker, secrets, and shell analyzers).

## Code Style Guidelines

### Dockerfiles

#### General Rules
- Use specific version tags for base images (e.g., `php:8.4.19-fpm-alpine3.22`, not `php:latest`)
- Pin package versions in Alpine (e.g., `icu-dev=76.1-r1`)
- Always clean up build dependencies with `apk del .build-deps`
- Remove `docker-php-source delete` after installing extensions
- Use multi-stage builds when appropriate (see `docker/nginx/Dockerfile`)

#### Image Naming
- Base image: `eftechcombr/glpi:base`
- PHP-FPM: `eftechcombr/glpi:php-fpm-{VERSION}`
- Nginx: `eftechcombr/glpi:nginx-{VERSION}`

#### Package Management
- Keep Alpine packages updated (check for new versions regularly)
- Pin versions using `package=version` syntax in `apk add`
- Group related packages together for readability
- IMPORTANT: Always verify package versions exist in Alpine before pinning

#### PHP Extensions
Install only necessary extensions:
```dockerfile
docker-php-ext-install intl mysqli gd exif bz2 zip ldap opcache bcmath
```

#### Redis Extension
Install via PECL (version pinning recommended for reproducible builds):
```dockerfile
pecl install redis
docker-php-ext-enable redis
```

### Docker Compose

#### Version Tagging
- Always use explicit version tags (e.g., `11.0.7`, not `latest`)
- Keep all service image tags synchronized
- Use semantic versioning

#### Service Dependencies
- Always define `depends_on` with appropriate conditions
- Use `restart: unless-stopped` for persistent services
- Define healthchecks for database services

### Shell Scripts

#### Script Location
- Place scripts in `docker/php/scripts/`
- Name consistently: `glpi-{action}.sh`

#### Script Conventions
```bash
#!/bin/sh
set -e

# Always check required environment variables
if [ -z "$MARIADB_HOST" ]; then
    echo "MARIADB_HOST is required"
    exit 1
fi
```

### YAML Configuration

- Use 2-space indentation
- Put spaces after colons (e.g., `key: value`)
- Use quoted strings for values with special characters
- Comment complex configurations

### Git Workflow

#### Commits
- Use conventional commits format
- Reference issue numbers when applicable

#### Workflow Files
- Place in `.github/workflows/`
- Use reusable workflow patterns
- Include linting before builds

## Error Handling

### Dockerfiles
- Always use `set -e` in RUN commands where appropriate
- Check for required build args
- Clean up temporary files
- Always test build locally before pushing

### Shell Scripts
```bash
set -euo pipefail

# Trap errors
trap 'echo "Error on line $LINENO"' ERR
```

### Docker Compose
- Define `restart: on-failure` for one-time setup tasks
- Log errors clearly to help debugging

## Naming Conventions

### Images
- Lowercase: `eftechcombr/glpi`
- Use kebab-case: `php-fpm`, `nginx`
- Version format: `11.0.7`

### Services (docker-compose)
- Lowercase with hyphens: `mariadb`, `glpi-db-install`
- Descriptive: `glpi-db-configure`, `glpi-cache-configure`, `glpi-verify-dir`, `glpi-db-upgrade`, `mariadb-timezone`

### Environment Variables
- Uppercase with underscores: `MARIADB_HOST`, `GLPI_VERSION`
- Prefix GLPI vars with `GLPI_`: `GLPI_MARKETPLACE_DIR`

## Version Upgrade Checklist

When upgrading GLPI or PHP versions:

1. Update `docker/php/Dockerfile.base`:
   - PHP version (e.g., `8.4.13` → `8.4.19`)
   - Alpine version if needed
   - All pinned package versions (verify they exist in Alpine)

2. Update `docker/php/Dockerfile`:
   - `ENV VERSION=11.0.x`

3. Update `docker/.env`:
   - `VERSION="11.0.x"`

4. Update `docker/.env.example`:
   - `VERSION="11.0.x"`

5. Update `docker/docker-compose.yml`:
   - All image tags

6. Update `docker/docker-compose-build.yml`:
   - All image tags

7. Update `docker/nginx/Dockerfile`:
   - Base image tag

8. Update `kubernetes/glpi/Chart.yaml`:
   - `version:` and `appVersion:` fields

9. Update `kubernetes/glpi/values.yaml`:
   - `glpi.version`, `glpi.phpfpm.image.tag`, `glpi.nginx.image.tag`

10. Verify with hadolint:
   ```bash
   hadolint docker/php/Dockerfile.base
   hadolint docker/php/Dockerfile
   hadolint docker/nginx/Dockerfile
   ```

11. Test build locally:
   ```bash
   cd docker
   docker-compose -f docker-compose-build.yml build base
   ```

## Package Version Reference

Current pinned versions in `Dockerfile.base` (Alpine 3.22):

| Package | Version |
|---------|---------|
| php base | 8.4.19-fpm-alpine3.22 |
| icu-dev | 76.1-r1 |
| zlib-dev | 1.3.2-r0 |
| libpng-dev | 1.6.57-r0 |
| bzip2-dev | 1.0.8-r6 |
| libzip-dev | 1.11.4-r0 |
| openldap-dev | 2.6.8-r0 |
| autoconf | 2.72-r1 |
| dpkg-dev | 1.22.15-r0 |
| dpkg | 1.22.15-r0 |
| file | 5.46-r2 |
| g++ | 14.2.0-r6 |
| gcc | 14.2.0-r6 |
| musl-dev | 1.2.5-r12 |
| make | 4.4.1-r3 |
| pkgconf | 2.4.3-r0 |
| re2c | 4.2-r0 |

## Security Best Practices

- Never commit secrets to repository
- Use `.env` files (already in `.gitignore`)
- Pin base image versions
- Run security scans on Docker images
- Use read-only volumes where possible
- Don't run as root when not necessary

## Dependencies

- **Docker**: 20.10+
- **Docker Compose**: 2.0+
- **Hadolint**: For Dockerfile linting
- **QEMU**: For multi-platform builds (arm64/amd64)
