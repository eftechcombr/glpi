FROM eftechcombr/glpi:php-fpm-10.0.14 as BUILD
#

FROM nginx:1.25.3-alpine3.18
#
COPY --from=BUILD /var/www/html /var/www/html
COPY --from=BUILD /var/lib/glpi /var/lib/glpi

ADD conf.d/*.conf /etc/nginx/conf.d/

