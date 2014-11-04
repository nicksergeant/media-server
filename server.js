'use strict';

// Modules.
var bodyParser = require('body-parser');
var compression = require('compression');
var db = require('./server/db');
var ejs = require('ejs');
var errorhandler = require('errorhandler');
var express = require('express');
var fs = require('fs');
var items  = require('./server/items');
var morgan  = require('morgan');
var r = require('rethinkdb');
var resources = JSON.parse(fs.readFileSync(__dirname + '/resources.json'));

// Express application.
var app = express();

// Application config.
app.set('view engine', 'html');
app.engine('html', ejs.renderFile);
app.set('views', 'public/src');
app.use(compression());
app.set('json spaces', 0);

// Server middleware.
app.use(morgan(process.env.NODE_ENV === 'production' ? '' : 'dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());

// Traceback on uncaught exceptions.
process.on('uncaughtException', function (error) {
  console.log(error.stack);
});

// Production provisions.
if (process.env.NODE_ENV === 'production') {
  app.use(errorhandler({ dumpExceptions: true, showStack: true }));
}

// Items API.
app.get('/api/items', items.routes.list());

// Application route.
app.get('/*', function(req, res) {
  var locals = {
    env: process.env.NODE_ENV || 'development',
    resources: resources
  };
  if (process.env.NODE_ENV === 'production') {
    locals.cssModifiedTime = fs.statSync(__dirname + '/public/media-server.css').mtime.getTime() / 1000;
    locals.jsModifiedTime = fs.statSync(__dirname + '/public/media-server.js').mtime.getTime() / 1000;
  }
  res.render('base', locals);
});

// Server.
db.then(function() {
  app.listen(process.env.PORT || 3000, '0.0.0.0');
});
