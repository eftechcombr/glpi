FROM eftechcombr/glpi:php-fpm-10.0.10 as BUILD
#

FROM nginx:alpine
#
COPY --from=BUILD /var/www/html /var/www/html
COPY --from=BUILD /var/lib/glpi /var/lib/glpi

ADD conf.d/*.conf /etc/nginx/conf.d/

