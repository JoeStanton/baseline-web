page = require "page"

api = require "./api.ls"
Layout = require "./layout.ls"
Dashboard = require "./dashboard.ls"
ServiceOverview = require "./service-overview.ls"

listening = false

listen = (component) ->
  pusher = new Pusher "48576a45701f7987f3fc"
  channel = pusher.subscribe "updates"
  channel.bind "service.create", component.sync
  channel.bind "service.update", component.sync
  channel.bind "service.destroy", component.sync
  listening = true

exports.start = ->
  root = document.getElementById \wrapper
  layout = React.render-component Layout(), root
  listen layout

  render = (Component, options={}, callback) ->
    layout.setProps children: Component(options)
    window.layout = layout
    layout

  page '/', -> render Dashboard
  page '/:slug', (ctx) -> render ServiceOverview, slug: ctx.params.slug

  page.start()
