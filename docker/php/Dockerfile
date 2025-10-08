FROM eftechcombr/glpi:base 

ENV VERSION=10.0.9 
ENV GLPI_LANG=en_US 
ENV CACHE_DSN=redis://redis:6379/
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

USER www-data 

CMD ["php-fpm"]

