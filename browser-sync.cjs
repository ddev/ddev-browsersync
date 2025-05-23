// #ddev-generated
let docroot = process.env.DDEV_DOCROOT;
let filesdir = process.env.DDEV_FILES_DIR;
let url = process.env.DDEV_HOSTNAME;
let nonSslUrl = process.env.DDEV_PRIMARY_URL.replace( /^https:/, 'http:' )

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
        target: nonSslUrl
    },
    host: url,
}
