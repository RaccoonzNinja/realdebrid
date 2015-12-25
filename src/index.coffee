menus = require './components/menus'
windowBehavior = require './components/window-behavior'

menus.loadMenuBar()
windowBehavior.set()
windowBehavior.restoreWindowState()

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
