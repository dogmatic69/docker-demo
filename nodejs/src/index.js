"use strict";
(() => {
    const http = require('http'),
         os = require('os');

    const log = (foo) => {
        console.log(foo);
    }

    const sendJson = (data) => {
        return JSON.stringify(data, null, 4);
    }

    const handleRequest = (request, response) => {
        response.json = (data) => {
            return response.end(sendJson(data));
        }
        switch (request.url) {
            case "/info":
                return response.json({
                    "Stats": {
                        cpus: os.cpus().length,
                        "Free Memory": os.freemem(),
                        "Load Avg.": os.loadavg().join(" / "),
                        "Up Time": os.uptime()

                    },
                    "System": {
                        arch: os.arch(),
                        "Host Name": os.hostname(),
                        "Platform": os.platform(),
                        "Version": os.release(),
                        "Home Dir": os.homedir(),
                        "User": os.userInfo()
                    },
                    "Network": os.networkInterfaces().eth0
                });

            default:
                return response.json({
                    "message": "It's working, but try /info"
                });
        }
    }

    const server = http.createServer(handleRequest);
    server.on('clientError', (err, socket) => {
        socket.end('HTTP/1.1 400 Bad Request\r\n\r\n');
    });
    server.on('close', () => {
        socket.end('close');
    });
    server.on('connect', () => {
        socket.end('connect');
    });
    server.on('connection', () => {
        log('connection');
    });
    server.on('request', () => {
        log('request');
    });


    server.listen(process.env.PORT, () => {
        log("Listening");
    });
})();