<?php
// #ddev-generated
/** Allow any domain/port so WordPress allows browsersync's :3000 URLs */
if ( ! empty( $_SERVER['SERVER_PORT'] ) && ! empty( $_SERVER['SERVER_NAME'] ) ) {
	// phpcs:ignore
	$domain = sprintf( '%s://%s', $_SERVER['SERVER_PORT'] == 80 ? 'http' : 'https', $_SERVER['SERVER_NAME'] );

	/** WP_HOME URL */
	define( 'WP_HOME', $domain );

	/** WP_SITEURL location */
	define( 'WP_SITEURL', $domain );
}
