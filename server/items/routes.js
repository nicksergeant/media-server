'use strict';

var config = require('../config');
var glob = require('glob');

exports.list = function() {
  return function(req, res, next) {

    glob(config.mediaRoot + '**/*.+(' + config.mediaExtensions.join('|') + ')', function (err, files) {

      var filesArr = [];
      files.forEach(function(file) {

        var relativeUrl = file.split(config.mediaRoot)[1];
        var fileParts = relativeUrl.split('/');

        var name = fileParts.length === 3 ? fileParts[2] : fileParts[1];
        var show = fileParts[0];
        var season = fileParts.length === 3 ? fileParts[1] : null;

        filesArr.push({
          name: name,
          show: show,
          season: season,
          url: '/media/' + relativeUrl
        });
      });

      res.send(filesArr);
    });

  };
};
