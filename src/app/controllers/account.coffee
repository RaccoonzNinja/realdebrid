angular.module 'realdebrid'
.controller 'accountController', [
  '$scope'
  '$location'
  'User'
  ($scope, $location, User) ->

    $scope.credentials =
      username: ''
      password: ''

    $scope.message = 'Loading account info...'
    $scope.showForm = false

    $scope.submitForm = ->
      if not $scope.credentials.username
        return alert 'Username empty'

      if not $scope.credentials.password
        return alert 'Password empty'

      $scope.message = 'Logging in...'
      $scope.showForm = false

      u = $scope.credentials.username
      p = $scope.credentials.password
      User.login u, p, (err) ->
        if err?
          $scope.$safeApply ->
            $scope.message = err
            $scope.showForm = true

    $scope.$on 'user-update', ->
      if User.get()?
        $location.path 'dashboard'
      else
        $scope.message = 'You need to login.'
        $scope.showForm = true
]