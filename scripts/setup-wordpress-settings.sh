#!/usr/bin/env bash
#ddev-generated
set -e

if [[ "$DDEV_PROJECT_TYPE" != "wordpress" ]] ;
then
  exit 0
fi

# if ( ddev debug configyaml 2>/dev/null | grep 'disable_settings_management:\s*true' >/dev/null 2>&1 ) ; then
#   exit 0
# fi

if [ "$DDEV_DOCROOT" != "" ]; then
  DDEV_SITE_PATH="${DDEV_APPROOT}/${DDEV_DOCROOT}" ;
else
  DDEV_SITE_PATH=$DDEV_APPROOT
fi

cp scripts/wp-config-ddev-browsersync.php "$DDEV_SITE_PATH/"

SETTINGS_FILE_NAME="${DDEV_SITE_PATH}/wp-config.php"

echo "Settings file name: ${SETTINGS_FILE_NAME}"

# If wp-config.php already contains the require_once() then exit early.
if grep -q "/\*\* Include for ddev-browsersync to modify WP_HOME and WP_SITEURL. \*/" "${DDEV_SITE_PATH}/wp-config.php"; then
   exit 0
fi

echo "Adding wp-config-ddev-browsersync.php to: ${SETTINGS_FILE_NAME}"

# Append our code before the ddev config comment.
awk '
/\/\/ Include for settings managed by ddev./ {
    print "/** Include for ddev-browsersync to modify WP_HOME and WP_SITEURL. */"
    print "$ddev_browsersync_settings = __DIR__ . '\''/wp-config-ddev-browsersync.php'\'';"
    print "if ( getenv( '\''IS_DDEV_PROJECT'\'' ) == '\''true'\'' && is_readable( $ddev_browsersync_settings ) ) {"
    print "    require_once( $ddev_browsersync_settings );"
    print "}"
    print ""
    print "// Include for settings managed by ddev."
    next
}
{print}
' "${DDEV_SITE_PATH}/wp-config.php" > "${DDEV_SITE_PATH}/wp-config-temp.php"

# Replace the real config file with the modified version in temporary file.
mv "${DDEV_SITE_PATH}/wp-config-temp.php" "${DDEV_SITE_PATH}/wp-config.php"
