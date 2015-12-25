htmlPath = process.env.PWD
if htmlPath isnt undefined
  htmlPath += '/compiled'
else
  htmlPath = '.'

angular.module 'realdebrid', ['ngRoute', 'SafeApply']
.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/account',
      templateUrl: htmlPath + '/app/views/account.html'
      controller: 'accountController'
    .when '/dashboard',
      templateUrl: htmlPath + '/app/views/dashboard.html'
      controller: 'dashboardController'
    .otherwise '/account'
]
.run ['User', (User) ->
  User.update()
]