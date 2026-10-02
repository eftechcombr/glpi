# Project Overview

## Project Overview

This repository contains Docker and Kubernetes configurations for deploying GLPI (an IT asset management and service desk system). It provides containerized images, Docker Compose orchestration, and a Helm chart for production Kubernetes deployments.

## Codebase Reference

> **Detailed Analysis**: For complete symbol counts, architecture layers, and dependency graphs, see [`codebase-map.json`](./codebase-map.json).

## Quick Facts

- Root: `/Users/eduardo/git/github/eftechcombr/glpi`
- Languages: Dockerfile (3 files), YAML (30+ files), Shell (5 files), Markdown (5 files)
- Entry: `docker/docker-compose.yml` (dev), `helm/Chart.yaml` (K8s)
- Full analysis: [`codebase-map.json`](./codebase-map.json)

## Entry Points

- `docker/docker-compose.yml` — Development orchestration
- `docker/docker-compose-build.yml` — Build-from-source orchestration
- `helm/Chart.yaml` — Kubernetes Helm chart
- `docker/php/Dockerfile.base` — PHP-FPM base image
- `docker/php/Dockerfile` — GLPI PHP-FPM application image
- `docker/nginx/Dockerfile` — Nginx reverse proxy image

## Key Exports

- Docker images: `eftechcombr/glpi:base`, `eftechcombr/glpi:php-fpm-{VERSION}`, `eftechcombr/glpi:nginx-{VERSION}`
- Helm chart: `glpi` (appVersion 11.0.11)

## File Structure & Code Organization

- `docker/` — Dockerfiles, compose files, env configs, and PHP scripts
- `docker/php/` — PHP-FPM Dockerfiles and configuration
- `docker/nginx/` — Nginx Dockerfile and configuration
- `helm/` — Helm chart with templates, values, and subcharts
- `helm/templates/` — Kubernetes resource templates
- `helm/charts/` — Subchart dependencies (mariadb, valkey)

## Technology Stack Summary

- **Runtime**: PHP 8.5.11 (FPM), Nginx 1.27.5
- **Database**: MariaDB 11.4 (Docker) / 12.3.2 (Helm)
- **Cache**: Redis 7.0 (Docker) / Valkey 9.1.0 (Helm)
- **Container Orchestration**: Docker Compose, Kubernetes (Helm)
- **Base OS**: Alpine 3.24 (PHP), Alpine 3.21 (Nginx)

## Core Framework Stack

- **GLPI**: PHP-based IT asset management application
- **PHP-FPM**: FastCGI process manager for PHP
- **Nginx**: Reverse proxy and static file server
- **MariaDB**: Relational database for GLPI data
- **Redis/Valkey**: Caching layer for GLPI sessions and data

## Development Tools Overview

- **Hadolint**: Dockerfile linting
- **Docker Compose**: Local development orchestration
- **Helm**: Kubernetes package management
- **DeepSource**: Automated code analysis

## Getting Started Checklist

1. Install Docker 20.10+ and Docker Compose 2.0+
2. Copy `docker/.env.example` to `docker/.env`
3. Run `docker-compose -f docker-compose-build.yml up -d` to build and start
4. Access GLPI at `http://localhost:8080`
5. Review [Development Workflow](./development-workflow.md) for day-to-day tasks

## Next Steps

- See [Architecture](./architecture.md) for system design details
- See [Helm README](./helm/README.md) for Kubernetes deployment
- See [Tooling](./tooling.md) for development tools
