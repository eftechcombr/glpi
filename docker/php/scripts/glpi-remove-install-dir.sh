

removeInstallDir () {
  echo -n "Remove install dir... "
  rm -rf /var/www/html/install/install.php
  echo "done"
}

removeInstallDir