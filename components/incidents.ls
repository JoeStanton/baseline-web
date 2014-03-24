React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{table, thead, tbody, th, td, tr} = React.DOM
{strong, dl, dt, dd} = React.DOM

Layout = require "./layout.ls"

module.exports = React.create-class do
  displayName: "Incidents"
  getInitialState: ->
    open: [
      service: "Fortnum & Mason Awards Site"
      components: ["Nginx"]
      hosts: ["rb-prod-01"]
      notified-users: ["Joe Stanton", "Stuart Harris"]
      root-cause: "File descriptor limit exceeded."
    ]
    resolved: []

  sync: ->
    api.get '/incidents/', (error, incidents) ~>
      return console.error error if error
      incidents = services |> group-by (.status)
      @setState open: incidents['open'] resolved: incidents['resolved']

  render: ->
    {open, resolved} = @state
    Layout null,
      div null,
        h1 null, "Open Incidents"
        if open.length
          open.map Incident
        else
          "None."
        #h1 null, "Resolved Incidents"
        #if resolved.length
          #open.map Incident
        #else
          #"None."

Incident = React.create-class do
  displayName: "Incident"
  render: ->
    div className: "incident",
      h2 null, @props.service
      dl id: "summary",
        dt null, 'Service Status'
        dd null, 'DOWN'
        dt null, 'Started'
        dd null, 'Mon 24th March - 10:30PM (2 hours ago)'
        dt null, 'Notified Users'
        dd null, @props.notified-users.join ', '
        dt null, 'Hosts'
        dd null, @props.hosts.join ', '
        dt null, 'Affected Components'
        dd null, @props.components.join ', '
      div className: "related",
        h2 null, "Recent Events",
          EventsTable events: [
            type: "Deployment"
            service: "Fortnum & Mason Awards"
            date: 'Fri 14th March - 10:30PM (10 days ago)'
            hosts: "rb-prod-01"
          ]

        h2 null, "Similar Incidents",
          IncidentsTable incidents: [
            service: "Fortnum & Mason Awards"
            components: ["Nginx"]
            date: 'Fri 14th March - 10:30PM (10 days ago)'
            resolution-time: '10 minutes'
            resolved-by: 'Stuart Harris'
            root-cause: "File descriptor limit exceeded. Caused intermittent failed requests."
          ]

EventsTable = React.create-class do
  displayName: "EventsTable"
  render: ->
    table className: "list",
      thead null,
        th null, "Event Type"
        th null, "Service"
        th null, "Date"
        th null, "Hosts"
      tbody null,
        @props.events.map (event) ->
          tr className: "related-event",
           td null, event.type
           td null, event.service
           td null, event.date
           td null, event.hosts

IncidentsTable = React.create-class do
  displayName: "IncidentsTable"
  render: ->
    table className: "list",
      thead null,
        th null, "Service"
        th null, "Component"
        th null, "Date"
        th null, "Resolution Time"
        th null, "Resolved by"
        th null, "Root Cause"
      tbody null,
        @props.incidents.map (incident) ->
          tr className: "related-incident",
           td null, incident.service
           td null, incident.components.join ', '
           td null, incident.date
           td null, incident.resolution-time
           td null, incident.resolved-by
           td null, incident.root-cause || "Unknown"
