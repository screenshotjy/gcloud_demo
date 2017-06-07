'use strict';

var os = require('os');
var http = require('http');

var interfaces = os.networkInterfaces();
var port = 80;

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end(JSON.stringify(interfaces, null, 2));
}).listen(port);

console.log('Server listening on port', port);
