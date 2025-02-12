FROM eftechcombr/glpi:php-fpm-10.0.18 as BUILD
#

FROM nginx:1.27.2-alpine3.20-slim
#
COPY --from=BUILD /var/www/html /var/www/html
COPY --from=BUILD /var/lib/glpi /var/lib/glpi

ADD conf.d/*.conf /etc/nginx/conf.d/

