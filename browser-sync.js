// #ddev-generated
let url = process.env.DDEV_HOSTNAME;
let filesdir = process.env.DDEV_FILES_DIR;

module.exports = {

    files: [docroot],
    ignore: ["node_modules", filesdir, "vendor"],
    open: false,
    ui: false,
    server: false,
    proxy: {
        target: "localhost"
    },
    host: url,
}
