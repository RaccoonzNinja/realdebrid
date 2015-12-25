realdebrid = require './components/realdebrid-api'

angular.module 'realdebrid'
.service 'User', ['$rootScope', ($rootScope) ->

  userData = undefined

  get: -> return userData
  update: ->
    realdebrid.account (err, data) ->
      if err?
        userData = undefined
      else
        userData = data
      $rootScope.$safeApply ->
        $rootScope.$broadcast 'user-update'
  login: (user, pass, cb) ->
    realdebrid.login user, pass, (err) =>
      @update() unless err?
      cb err
  logout: (cb) ->
    realdebrid.logout ->
      cb()
      userData = undefined
      $rootScope.$safeApply ->
        $rootScope.$broadcast 'user-update'

]