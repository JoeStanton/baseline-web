page = require "page"

api = require "./api.ls"
Dashboard = require "./dashboard.ls"
ServiceOverview = require "./service-overview.ls"
Incidents = require "./incidents.ls"
Events = require "./events.ls"

Layout = require "./layout.ls"

listening = false

listen = (component) ->
  #Pusher.log = (message) -> console.log message
  pusher = new Pusher "48576a45701f7987f3fc"
  channel = pusher.subscribe "updates"
  for entity in ['service', 'component', 'host', 'event', 'deployment', 'configuration']
    channel.bind "#{entity}.create", component.sync
    channel.bind "#{entity}.update", component.sync
    channel.bind "#{entity}.destroy", component.sync
  listening = true

exports.start = ->
  root = document.getElementById \wrapper
  window.layout = layout = React.render-component Layout!, root
  listen layout

  render = (Component, options) ->
    layout.setProps handler: Component, options: options

  page '/', -> render Dashboard
  page '/:slug', (ctx) ->
    render ServiceOverview, key: ctx.params.slug + "overview", slug: ctx.params.slug
  page '/:slug/incidents', (ctx) ->
    render ServiceOverview, key: ctx.params.slug + "incidents", slug: ctx.params.slug, selected: "incidents"
  page '/:slug/events', (ctx) ->
    render ServiceOverview, key: ctx.params.slug + "events", slug: ctx.params.slug, selected: "events"
  page '/:slug/spec', (ctx) ->
    render ServiceOverview, key: ctx.params.slug + "spec", slug: ctx.params.slug, selected: "spec"

  page.start()
