// Include http module.
var http = require('http');

// Create http server.
var httpServer = http.createServer(function (req, resp) {

    resp.writeHeader(200);

    resp.end('This is a NodeJs Server ');
});

// Http server listen on port 8888.
httpServer.listen(8090);

console.log("Http web server listening on port 8888. Access it with url http://localhost:8090/.");