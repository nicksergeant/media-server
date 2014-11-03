'use strict';

var r = require('rethinkdb');

var db = r.connect({
  host: 'localhost',
  db: 'mediaserver',
  port: 28015
}).then(function(conn) {
  db.conn = conn;
  db.handleError = function(err, res) {
    if (res) res.send(500);
    console.log(err);
    throw err;
  };
}).error(function(err) {
  console.log(err);
  throw err;
});

module.exports = db;
