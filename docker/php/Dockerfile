FROM php:8.3.12-fpm-alpine3.20

ENV VERSION=10.0.18 
ENV GLPI_LANG=en_US 
ENV MARIADB_HOST=mariadb-glpi 
ENV MARIADB_PORT=3306 
ENV MARIADB_DATABASE=glpi 
ENV MARIADB_USER=glpi 
ENV MARIADB_PASSWORD=glpi 
ENV GLPI_CONFIG_DIR=/etc/glpi/config 
ENV GLPI_VAR_DIR=/var/lib/glpi 
ENV GLPI_MARKETPLACE_DIR=${GLPI_VAR_DIR}/_marketplace 
ENV GLPI_DOC_DIR=${GLPI_VAR_DIR} 
ENV GLPI_CRON_DIR=${GLPI_VAR_DIR}/_cron 
ENV GLPI_DUMP_DIR=${GLPI_VAR_DIR}/_dumps 
ENV GLPI_GRAPH_DIR=${GLPI_VAR_DIR}/_graphs 
ENV GLPI_LOCK_DIR=${GLPI_VAR_DIR}/_lock 
ENV GLPI_LOG_DIR=${GLPI_VAR_DIR}/_log 
ENV GLPI_PICTURE_DIR=${GLPI_VAR_DIR}/_pictures 
ENV GLPI_PLUGIN_DOC_DIR=${GLPI_VAR_DIR}/_plugins 
ENV GLPI_RSS_DIR=${GLPI_VAR_DIR}/_rss 
ENV GLPI_SESSION_DIR=${GLPI_VAR_DIR}/_sessions 
ENV GLPI_TMP_DIR=${GLPI_VAR_DIR}/_tmp 
ENV GLPI_UPLOAD_DIR=${GLPI_VAR_DIR}/_uploads 
ENV GLPI_CACHE_DIR=${GLPI_VAR_DIR}/_cache

COPY conf.d/*.ini $PHP_INI_DIR/conf.d/

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apk update 

RUN apk add icu-dev \
  && docker-php-ext-install intl

RUN docker-php-ext-install mysqli  

RUN apk add zlib-dev libpng-dev \
  && docker-php-ext-install gd 

RUN docker-php-ext-install exif

RUN apk add bzip2-dev \
  && docker-php-ext-install bz2

RUN apk add libzip-dev \
  && docker-php-ext-install zip

RUN apk add openldap-dev \
  && docker-php-ext-install ldap 

RUN docker-php-ext-install opcache

RUN docker-php-source delete

WORKDIR /var/www/html

ADD https://github.com/glpi-project/glpi/releases/download/${VERSION}/glpi-${VERSION}.tgz /tmp/

RUN tar -zxf /tmp/glpi-${VERSION}.tgz -C /tmp/ \
	&& mv /tmp/glpi/* /var/www/html \
	&& chown -R www-data:www-data /var/www/html \
	&& rm -rf /tmp/glpi-${VERSION}.tgz

COPY scripts/glpi-*.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/glpi-*.sh \
  && /usr/local/bin/glpi-verify-dir.sh

RUN rm -rf /var/www/html/install/install.php

EXPOSE 9000/tcp 

CMD ["php-fpm"]

