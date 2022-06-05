// #ddev-generated
let url = process.env.DDEV_HOSTNAME;
let docroot = process.env.DDEV_DOCROOT;

module.exports = {

    files: [docroot],
    ignore: ["node_modules", docroot + "/sites/default/files", "vendor"],
    open: false,
    ui: false,
    server: false,
    proxy: {
        target: "localhost"
    },
    host: url,
}
