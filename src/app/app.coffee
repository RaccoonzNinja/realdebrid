htmlPath = process.env.PWD
if htmlPath isnt undefined
  htmlPath += '/compiled'
else
  htmlPath = '.'

angular.module 'realdebrid', ['ngRoute', 'SafeApply']
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when '/home',
        templateUrl: htmlPath + '/app/home/home.html'
        controller: 'homeController'
      .otherwise('/home')
  ]