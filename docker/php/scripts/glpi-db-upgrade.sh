#!/bin/sh

dbUpgrade () {

    php bin/console database:update \
    --lang="$GLPI_LANG" \
    --no-interaction  
}

dbUpgrade
