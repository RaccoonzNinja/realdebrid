gui = window.require 'nw.gui'
win = gui.Window.get()

module.exports =

  loadMenuBar: ->
    menu = new gui.Menu type: 'menubar'
    menu.createMacBuiltin require('../package').name
    submenu = menu.items[0].submenu
    submenu.insert new gui.MenuItem(
      label: 'Launch Dev Tools'
      key: 'j'
      modifiers: 'cmd-alt'
      click: -> win.showDevTools()
    ), 1
    win.menu = menu