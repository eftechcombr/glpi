#!/bin/sh

dbConfigure () {

    php bin/console db:configure \
    --db-host="$MARIADB_HOST" \
    --db-port="$MARIADB_PORT" \
    --db-name="$MARIADB_DATABASE" \
    --db-user="$MARIADB_USER" \
    --db-password="$MARIADB_PASSWORD" \
    --no-interaction --reconfigure 

}

dbConfigure
