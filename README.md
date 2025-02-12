[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://stand-with-ukraine.pp.ua)

[![PHP](https://github.com/eftechcombr/glpi/actions/workflows/docker-publish-php-fpm.yml/badge.svg?branch=latest)](https://github.com/eftechcombr/glpi/actions/workflows/docker-publish-php-fpm.yml)
[![Nginx](https://github.com/eftechcombr/glpi/actions/workflows/docker-publish-nginx.yml/badge.svg?branch=latest)](https://github.com/eftechcombr/glpi/actions/workflows/docker-publish-nginx.yml)

![GLPI Logo](https://raw.githubusercontent.com/glpi-project/glpi/master/pics/logos/logo-GLPI-250-black.png)

# GLPI Containers


Manifest files for building and deploying **GLPI** using containers with Docker Compose or Kubernetes.

## Supported Containers

- [x] PHP-FPM: `php:8.3.12-fpm-alpine3.20`
- [x] Nginx: `nginx:1.27.2-alpine3.20-slim`
- [x] GLPI PHP: `eftechcombr/glpi:php-fpm-10.0.18`
- [x] GLPI Nginx: `eftechcombr/glpi:nginx-10.0.18`

## Quick Start

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



## For Courses e-Learning

https://www.eftech.com.br


## For Support 

https://www.eftech.com.br
    
contato@eftech.com.br


## License

![license](https://img.shields.io/github/license/glpi-project/glpi.svg)

