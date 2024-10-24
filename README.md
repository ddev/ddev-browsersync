# ddev-browsersync <!-- omit in toc -->

[![tests](https://github.com/ddev/ddev-browsersync/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-browsersync/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [What does this add-on do?](#what-does-this-add-on-do)
- [Other ways to use Browsersync with this add-on](#other-ways-to-use-browsersync-with-this-add-on)
  - [Basic usage](#basic-usage)
  - [Problems](#problems)
  - [Laravel-mix configuration](#laravel-mix-configuration)

## Introduction

[Browsersync](https://browsersync.io/) is free software that features:

- live reloads
- click mirroring
- network throttling

This add-on allows you to run [Browsersync](https://browsersync.io/) through the DDEV web service.

## Getting Started

- Install the DDEV Browsersync add-on:

```shell
# For DDEV v1.23.5 or above run
ddev add-on get ddev/ddev-browsersync
# For earlier versions of DDEV run
ddev get ddev/ddev-browsersync
# Then for all versions:
ddev restart
ddev browsersync
```

The new `ddev browsersync` global command runs Browsersync inside the web container and provides a
link to the Browsersync proxy URL, something like `https://<project>.ddev.site:3000`.

The Browsersync’d URL is ***HTTPS***, not HTTP. ddev-router redirects traffic to HTTPS, but Browsersync does not know this.

EG.
"External: <http://d9.ddev.site:3000>" => Access on **<https://d9.ddev.site:3000>**


> :bulb: This add-on moves to a per-project approach in v2.5.0+. You can safely delete the global `~/.ddev/commands/web/browsersync` once you’re on v2.5.0 or higher—this will not affect usage.


If you run `ddev browsersync` from a local project and get `Error: unknown command "browsersync" for "ddev"`, run the following to add the command to the project:

For DDEV v1.23.5 or above run

```sh
ddev add-on get ddev/ddev-browsersync
```

For earlier versions of DDEV run

```sh
ddev get ddev/ddev-browsersync
```

Once Browsersync is running, visit `https://<project>.ddev.site:3000` or run `ddev launch :3000` to launch the proxy URL in a web browser.

## What does this add-on do?

1. Checks to make sure the DDEV version is adequate.
2. Adds `.ddev/web-build/Dockerfile.ddev-browsersync`, which installs Browsersync using npm.
3. Adds a `browser-sync.js` to define the operation of the base setup.
4. Adds a `.ddev/docker-compose.browsersync.yaml`, which exposes and routes the ports necessary.
5. Adds a `ddev browsersync` shell command, which lets you easily start Browsersync when you want it.

For WordPress projects, this add-on also:
* Adds a `wp-config-ddev-browser.php` file which modifies the WP_HOME and WP_SITEURL values to work with Browsersync.
* On install, modifies the `wp-config-ddev.php` file to include the `wp-config-ddev-browser.php` file. 

## Other ways to use browsersync with this add-on

There are many other options to integrate browsersync into your project, including:

- [Grunt](https://browsersync.io/docs/grunt)
- [Laravel Mix](https://laravel-mix.com/docs/4.0/browsersync)

Please see [Browsersync documentation](https://browsersync.io/docs) for more details.
PRs for install steps for specific frameworks are welcome.

### Basic usage

The existing example with just `ddev browsersync` should work out of the box.
There is no need for additional configuration, but you may want to edit
the `.ddev/browser-sync.js` file to specify exactly what files and directories
should be watched. If you watch less things it’s easier on your computer.

### Problems

- If you get `Error: ENOSPC: System limit for number of file watchers reached, watch '/var/www/html/web/core/themes/classy/images/icons/video-x-generic.png'` it means you either have to increase the file watcher limit or decrease the number of files you’re watching.
  - To decrease the number of files you’re watching, edit the `ignore` section in `browser-sync.js` (or another config file if you have a more complex setup).
  - On Colima, run `colima ssh` and `sudo sysctl fs.inotify.max_user_watches` to see how many watches you have. To increase it, use something like `sudo sysctl -w fs.inotify.max_user_watches=2048576`. Unfortunately, this has to be done on every Colima restart.
  - On Docker Desktop for Mac, `docker run -it --privileged --pid=host justincormack/nsenter1` and `sysctl -w fs.inotify.max_user_watches=1048576`. Unfortunately, this has to be done again on every Docker restart.
  - On Docker Desktop for Windows, add or edit `~/.wslconfig` with these contents:

    ```config
    [wsl2]
    kernelCommandLine = "fs.inotify.max_user_watches=1048576"
    ```

  - On Linux, you can change `fs.inotify.max_user_watches` on the host in `/etc/sysctl.d/local.conf` or elsewhere.

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

**Contributed and maintained by [tyler36](https://github.com/tyler36)**

### WordPress Configuration Changes.

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
