#!/usr/bin/env bash
#ddev-generated
set -e

if [[ $DDEV_PROJECT_TYPE != wordpress ]] ;
then
  exit 0
fi

if ( ddev debug configyaml 2>/dev/null | grep 'disable_settings_management:\s*true' >/dev/null 2>&1 ) ; then
  exit 0
fi

SETTINGS_FILE_NAME="${DDEV_APPROOT}/wp-config.php"

echo "Removing wp-config-ddev-browsersync.php from: ${SETTINGS_FILE_NAME}"

# Remove the ddev-browsersync config that we added.
awk '
/\/\*\* Include for ddev-browsersync to modify WP_HOME and WP_SITEURL\./ { skip=1 }
skip && /\}.*$/ { skip=0; getline; next }
!skip
' ${DDEV_APPROOT}/wp-config.php > ${DDEV_APPROOT}/wp-config-temp.php
mv ${DDEV_APPROOT}/wp-config-temp.php ${DDEV_APPROOT}/wp-config.php
