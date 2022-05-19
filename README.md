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

This reciepe allows you to run [Browsersync](https://browsersync.io/) through the DDEV web service.

## Requirements

- DDEV >= 1.19
- Windows or Linux
- BrowserSync

## Getting Started

- Install DDEV service

```shell
ddev get tyler36/ddev-browsersync
ddev restart
```

- Update browersync configuration

This will depend on your implemenation of browsersync.
Generally, you will need to provide 3 configured options.

{
      proxy: url,
      host:  url,
      open:  false,
}

- `proxy` is your DDEV HOST name
- `host` is your DDEV HOST name
- `open` prevents the following message from being displayed

```shell
[Browsersync] Couldn't open browser (if you are using BrowserSync in a headless environment, you might want to set the open option to false)
```

There are many options to install and run browsersync, including:

- [Laravel-mix](https://laravel-mix.com/docs/4.0/browsersync)
- [Gulp](https://browsersync.io/docs/gulp)
- [Grunt](https://browsersync.io/docs/grunt)

Please see [Browsersync documentation](https://browsersync.io/docs) for more details.
PRs for install steps for specific frameworks are welcome.

### Laravel-mix example

Demo: <https://github.com/tyler36/browsersync-demo>
Assumes your DDEV HOST is `browsersync-demo.ddev.site`

- Update `webpack.mix.js`

```js
let url = 'browsersync-demo.ddev.site';

mix.js('resources/js/app.js', 'public/js')
    .postCss('resources/css/app.css', 'public/css', [
        //
    ])
    .browserSync({
        proxy: url,
        host:  url,
        open:  false,
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
          UI: http://localhost:3001
 UI External: http://localhost:3001
```

- Browsersync will be running at `https://browsersync-demo.ddev.site:3000`

## TODO

- Browsersync proxy HTTPS version
- Proper tests

**Contributed and maintained by [tyler36](https://github.com/tyler36)**
