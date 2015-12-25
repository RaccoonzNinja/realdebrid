Store = require 'jfs'
path = require 'path'
gui = window.require 'nw.gui'

DEFAULT_SETTINGS =
  windowState: {}

db = new Store path.join gui.App.dataPath, 'preferences.json'
settings = db.getSync 'settings'
watchers = {}

# Watch changes to the storage
settings.watch = (name, callback) ->
  unless Array.isArray watchers[name]
    watchers[name] = []

  watchers[name].push callback

# Save settings every time a change is made and notify watchers
Object.observe settings, (changes) ->
  db.save 'settings', settings, (err) ->
    if err
      console.error 'Could not save settings', err

  changes.forEach (change) ->
    newValue = change.object[change.name]
    keyWatchers = watchers[change.name]

    # Call all the watcher functions for the changed key
    if keyWatchers and keyWatchers.length
      for keyWatcher, i in keyWatchers
        try
          keyWatcher newValue
        catch ex
          console.error ex
          keyWatchers.splice i--, 1

# Ensure the default values exist
Object.keys(DEFAULT_SETTINGS).forEach (key) ->
  unless settings.hasOwnProperty key
    settings[key] = DEFAULT_SETTINGS[key]

module.exports = settings
