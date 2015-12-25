gui = window.require 'nw.gui'
win = gui.Window.get()
app = gui.App

settings = require './settings'

module.exports =

  set: ->
    app.removeAllListeners 'move'
    app.removeAllListeners 'resize'
    win.on 'move', @saveWindowState
    win.on 'resize', @saveWindowState

  saveWindowState: ->
    settings.windowState =
      x: win.x
      y: win.y
      width: win.width
      height: win.height

  restoreWindowState: ->
    state = settings.windowState
    win.resizeTo state.width, state.height
    win.moveTo state.x, state.y
    win.setShowInTaskbar true
    win.show()
    win.focus()