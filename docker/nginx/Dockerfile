FROM eftechcombr/glpi:php-fpm-11.0.11 as BUILD
#

FROM nginxinc/nginx-unprivileged:1.31.6-alpine3.24-slim
#
COPY --from=BUILD /var/www/html /var/www/html
COPY --from=BUILD /var/lib/glpi /var/lib/glpi

COPY conf.d/*.conf /etc/nginx/conf.d/

# Update the default port to 8080 for unprivileged nginx
EXPOSE 8080

