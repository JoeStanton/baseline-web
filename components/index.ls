page = require "page"

api = require "./api.ls"
Layout = require "./layout.ls"

exports.listen = (component) ->
  pusher = new Pusher "48576a45701f7987f3fc"
  channel = pusher.subscribe "updates"
  channel.bind "service.create", component.sync
  channel.bind "service.update", component.sync
  channel.bind "service.destroy", component.sync

exports.start = ->
  api.base_url = "http://localhost:3000"

  root = $("\#wrapper")[0]

  render = (Component, options={}, callback) ->
    React.render-component new Component(options), root, callback

  page '/', ->
    layout = render Layout, null
    exports.listen layout

  page.start()
