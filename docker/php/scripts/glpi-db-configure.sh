#!/bin/sh

dbConfigure () {

    php bin/console db:configure \
    --db-host=$MARIADB_HOST \
    --db-port=$MARIADB_PORT \
    --db-name=$MARIADB_DATABASE \
    --db-user=$MARIADB_USER \
    --db-password=$MARIADB_PASSWORD \
    --no-interaction --reconfigure 

}


chmod -R g+rw ${GLPI_CONFIG_DIR}

dbConfigure

chmod -R g+r ${GLPI_CONFIG_DIR}