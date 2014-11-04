(function(window, undefined){'use strict';

window.mediaserver = {};

var deps = [
  'ngRoute',
  'pages'
];

mediaserver = angular.module('mediaserver', deps);
mediaserver.config(['$locationProvider', '$routeProvider', function($locationProvider, $routeProvider) {
  $locationProvider.html5Mode(true);
  $routeProvider.otherwise({
    templateUrl: '/public/src/app/errors/404.html'
  });
}]);
mediaserver.directive('ngApp', ['$window', function($window) {
  return {
    link: function(scope, element, attrs) {
      $window.addEventListener('load', function() {
        FastClick.attach(document.body);
      }, false);
    }
  };
}]);

}(window));
