# tyler36/ddev-browsersync <!-- omit in toc -->

[![tests](https://github.com/tyler36/ddev-browsersync/actions/workflows/tests.yml/badge.svg)](https://github.com/tyler36/ddev-browsersync/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2022.svg)

- [Introduction](#introduction)
- [Requirements](#requirements)
- [Steps](#steps)
  - [Laravel-mix example](#laravel-mix-example)
  - [Gulp](#gulp)
- [Note](#note)
- [Errors](#errors)
  - ['400 Bad Request: The plain HTTP request was sent to HTTPS port'](#400-bad-request-the-plain-http-request-was-sent-to-https-port)
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

There are many options to install and run browsersync, including:

- [Gulp](https://browsersync.io/docs/gulp)
- [Grunt](https://browsersync.io/docs/grunt)
- [Laravel-mix](https://laravel-mix.com/docs/4.0/browsersync)

Please see [Browsersync documentation](https://browsersync.io/docs) for more details.

## Steps

- Install service

```shell
ddev get tyler36/ddev-browsersync
ddev restart
```

- Update browersync configuration

This will depend on your implemenation of browser.
Generally, you will need to provide 3 configured options.

{
      proxy: url,
      host:  url,
      open:  false,
}

- `proxy` is your DDEV HOST name
- `host` is your DDEV HOST name
- `open` prevents the following message from being displayed

"[Browsersync] Couldn't open browser (if you are using BrowserSync in a headless environment, you might want to set the open option to false)
"

Some examples are below.

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
```

- Browsersync will be running at `https://browsersync-demo.ddev.site:3000`

### Gulp

Assumes your DDEV HOST is `browsersync-demo.ddev.site`

- Update `gulpfile.js`

```js
var gulp        = require('gulp');
var browserSync = require('browser-sync').create();

let url = 'browsersync-demo.ddev.site';

gulp.task('browser-sync', function() {
    browserSync.init({
        proxy: url,
        host:  url,
        open:  false,
        files: ['./public'],
    });
});
```

- Start browsersync service

```shell
ddev exec gulp
```

- Browsersync will be running at `https://browsersync-demo.ddev.site:3000`

## Note

Browsersync, when running, will output something similar to below.

```shell
[Browsersync] Proxying: http://browsersync-demo.ddev.site
[Browsersync] Access URLs:
 ---------------------------------------------------
       Local: http://localhost:3000
    External: http://browsersync-demo.ddev.site:3000
 ---------------------------------------------------
          UI: http://localhost:3001
 UI External: http://localhost:3001
```

Due to the way DDEV route works, these URLs will **not** work!

You must use the HTTPS address with the port.

- ❌ `http://browsersync-demo.ddev.site:3000`
- ✅ `https://browsersync-demo.ddev.site:3000`

## Errors

### '400 Bad Request: The plain HTTP request was sent to HTTPS port'

- Access the site via HTTPS, and **not** the HTTP address shown.EG.
  - ❌ `http://browsersync-demo.ddev.site:3000`
  - ✅ `https://browsersync-demo.ddev.site:3000`

This is due to how DDEV router works.

## TODO

- Browsersync should display correct HTTPS external URL
- Proper tests

**Contributed and maintained by [tyler36](https://github.com/tyler36)**
