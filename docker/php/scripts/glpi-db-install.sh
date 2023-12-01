#!/bin/sh

dbInstall () {

    php bin/console db:install \
    --default-language="$GLPI_LANG" \
    --db-host="$MARIADB_HOST" \
    --db-port="$MARIADB_PORT" \
    --db-name="$MARIADB_DATABASE" \
    --db-user="$MARIADB_USER" \
    --db-password="$MARIADB_PASSWORD" \
    --no-interaction --reconfigure
}

php bin/console database:check_schema_integrity || dbInstall

