pkg = require './package'
gulp = require 'gulp'
shelljs = require 'shelljs'
$ = require('gulp-load-plugins')()
spawn = require('child_process').spawn
psTree = require 'ps-tree'

APP_NAME = require('./src/package').name
FOLDERS =
  build: 'build'
  dist: 'dist'
  src: 'src'
  compiled: 'compiled'

compile = (cb) ->
  shelljs.rm '-rf', FOLDERS.compiled
  gulp
    .src [
      FOLDERS.src + '/**/*'
      '!' + FOLDERS.src + '/index.coffee'
      '!' + FOLDERS.src + '/app/**/*.coffee'
    ]
    .pipe gulp.dest FOLDERS.compiled
    .on 'error', $.util.log
    .on 'end', ->
      gulp
        .src [
          FOLDERS.src + '/**/*.coffee'
          '!' + FOLDERS.src + '/node_modules/**'
          '!' + FOLDERS.src + '/bower_components/**'
        ]
        .pipe $.coffeelint()
        .pipe $.coffeelint.reporter()
        .pipe $.coffee()
        .pipe gulp.dest FOLDERS.compiled
        .on 'error', $.util.log
        .on 'end', cb

gulp.task 'build', (cb) ->
  compile ->
    shelljs.rm '-rf', FOLDERS.build
    build = gulp
      .src FOLDERS.compiled + '/**'
      .pipe $.nwBuilder
        platforms: ['osx64']
        version: '0.12.3'
        macIcns: 'assets-osx/icon.icns'
        # zip: true
      .on 'log', $.util.log
      .on 'end', cb
  return

gulp.task 'pack', ['build'], ->
  shelljs.rm '-rf', FOLDERS.dist
  shelljs.mkdir '-p', FOLDERS.dist

  gulp.src []
    .pipe $.appdmg
      source: './assets-osx/dmg.json'
      target: FOLDERS.dist + '/' + APP_NAME + '.dmg'

gulp.task 'open', ['build'], ->
  shelljs.exec 'open ' + FOLDERS.build + '/' + APP_NAME + '/osx64/' + APP_NAME + '.app'

gulp.task 'watch', ->
  p = undefined
  killChildren = (done) ->
    if p
      psTree p.pid, (err, children) ->
        [p.pid].concat(
          children.map (c) -> c.PID
        ).forEach (tpid) ->
          try process.kill tpid, 'SIGKILL'
        p = undefined
        done()
    else
      done()
  spawnChildren = ->
    if p
      killChildren spawnChildren
    else
      compile ->
        p = spawn './node_modules/nw/bin/nw', [FOLDERS.compiled, '--debug'], { stdio: 'inherit' }
        p.on 'exit', (code) -> process.exit() if code isnt null
  gulp.watch FOLDERS.src + '/**/*', spawnChildren
  spawnChildren()

gulp.task 'default', ['watch']