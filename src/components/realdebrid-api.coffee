fs = require 'fs'
path = require 'path'
gui = window.require 'nw.gui'
cookiePath = path.join gui.App.dataPath, 'cookies.json'

touch = require 'touch'
touch.sync cookiePath

request = require 'request'
FileCookieStore = require 'tough-cookie-filestore'
cookieJar = request.jar new FileCookieStore cookiePath

request = request.defaults
  jar: cookieJar
  encoding: 'utf-8'
  headers:
    'User-Agent': 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.1' +
      '3) Gecko/20080311 Firefox/2.0.0.13'

module.exports =

  getValidHosters: (cb) ->
    return unless cb
    request
      url: 'https://real-debrid.com/api/hosters.php'
    , (err, response, body) ->
      if err?
        cb err, []
      else
        cb err, body.substring(1, body.length - 1).split('","')

  login: (user, pass, cb) ->
    return unless cb
    request
      url: 'https://real-debrid.com/ajax/login.php?user=' +
      user + '&pass=' + pass
      json: true
    , (err, response, data) ->
      if err?
        cb err
      else
        if data.error is 0
          cb()
        else
          error = new Error data.message
          error.code = data.error
          cb error

  account: (cb) ->
    return unless cb
    request
      url: 'https://real-debrid.com/api/account.php?out=json'
      json: true
    , (err, response, data) ->
      if data.error is 1
        error = new Error data.message
        error.code = data.error
        cb error
      else
        cb null, data

  unrestrict: (link, password, cb) ->
    return unless cb
    link = encodeURI link
    request
      url: 'https://real-debrid.com/ajax/unrestrict.php?out=json&link=' +
      link + '&password=' + password
      json: true
    , (err, response, data) ->
      if err?
        cb err
      else if data.error > 0
        error = new Error data.message
        error.code = data.error
        cb error
      else cb null, data

  logout: (cb) ->
    fs.writeFile cookiePath, '', cb
