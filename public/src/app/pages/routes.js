(function(angular, undefined){'use strict';

angular.module('pages')

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/', {
    title: 'Home',
    templateUrl: '/public/src/app/pages/home.html',
    controller: function($http, $scope) {
      $scope.$parent.bodyClass = 'home';

      $scope.selectedShow = '';
      $scope.showCounts = {};
      $scope.shows = [];

      $http.get('/api/items').success(function(data) {
        $scope.items = data;

        data.forEach(function(item) {
          if ($scope.shows.indexOf(item.show) === -1) {
            $scope.shows.push(item.show);
          }
          $scope.showCounts[item.show] = $scope.showCounts[item.show] ? 
            $scope.showCounts[item.show] + 1 : 1;
        });

        console.log($scope.showCounts);
      });
    }
  });
}]);

})(angular);
