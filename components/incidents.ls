React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{table, thead, tbody, th, td, tr} = React.DOM
{strong, dl, dt, dd} = React.DOM

moment = require 'moment'
{group-by} = require 'prelude-ls'

#service: "Fortnum & Mason Awards Site"
#components: ["Nginx"]
#hosts: ["rb-prod-01"]
#notified-users: ["Joe Stanton", "Stuart Harris"]
#root-cause: "File descriptor limit exceeded."

module.exports = React.create-class do
  displayName: "Incidents"
  getInitialState: ->
    open: []
    resolved: []

  render: ->
    {open, resolved} = @props.incidents |> group-by (.status)
    return div null, "Loading" unless open and resolved
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
  format-date: (date) ->
    "#{moment(date).format 'Do MMMM YYYY - h:mmA'} (#{moment(date).from-now!})"

  render: ->
    div className: "incident",
      h2 null, "Incident ##{@props.id} - #{@props.service.name}"
      dl id: "summary",
        dt null, 'Service Status'
        dd null, 'DOWN'
        dt null, 'Started'
        dd null, @format-date @props.created_at
        dt null, 'Notified Users'
        dd null, @props.notified-users?.join ', '
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
