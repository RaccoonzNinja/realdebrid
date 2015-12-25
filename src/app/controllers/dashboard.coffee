angular.module 'realdebrid'
.controller 'dashboardController', [
  '$scope'
  '$location'
  'User'
  ($scope, $location, User) ->

    $scope.logout = ->
      User.logout ->
        $scope.$safeApply ->
          $location.path 'account'

]