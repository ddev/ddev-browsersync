// #ddev-generated
let docroot = process.env.DDEV_DOCROOT;
let filesdir = process.env.DDEV_FILES_DIR;

// Explicitly state a single URL (@see https://github.com/drud/ddev-browsersync/issues/27)
let url = `${process.env.DDEV_PROJECT}.${process.env.DDEV_TLD}`;

if (filesdir === "") {
    filesdir = null
}

module.exports = {

    files: [docroot, "app", "resources/views/**/*.php"],
    ignore: ["node_modules", filesdir, "vendor"],
    open: false,
    ui: false,
    server: false,
    proxy: {
        target: "localhost"
    },
    host: url,
}
