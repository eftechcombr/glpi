[![Helm Chart CI/CD](https://github.com/eftechcombr/glpi/actions/workflows/helm-publish.yaml/badge.svg)](https://github.com/eftechcombr/glpi/actions/workflows/helm-publish.yaml)

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/eftechcombr-glpi)](https://artifacthub.io/packages/search?repo=eftechcombr-glpi)

# GLPI Containers


Manifest files for building and deploying **GLPI** using containers with Docker Compose or Kubernetes.

## Supported Containers

- [x] PHP-FPM: `php:8.4.19-fpm-alpine3.22` -> GLPI PHP: `eftechcombr/glpi:php-fpm-11.0.8`
- [x] Nginx: `nginxinc/nginx-unprivileged:1.27.5-alpine3.21-slim` -> GLPI Nginx: `eftechcombr/glpi:nginx-11.0.8`
  
## Quick Start

### Using Helm (Kubernetes)

#### Adding the Helm Repository

Add the GLPI Helm chart repository:

```sh
helm repo add eftechcombr https://eftechcombr.github.io/glpi/
helm repo update
```


#### Installing the Chart

Install GLPI using Helm:

```sh
helm install my-glpi eftechcombr/glpi
```

Or with custom values:

```sh
helm install my-glpi eftechcombr/glpi -f custom-values.yaml
```

#### Searching for Available Versions

```sh
helm search repo eftechcombr --versions
```

#### Upgrading the Chart

```sh
helm upgrade my-glpi eftechcombr/glpi
```

#### Uninstalling the Chart

```sh
helm uninstall my-glpi
```

### Using Docker Compose

1. Clone this repository
2. Set up environment variables:
```sh
cp docker/.env.example docker/.env
# Edit docker/.env with your desired configuration
```
3. Start the containers:
```sh
cd docker
docker compose up -d
```
GLPI will be accessible at http://localhost:8080

## Credentials

    username: glpi
    password: glpi

## Variables

### docker-compose 

    ./docker/.env.example ---> copy to ./docker/.env and customize

    See ./docker/.env for available environment variables including:
    - MARIADB_HOST, MARIADB_PORT, MARIADB_DATABASE, MARIADB_USER, MARIADB_PASSWORD
    - GLPI_LANG, VERSION, CACHE_DSN
    - GLPI_VAR_DIR, GLPI_CONFIG_DIR, GLPI_MARKETPLACE_DIR and other directory paths


### helm

    See ./helm/values.yaml for all configurable Helm chart parameters,
    including GLPI, MariaDB, Redis, Ingress, and external database settings.
    


## About GLPI

GLPI stands for **Gestionnaire Libre de Parc Informatique** is a Free Asset and IT Management Software package, that provides ITIL Service Desk features, licenses tracking and software auditing.

https://github.com/glpi-project/glpi



## For Support 

https://www.eftech.com.br
    
contato@eftech.com.br


## License

![license](https://img.shields.io/github/license/glpi-project/glpi.svg)

## Help Ukraine

[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://stand-with-ukraine.pp.ua)


