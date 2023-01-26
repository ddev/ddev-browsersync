// #ddev-generated
const {createProxyMiddleware} = require('http-proxy-middleware');

let docroot = process.env.DDEV_DOCROOT;
let filesdir = process.env.DDEV_FILES_DIR ? process.env.DDEV_FILES_DIR : null;
// process.env.DDEV_HOSTNAME contains a comma seperated list of all hostnames of the web container
let env_hostnames = process.env.DDEV_HOSTNAME;
let hostnames = env_hostnames.split(',')
let url = hostnames[0];
let browsersyncPort = 3000;
let proxies = [];

// Create proxies for each domain to use in browsersync middlewares
hostnames.forEach(function (hostname) {
    proxies.push({
        'hostname': hostname,
        'middleware': createProxyMiddleware('*', {target: 'https://' + hostname, changeOrigin: true})
    })
})

module.exports = {
    files: [docroot, "app", "resources/views/**/*.php"],
    ignore: ["node_modules", filesdir, "vendor"],
    open: false,
    ui: false,
    server: false,
    middleware: function (req, res, next) {
        hostnames.forEach(function (hostname, index) {
            if (req.headers.host === hostname + ':' + browsersyncPort) {
                proxies[index].middleware(req, res, next);
            }
        })
    },
    proxy: {
        target: url,
    },
    host: url,
}
