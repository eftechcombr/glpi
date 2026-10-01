# Development Workflow

## Development Workflow

Day-to-day engineering follows a container-focused workflow. Changes are made to Dockerfiles, compose files, or Helm templates, then validated with linting and local builds before committing.

## Branching & Releases

- **Main branch**: Production-ready code
- **Feature branches**: `feature/description` for new features
- **Bug fix branches**: `fix/description` for bug fixes
- **Release tags**: Semantic versioning (e.g., `v11.0.11`)
- **Image tags**: Follow GLPI version (e.g., `php-fpm-11.0.11`)

## Local Development

- Build images: `docker-compose -f docker-compose-build.yml build`
- Run stack: `docker-compose up -d`
- Run tests: `hadolint docker/php/Dockerfile.base && hadolint docker/php/Dockerfile && hadolint docker/nginx/Dockerfile`
- Lint Dockerfiles: `hadolint docker/php/Dockerfile.base`
- Validate Helm: `helm lint helm/`
- Preview Helm: `helm template helm/`

## Code Review Expectations

- All Dockerfiles must pass hadolint
- Image tags must use specific versions (no `latest`)
- Alpine packages must be pinned with versions
- Helm chart must pass `helm lint`
- Changes must be tested with local build before merging

## Onboarding Tasks

1. Review [Project Overview](../docs/project-overview.md)
2. Build all images locally
3. Run the full stack with docker-compose
4. Explore the Helm chart templates
5. Review [Tooling](../docs/tooling.md) for development tools
