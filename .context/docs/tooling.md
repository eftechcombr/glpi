# Tooling & Productivity Guide

## Tooling & Productivity Guide

This section covers the tools and automation used in this project.

## Required Tooling

- **Docker 20.10+**: Container runtime
- **Docker Compose 2.0+**: Multi-container orchestration
- **Hadolint**: Dockerfile linting
- **Helm 3+**: Kubernetes package management
- **QEMU**: Multi-platform builds (arm64/amd64)

## Recommended Automation

- **Hadolint**: Run on all Dockerfiles before committing
- **Helm lint**: Run on chart changes before committing
- **Docker build**: Test image builds locally before pushing
- **Pre-commit hooks**: Run hadolint and helm lint automatically

## IDE / Editor Setup

- **VS Code**: Docker and YAML extensions
- **Hadolint integration**: Real-time Dockerfile linting
- **Helm plugin**: Chart templating and validation

## Productivity Tips

- Use `docker-compose -f docker-compose-build.yml build base` to rebuild only the base image
- Use `helm template helm/` to preview Kubernetes manifests
- Use `hadolint --secret docker/php/Dockerfile.base` to scan for secrets
- Use `docker build --check docker/php/` to validate Dockerfile syntax
