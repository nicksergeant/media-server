(function(angular, undefined){'use strict';

angular.module('pages')

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/', {
    title: 'Home',
    templateUrl: '/public/src/app/pages/home.html',
    reloadOnSearch: false,
    controller: function($http, $location, $scope, $window) {
      $scope.$parent.bodyClass = 'home';

      $scope.query = $location.search().q || '';
      $scope.showAllShows = false;
      $scope.selectedShow = $location.search().show || '';
      $scope.showCounts = {};
      $scope.shows = [];

      $scope.selectShow = function(show) {
        $scope.showAllShows = false;
        $scope.selectedShow = show;
        $window.scrollTo(0, 0);
        $location.search('show', show || null);
      };

      $scope.$watch('query', function(query) {
        $location.search('q', query || null);
      });

      $http.get('/api/items').success(function(data) {
        $scope.items = data;

        data.forEach(function(item) {
          if ($scope.shows.indexOf(item.show) === -1) {
            $scope.shows.push(item.show);
          }
          $scope.showCounts[item.show] = $scope.showCounts[item.show] ? 
            $scope.showCounts[item.show] + 1 : 1;
        });

      });
    }
  });
}]);

})(angular);
