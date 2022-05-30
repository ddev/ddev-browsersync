# tyler36/ddev-browsersync <!-- omit in toc -->

[![tests](https://github.com/tyler36/ddev-browsersync/actions/workflows/tests.yml/badge.svg)](https://github.com/tyler36/ddev-browsersync/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2022.svg)

- [Introduction](#introduction)
- [Requirements](#requirements)
- [Getting Started](#getting-started)
  - [Laravel-mix example](#laravel-mix-example)
- [TODO](#todo)

## Introduction

[Browsersync](https://browsersync.io/) is free software that features:

- live reloads
- click mirroring
- network throttling

This add-on allows you to run [Browsersync](https://browsersync.io/) through the DDEV web service.

## Getting Started

- Install the DDEV browsersync add-on:

```shell
ddev get tyler36/ddev-browsersync
ddev restart
ddev browsersync
```

The new `ddev browsersync` global command runs browsersync inside the web container and provides a 
link to the browsersync-update URL.

## Other ways to use 
There are many other options to integrate browsersync into your project, including:

- [Grunt](https://browsersync.io/docs/grunt)
- [Laravel-mix](https://laravel-mix.com/docs/4.0/browsersync)


Please see [Browsersync documentation](https://browsersync.io/docs) for more details.
PRs for install steps for specific frameworks are welcome.

### Simplest project example

The existing example with just `ddev browsersync` should work out of the box.
There is no need for additional configuration, but you may want to edit
the `.ddev/browser-sync.js` file to specify exactly what files and directories
should be watched. If you watch less things it's easier on your computer.

### Laravel-mix example

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

- Start browsersync service

```shell
ddev exec npm run watch
...
[Browsersync] Proxying: http://browsersync-demo.ddev.site
[Browsersync] Access URLs:
 ---------------------------------------------------
       Local: http://localhost:3000
    External: http://browsersync-demo.ddev.site:3000
 ---------------------------------------------------
```

- Browsersync will be running at `https://browsersync-demo.ddev.site:3000`

## TODO

- Browsersync proxy HTTPS version
- Proper tests

**Contributed and maintained by [tyler36](https://github.com/tyler36)**
