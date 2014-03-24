page = require "page"

api = require "./api.ls"
Dashboard = require "./dashboard.ls"
ServiceOverview = require "./service-overview.ls"
Incidents = require "./incidents.ls"
Events = require "./events.ls"

listening = false

listen = (component) ->
  Pusher.log = (message) -> console.log message
  pusher = new Pusher "48576a45701f7987f3fc"
  channel = pusher.subscribe "updates"
  for entity in ['service', 'component', 'host']
    channel.bind "#{entity}.create", component.sync
    channel.bind "#{entity}.update", component.sync
    channel.bind "#{entity}.destroy", component.sync
  listening = true

exports.start = ->
  root = document.getElementById \wrapper

  render = (Component, options) ->
    React.render-component Component(options), root
    #listen layout

  page '/', -> render Dashboard
  page '/incidents', (ctx) -> render Incidents
  page '/events', (ctx) -> render Events
  page '/:slug', (ctx) -> render ServiceOverview, slug: ctx.params.slug

  page.start()
