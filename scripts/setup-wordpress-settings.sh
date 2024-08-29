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

cp scripts/wp-config-ddev-browsersync.php $DDEV_APPROOT/

SETTINGS_FILE_NAME="${DDEV_APPROOT}/wp-config-ddev.php"

echo "Settings file name: ${SETTINGS_FILE_NAME}"

# Replace /** WP_HOME URL */ with our include
awk '
/\/\*\* WP_HOME URL \*\// {
    print "    /** Include WP_HOME and WP_SITEURL settings required for Browsersync. */"
    print "    if ( ( file_exists( __DIR__ . '\''/wp-config-ddev-browsersync.php'\'' ) ) ) {"
    print "        include __DIR__ . '\''/wp-config-ddev-browsersync.php'\'';"
    print "    }"
    print ""
    print "    /** WP_HOME URL */"
    next
}
{print}
' wp-config-ddev.php > wp-config-ddev-temp.php

# Replace the real config file with the modified version in temporary file.
mv wp-config-ddev-temp.php > wp-config-ddev.php
