#!/bin/sh
set -e

echo "memory_limit = ${PHP_MEMORY_LIMIT:-256M}" > $PHP_INI_DIR/conf.d/zz-custom.ini

exec /usr/local/bin/docker-php-entrypoint "$@"
