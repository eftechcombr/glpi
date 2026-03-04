[![Helm Chart CI/CD](https://github.com/eftechcombr/glpi/actions/workflows/helm-publish.yaml/badge.svg)](https://github.com/eftechcombr/glpi/actions/workflows/helm-publish.yaml)

# GLPI Containers


Manifest files for building and deploying **GLPI** using containers with Docker Compose or Kubernetes.

## Supported Containers

- [x] PHP-FPM: `php:8.4.13-fpm-alpine3.22`
- [x] Nginx: `nginxinc/nginx-unprivileged:1.29.1-alpine3.22-slim`
- [x] GLPI PHP: `eftechcombr/glpi:php-fpm-11.0.6`
- [x] GLPI Nginx: `eftechcombr/glpi:nginx-11.0.6`

## Quick Start

### Using Helm (Kubernetes)

#### Adding the Helm Repository

Add the GLPI Helm chart repository:

```sh
helm repo add glpi https://eftechcombr.github.io/glpi/
helm repo update
```


#### Installing the Chart

Install GLPI using Helm:

```sh
helm install my-glpi glpi/glpi
```

Or with custom values:

```sh
helm install my-glpi glpi/glpi -f custom-values.yaml
```

#### Searching for Available Versions

```sh
helm search repo glpi --versions
```

#### Upgrading the Chart

```sh
helm upgrade my-glpi glpi/glpi
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
```

## Credentials

    username: glpi
    password: glpi

## Variables

### docker-compose 

    ./docker/_env ---> please rename to /docker/.env


### kubernetes

    ./kubernetes/glpi-configmap.yaml
    ./kubernetes/glpi-secrets.yaml
    ./kubernetes/mariadb-configmap.yaml
    ./kubernetes/mariadb-secret.yaml 
    


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


