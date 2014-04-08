React = window.React = require "react" # Expose for Chrome DevTools
{div, span, p, a, img, ul, li, strong} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{table, thead, tbody, th, td, tr} = React.DOM
{dl, dd, dt} = React.DOM

api = require "./api.ls"

Top = require "./top.ls"
Left = require "./left.ls"

{status-to-colour, format-duration} = require './helpers.ls'

numeral = require 'numeral'

{find} = require 'prelude-ls'

module.exports = React.create-class do
  displayName: 'ServiceOverview'
  get-service: ->
    root = @
    @props.services |> find (.slug == root.props.slug)

  render: ->
    service = @get-service!
    return div null, "Loading..." unless service
    div className: "green #{status-to-colour service.status}",
      h1 null, service.name
      dl id: "summary",
        dt null, 'Service Status'
        dd className: "number",
          span className: "status"
          a href: "", "Healthy"
        dt null, 'Service Availability:'
        dd null, if service.availability then numeral(service.availability).format "0.000%" else "N/A"
        dt null, 'Mean Time Between Failure'
        dd null, format-duration service.mean_time_between_failure
        dt null, 'Mean Time To Recovery'
        dd null, format-duration service.mean_time_to_recovery
      ComponentsTable components: service.components
      HostsTable hosts: service.hosts

ComponentsTable = React.create-class do
  displayName: 'ComponentsTable'
  render: ->
    table className: "list",
      thead null,
        th null, "Component"
        th null, "Description"
        th null, "Status"
      tbody null,
        @props.components.map (component) ->
          tr key: component.name, className: "host #{status-to-colour component.status}",
           td null, component.name
           td null, component.description
           td className: "number",
             span className: "status"
             a null, component.status || "Unknown"

HostsTable = React.create-class do
  displayName: 'HostsTable'
  render: ->
    table className: "list",
      thead null,
        th null, "Host"
        th null, "Status"
      tbody null,
        @props.hosts.map (host) ->
          tr className: "host #{status-to-colour host.status}",
           td null, host.hostname
           td className: "number",
             span className: "status"
             a null, host.status || "Unknown"
