#!/bin/sh

dbInstall () {

    php bin/console database:update \
    --lang=$GLPI_LANG \
    --db-host=$MARIADB_HOST \
    --db-port=$MARIADB_PORT \
    --db-name=$MARIADB_DATABASE \
    --db-user=$MARIADB_USER \
    --db-password=$MARIADB_PASSWORD \
    --no-interaction

}


if [ ! `php bin/console database:check_schema_integrity` ]
then
  dbInstall
fi

