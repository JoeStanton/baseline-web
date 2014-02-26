page = require "page"

api = require "./api.ls"
Layout = require "./layout.ls"
Dashboard = require "./dashboard.ls"
ServiceOverview = require "./service-overview.ls"

listening = false

exports.start = ->
  api.base_url = "http://localhost:3000"

  root = document.getElementById \wrapper

  render = (Component, options={}, callback) ->
    layout = React.render-component new Component(options), root
    listen layout unless listening
    layout

  page '/', -> render Dashboard
  page '/:slug', (ctx) -> render ServiceOverview, slug: ctx.params.slug

  page.start()

listen = (component) ->
  pusher = new Pusher "48576a45701f7987f3fc"
  channel = pusher.subscribe "updates"
  channel.bind "service.create", component.sync
  channel.bind "service.update", component.sync
  channel.bind "service.destroy", component.sync
  listening = true
