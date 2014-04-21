React = require "react/addons"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{table, thead, tbody, th, td, tr} = React.DOM
{strong, dl, dt, dd} = React.DOM

moment = require 'moment'
{find, group-by} = require 'prelude-ls'

{format-date} = require './helpers.ls'
api = require './api.ls'

#service: "Fortnum & Mason Awards Site"
#components: ["Nginx"]
#hosts: ["rb-prod-01"]
#notified-users: ["Joe Stanton", "Stuart Harris"]
#root-cause: "File descriptor limit exceeded."

module.exports = React.create-class do
  displayName: "Incidents"
  render: ->
    active = find (.status == "open"), @props.incidents
    div null,
      if active
        Incident active
      else
        if @props.incidents.length
          @props.incidents.map Incident
        else
          "No incidents have been detected yet."

Incident = React.create-class do
  displayName: "Incident"
  mixins: [React.addons.LinkedStateMixin]
  getInitialState: ->
    root-cause: @props.root_cause || ""
    loading: false
    selected: @props.selected || "recent"
  submit: ->
    root = @
    root.set-state loading: true
    api.put "/incidents/#{@props.id}", incident: root_cause: @state.root-cause, (error) ->
      alert 'Could not save root cause.' if error
      root.set-state loading: false
  render: ->
    div className: "incident clearfix",
      h2 null, "Incident ##{@props.id}"
      dl className: "dl-horizontal col-xs-6" id: "summary",
        dt null, 'Service Status'
        dd null, @props.service.status
        dt null, 'Started'
        dd null, format-date @props.created_at
        dt null, 'Notified Users'
        dt null, 'Hosts'
        dd null, @props.hosts.join ', '
        dt null, 'Affected Components'
        dd null, @props.components.join ', '
        dt null, 'Predicted Root Cause'
        dd null, @props.predicted_root_cause
      if @props.status == 'open'
        form className: "col-xs-6 form root-cause",
          div className: "form-group",
            label html-for: "root-cause", "Root Cause Analysis"
            textarea className: "form-control" name: "root-cause", value-link: @link-state('rootCause')
            a className: "btn btn-success pull-right", disabled: @state.loading, onClick: @submit, "Save"
      @related! if @props.status == 'open'

  active: (view) -> if view == @state.selected then "active" else ""

  related: ->
    div className: "clearfix",
      ul className: "nav tabs",
        li null, a className: "#{@active "recent"}" href: "#", "Recent Events"
        li null, a className: "#{@active "similar"}" href: "#", "Similar Incidents"
      switch @state.selected
        | "related" =>
            EventsTable events: [
              type: "Deployment"
              date: 'Fri 14th March - 10:30PM (10 days ago)'
              hosts: "rb-prod-01"
            ]
        | "recent" =>
            IncidentsTable incidents: [
              components: ["Nginx"]
              date: 'Fri 14th March - 10:30PM (10 days ago)'
              resolution-time: '10 minutes'
              resolved-by: 'Stuart Harris'
              root-cause: "File descriptor limit exceeded. Caused intermittent failed requests."
            ]

EventsTable = React.create-class do
  displayName: "EventsTable"
  render: ->
    table className: "table",
      thead null,
        th null, "Event Type"
        th null, "Date"
        th null, "Hosts"
      tbody null,
        @props.events.map (event) ->
          tr className: "related-event",
           td null, event.type
           td null, event.date
           td null, event.hosts

IncidentsTable = React.create-class do
  displayName: "IncidentsTable"
  render: ->
    table className: "table",
      thead null,
        th null, "Component"
        th null, "Date"
        th null, "Resolution Time"
        th null, "Resolved by"
        th null, "Root Cause"
      tbody null,
        @props.incidents.map (incident) ->
          tr className: "related-incident",
           td null, incident.components.join ', '
           td null, incident.date
           td null, incident.resolution-time
           td null, incident.resolved-by
           td null, incident.root-cause || "Unknown"
