#!/bin/sh

cacheConfigure () {
    if [ -z "$CACHE_DSN" ]; then
        echo "CACHE_DSN is not set. Skipping cache configuration."
        return
    fi
    php bin/console cache:configure --dsn="$CACHE_DSN" --no-interaction
}

cacheConfigure
