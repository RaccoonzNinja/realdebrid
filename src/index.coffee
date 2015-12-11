gui = require 'nw.gui'
app = gui.App
win = gui.Window.get()

showWindow = ->
  win.setShowInTaskbar true
  win.show()
  win.focus()

hideWindow = ->
  win.setShowInTaskbar false
  win.hide()

menu = new gui.Menu type: 'menubar'
menu.createMacBuiltin require('./package').name
win.menu = menu

app.on 'open', showWindow
app.on 'reopen', showWindow
showWindow()

# win.on('close', function () {
#   hideWindow();
# });

# Tray
# tray = new gui.Tray({
#   icon: 'images/icon@2x.png',
#   iconsAreTemplates: false
# });

# window.onunload = function () {
#   tray.remove();
#   tray = null;
# };

# Menu Tray
# menuTray = new gui.Menu();
# menuTray.append(new gui.MenuItem({
#   label: 'Open window',
#   click: function() {
#     showWindow();
#   }
# }));
# menuTray.append(new gui.MenuItem({ type: 'separator' }));
# menuTray.append(new gui.MenuItem({
#   label: 'Quit',
#   click: function() {
#     app.quit();
#   }
# }));
# tray.menu = menuTray;
