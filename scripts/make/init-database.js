'use strict';

var r = require('rethinkdb');

var db = r.connect({
  host: 'localhost',
  port: 28015
}).then(function(conn) {
  r.dbCreate('mediaserver').run(conn).then(function() {
  }).then(function() {
    console.log('Done.');
    process.exit();
  }).error(function(err) {
    console.log(err);
    process.exit();
  });
}).error(function(err) {
  console.log(err);
  process.exit();
});
