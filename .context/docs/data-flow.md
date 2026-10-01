# Data Flow & Integrations

## Data Flow & Integrations

Data flows through the system in a layered architecture. HTTP requests enter through Nginx, are processed by PHP-FPM/GLPI, and persist to MariaDB. Redis/Valkey provides caching for sessions and frequently accessed data.

## Module Dependencies

- **nginx** → `php-fpm` (reverse proxy)
- **php-fpm** → `mariadb`, `redis/valkey` (database and cache)
- **mariadb-timezone** → `mariadb` (initialization)
- **glpi-db-install** → `mariadb` (schema creation)
- **glpi-db-configure** → `mariadb` (connection config)
- **glpi-cache-configure** → `redis/valkey` (cache config)

## Service Layer

- **GLPI Application**: PHP-FPM serving GLPI (`docker/php/`)
- **Nginx**: Reverse proxy (`docker/nginx/`)
- **MariaDB**: Database (`mariadb:11.4` / `mariadb:12.3.2`)
- **Redis/Valkey**: Cache (`redis:7.0-alpine` / `valkey/valkey:9.1.0`)

## High-level Flow

1. Client sends HTTP request to Nginx
2. Nginx serves static files directly or proxies to PHP-FPM
3. PHP-FPM executes GLPI application code
4. GLPI reads/writes data to MariaDB
5. GLPI uses Redis/Valkey for caching and sessions
6. Response returns through Nginx to client

## Internal Movement

- **Initialization**: One-time jobs (`glpi-db-install`, `glpi-verify-dir`, `glpi-db-configure`, `glpi-cache-configure`) run before the main application starts
- **Database**: GLPI stores all persistent data in MariaDB
- **Cache**: Sessions and frequently accessed data stored in Redis/Valkey
- **Files**: Uploads, documents, and marketplace plugins stored on persistent volumes

## External Integrations

- **GLPI Releases**: Downloaded from GitHub releases during image build
- **Docker Hub**: Base images pulled from Docker Hub
- **Helm Repository**: Subcharts pulled from `repo.helmforge.dev`

## Observability & Failure Modes

- **Health checks**: Kubernetes liveness and readiness probes
- **Container restart**: `restart: unless-stopped` for persistent services
- **Init job failure**: `restart: on-failure` for one-time setup tasks
- **Database backup**: CronJob-based backup to S3-compatible storage
