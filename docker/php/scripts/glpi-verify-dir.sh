#!/bin/sh

VerifyDir () {

  DIR="${GLPI_VAR_DIR}/_cron
  ${GLPI_VAR_DIR}/_dumps
  ${GLPI_VAR_DIR}/_graphs
  ${GLPI_VAR_DIR}/_log
  ${GLPI_VAR_DIR}/_lock
  ${GLPI_VAR_DIR}/_pictures
  ${GLPI_VAR_DIR}/_plugins
  ${GLPI_VAR_DIR}/_rss
  ${GLPI_VAR_DIR}/_tmp
  ${GLPI_VAR_DIR}/_uploads
  ${GLPI_VAR_DIR}/_cache
  ${GLPI_VAR_DIR}/_sessions
  ${GLPI_VAR_DIR}/_locales
  ${GLPI_MARKETPLACE_DIR}
  ${GLPI_CONFIG_DIR}"

  for i in $DIR
  do 
    if [ ! -d "$i" ]
    then
      echo -n "Creating $i dir... " 
      mkdir -p "$i"
      echo "done"
    fi
  done
}

SetPermissions () {
  echo -n "Setting chown in files and plugins... "
  chown -R www-data:www-data "${GLPI_VAR_DIR}"
  chown -R www-data:www-data "${GLPI_CONFIG_DIR}" 
  chown -R www-data:www-data "${GLPI_MARKETPLACE_DIR}"
  chmod -R a+rw "${GLPI_VAR_DIR}" 
  chmod -R a+rw "${GLPI_CONFIG_DIR}" 
  chmod -R a+rw "${GLPI_MARKETPLACE_DIR}"
  echo "done"
}

VerifyDir
SetPermissions
