#!/bin/sh

dbConfigure () {

    set -- \
    --db-host="$MARIADB_HOST" \
    --db-port="$MARIADB_PORT" \
    --db-name="$MARIADB_DATABASE" \
    --db-user="$MARIADB_USER" \
    --db-password="$MARIADB_PASSWORD" \
    --no-interaction --reconfigure

    DB_SSL="${GLPI_DB_SSL:-${MARIADB_SSL:-false}}"
    DB_SSL_CA="${GLPI_DB_SSL_CA:-${MARIADB_SSL_CA:-}}"
    DB_SSL_CERT="${GLPI_DB_SSL_CERT:-${MARIADB_SSL_CERT:-}}"
    DB_SSL_KEY="${GLPI_DB_SSL_KEY:-${MARIADB_SSL_KEY:-}}"
    DB_SSL_CAPATH="${GLPI_DB_SSL_CAPATH:-${MARIADB_SSL_CAPATH:-}}"
    DB_SSL_CIPHER="${GLPI_DB_SSL_CIPHER:-${MARIADB_SSL_CIPHER:-}}"

    if [ "$DB_SSL" = "true" ] || [ "$DB_SSL" = "1" ]; then
        set -- "$@" --db-ssl
        [ -n "$DB_SSL_CA" ] && set -- "$@" --db-ssl-ca="$DB_SSL_CA"
        [ -n "$DB_SSL_CERT" ] && set -- "$@" --db-ssl-cert="$DB_SSL_CERT"
        [ -n "$DB_SSL_KEY" ] && set -- "$@" --db-ssl-key="$DB_SSL_KEY"
        [ -n "$DB_SSL_CAPATH" ] && set -- "$@" --db-ssl-capath="$DB_SSL_CAPATH"
        [ -n "$DB_SSL_CIPHER" ] && set -- "$@" --db-ssl-cipher="$DB_SSL_CIPHER"
    fi

    php bin/console db:configure "$@"

}

dbConfigure
