# Testing Strategy

## Testing Strategy

Quality is maintained through Dockerfile linting, Helm chart validation, and local build testing. The project uses Hadolint for Dockerfile analysis and Helm's built-in linting for chart validation.

## Test Types

- **Dockerfile Linting**: Hadolint for all Dockerfiles
- **Helm Chart Validation**: `helm lint` and `helm template`
- **Build Testing**: Local Docker image builds
- **Integration Testing**: Full stack deployment with docker-compose

## Running Tests

- Lint all Dockerfiles: `hadolint docker/php/Dockerfile.base && hadolint docker/php/Dockerfile && hadolint docker/nginx/Dockerfile`
- Lint base Dockerfile: `hadolint docker/php/Dockerfile.base`
- Lint PHP Dockerfile: `hadolint docker/php/Dockerfile`
- Lint Nginx Dockerfile: `hadolint docker/nginx/Dockerfile`
- Validate Helm chart: `helm lint helm/`
- Preview Helm template: `helm template helm/`
- Build all images: `docker-compose -f docker-compose-build.yml build`
- Build specific image: `docker build -t eftechcombr/glpi:base -f docker/php/Dockerfile.base docker/php/`

## Quality Gates

- All Dockerfiles must pass hadolint with no errors
- Helm chart must pass `helm lint`
- All image tags must use specific versions
- Alpine packages must be pinned with versions
- Changes must be tested with local build before merging
