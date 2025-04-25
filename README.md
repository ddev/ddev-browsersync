[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/ddev/ddev-browsersync/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/ddev/ddev-browsersync/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/ddev/ddev-browsersync)](https://github.com/ddev/ddev-browsersync/commits)
[![release](https://img.shields.io/github/v/release/ddev/ddev-browsersync)](https://github.com/ddev/ddev-browsersync/releases/latest)

# DDEV Browsersync <!-- omit in toc -->

- [Overview](#overview)
- [Installation](#installation)
- [Usage](#usage)
  - [Auto-start the watcher server](#auto-start-the-watcher-server)
- [What does this add-on do?](#what-does-this-add-on-do)
- [Integrations](#integrations)
  - [Laravel Mix Configuration](#laravel-mix-configuration)
  - [WordPress Configuration Changes](#wordpress-configuration-changes)
  - [Others](#others)
- [Troubleshooting](#troubleshooting)
  - [No Gateway / 502 error](#no-gateway--502-error)
  - [Unknown command "browsersync" for "ddev"](#unknown-command-browsersync-for-ddev)
  - [System limit for number of file watchers reached](#system-limit-for-number-of-file-watchers-reached)
- [Credits](#credits)

## Overview

[Browsersync](https://browsersync.io/) is free software that features:

- live reloads
- click mirroring
- network throttling

This add-on allows you to run [Browsersync](https://browsersync.io/) through the DDEV web service.

## Installation

To install this add-on, run:

```bash
ddev add-on get ddev/ddev-browsersync
ddev restart
```

After installation, make sure to commit the `.ddev` directory to version control.

## Usage

| Command | Description |
| ------- | ----------- |
| `ddev browsersync` | Start the watcher |
| `ddev launch :3000` | Launch the Browsersync page |

Examples:

```bash
$ ddev browsersync
Proxying Browsersync on https://mysite.ddev.site:3000
[Browsersync] Proxying: http://localhost
[Browsersync] Watching files...

$ ddev launch :3000
# The site should briefly display "Browsersync: connect"
# in the top right corner, confirming it is connect to the server.
```

### Auto-start the watcher server

You can use DDEV's `post-start` hook to start the watcher server and launch the page when DDEV starts.

```bash
cat <<'EOF' > .ddev/config.browsersync-extras.yaml
hooks:
    post-start:
        - exec-host: bash -c "ddev browsersync &"
        - exec-host: ddev launch :3000
EOF

ddev restart
```

## What does this add-on do?

1. Checks to make sure the DDEV version is adequate.
2. Adds `.ddev/web-build/Dockerfile.ddev-browsersync`, which installs Browsersync using npm.
3. Adds a `browser-sync.js` to define the operation of the base setup.
4. Adds a `.ddev/docker-compose.browsersync.yaml`, which exposes and routes the ports necessary.
5. Adds a `ddev browsersync` shell command, which lets you easily start Browsersync when you want it.

For WordPress projects, this add-on also:

- Adds a `wp-config-ddev-browser.php` file which modifies the WP_HOME and WP_SITEURL values to work with Browsersync.
- On install, modifies the `wp-config-ddev.php` file to include the `wp-config-ddev-browser.php` file.

## Integrations

`ddev-browsersync` works out of the box for many project types.
However, you may want to edit the `.ddev/browser-sync.js` file to specify exactly what files and directories
should be watched. Limiting watched files may reduce hard disk and CPU loads.

### Laravel Mix Configuration

Demo: <https://github.com/tyler36/browsersync-demo>

- Update `webpack.mix.js`

```js
// Use the HOSTNAME provided by DDEV
let url = process.env.DDEV_HOSTNAME;

mix.js('resources/js/app.js', 'public/js')
    .postCss('resources/css/app.css', 'public/css', [
        //
    ])
    .browserSync({
        proxy: "localhost",
        host:  url,
        open:  false,
        ui: false
    });
```

- Start Browsersync service

```shell
ddev exec npm run watch
...
[Browsersync] Proxying: http://localhost:3000
[Browsersync] Access URLs:
 ---------------------------------------------------
       Local: http://localhost:3000
    External: http://browsersync-demo.ddev.site:3000
 ---------------------------------------------------
```

- Browsersync will be running on **HTTPS** at `https://browsersync-demo.ddev.site:3000`

### WordPress Configuration Changes

When this add-on is added to a WordPress project, DDEV's management of the installation files is turned
off. 

The changes this add-on makes to the `wp-config-ddev.php` file during installation can be seen below.

The `wp-config-ddev-browserync.php` file is included before the `/** WP_HOME URL */` comment.

Before:

```php
/** WP_HOME URL */
defined( 'WP_HOME' ) || define( 'WP_HOME', 'https://projectname.ddev.site' );

/** WP_SITEURL location */
defined( 'WP_SITEURL' ) || define( 'WP_SITEURL', WP_HOME . '/' );
```

After:

```php
/** Include WP_HOME and WP_SITEURL settings required for Browsersync. */
if ( ( file_exists( __DIR__ . '/wp-config-ddev-browsersync.php' ) ) ) {
    include __DIR__ . '/wp-config-ddev-browsersync.php';
}

/** WP_HOME URL */
defined( 'WP_HOME' ) || define( 'WP_HOME', 'https://projectname.ddev.site' );

/** WP_SITEURL location */
defined( 'WP_SITEURL' ) || define( 'WP_SITEURL', WP_HOME . '/' );
```

### Others

There are many other options to integrate Browsersync into your project, including:

- [Grunt](https://browsersync.io/docs/grunt)
- [Laravel Mix](https://laravel-mix.com/docs/4.0/browsersync)

Please see [Browsersync documentation](https://browsersync.io/docs) for more details.

## Troubleshooting

### No Gateway / 502 error

This error usually occurs when the watcher server is not running.
Run `ddev browsersync` to start the server.

### Typo3 No site configuration found / 404 Error

Solution: The base URL (`base` in the TYPO3 site's `config.yaml` (like `config/sites/main/config.yaml` should specify `http` even though the frontend is configured for `https`. This can also be solved by commenting out the default `base` line.
```yaml
base: http://examplehost.ddev.site/
```

### Unknown command "browsersync" for "ddev"

> :bulb: This add-on moves to a per-project command approach in v2.5.0+. You can safely delete the global `~/.ddev/commands/web/browsersync` once you’re on v2.5.0 or higher.

If you run `ddev browsersync` from a local project and get `Error: unknown command "browsersync" for "ddev"`, please reinstall the add-on.

### System limit for number of file watchers reached

This error means the watcher is unable to track all the files it is tasked with watching.
You either have to decrease the number of files you’re watching or increase the file watcher limit.

- Decrease the number of files you're watching by updating `browser-sync.js`:
  - Limit the number of files being watch by updating `files: [...]` section
  - Increase the number of ignored files by updating  the `ignore: []` section
- If you use Colima, run `colima ssh` and `sudo sysctl fs.inotify.max_user_watches` to see how many watches you have. To increase it, use something like `sudo sysctl -w fs.inotify.max_user_watches=2048576`. Unfortunately, this has to be done on every Colima restart.
- If you use Docker Desktop for Mac, `docker run -it --privileged --pid=host justincormack/nsenter1` and `sysctl -w fs.inotify.max_user_watches=1048576`. Unfortunately, this has to be done again on every Docker restart.
- On Docker Desktop for Windows, add or edit `~/.wslconfig` with these contents:

    ```conf
    [wsl2]
    kernelCommandLine = "fs.inotify.max_user_watches=1048576"
    ```

- On Linux, you can change `fs.inotify.max_user_watches` on the host in `/etc/sysctl.d/local.conf` or elsewhere.

## Credits

PRs for install steps for specific frameworks are welcome.

**Contributed and maintained by [@tyler36](https://github.com/tyler36)**
