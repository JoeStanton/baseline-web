React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{table, thead, tbody, th, td, tr} = React.DOM
{strong, dl, dt, dd, hr} = React.DOM
{nav, i, small} = React.DOM

{status-to-colour, relative-time} = require './helpers.ls'

display-type = (type) ->
  switch type
    | "CheckEvent" => "Health Check"

module.exports = React.create-class do
  displayName: "Events"
  render: ->
    div null,
      if @props.events.length
        div null, @props.events.map (event) ->
          switch event.type
            | "Deployment" => Deployment event: event
            | "Configuration" => Configuration event: event
            | "HostEvent" => HostRegistration event: event
            #| otherwise => console.log event
      else
        "No events have been detected yet."

Event = React.create-class do
  displayName: "Event"
  render: ->
    div className: "event row",
      div className: "type col-xs-3",
        h3 null,
          div null, @props.title
          small null, relative-time @props.event.created_at
      @props.children

Deployment = React.create-class do
  displayName: "DeploymentEvent"
  render: ->
    {event} = @props
    Event title: "Deployment" event: event,
      dl className: "dl-horizontal col-xs-5 left" id: "summary",
        div null,
          dt null, "Repo"
          dd null, event.repo
          dt null, "Build"
          dd null,
            a href: event.url, event.message
            i className: "fa fa-github"
          dt null, "Branch"
          dd null, event.branch
      dl className: "dl-horizontal col-xs-4 details",
          dt null, "Author"
          dd null, event.author
          dt null, "Hosts"
          dd null, event.hostname

Configuration = React.create-class do
  displayName: "ConfigurationEvent"
  render: ->
    {event} = @props
    Event title: "Configuration" event: event,
      dl className: "dl-horizontal col-xs-5 left" id: "summary",
        div null,
          dt null, "Description"
          dd null, event.message
          dt null, "Author"
          dd null, event.author
          dt null, "Hosts"
          dd null, event.hostname

HostRegistration = React.create-class do
  displayName: "HostRegistrationEvent"
  render: ->
    {event} = @props
    console.log event
    Event title: "Host Registered" event: event,
      dl className: "dl-horizontal col-xs-5 left" id: "summary",
        div null,
          dt null, "Description"
          dd null, event.message
          dt null, "Author"
          dd null, event.author
          dt null, "Hosts"
          dd null, event.hostname
