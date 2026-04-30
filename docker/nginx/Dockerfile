FROM eftechcombr/glpi:php-fpm-10.0.25 as BUILD
#

FROM nginxinc/nginx-unprivileged:1.27.5-alpine3.21-slim
#
COPY --from=BUILD /var/www/html /var/www/html
COPY --from=BUILD /var/lib/glpi /var/lib/glpi

COPY conf.d/*.conf /etc/nginx/conf.d/

# Update the default port to 8080 for unprivileged nginx
EXPOSE 8080

