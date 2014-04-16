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
      div null, @props.events.map (event) ->
        switch event.type
          | "CheckEvent" => CheckEvent event
          | "Deployment" => Deployment event
          | "Configuration" => Configuration event
          | "HostEvent" => HostRegistration event
          | otherwise => Event event

Event = React.create-class do
  displayName: "Event"
  render: -> div null

CheckEvent = React.create-class do
  displayName: "CheckEvent"
  render: ->
    div className: "event",
      h2 null, "#{@props.service_name} - Check #{@props.status}"
      if @props.host
        strong null, "Host #{@props.host.hostname} changed state to: #{@props.status}"
      else if @props.component
        strong null, "#{@props.service_name} - #{@props.component_name} changed state to: #{@props.status}"
      else
        strong null, "#{@props.service_name} changed state to: #{@props.status}"

Configuration = React.create-class do
  displayName: "ConfigurationEvent"
  render: ->
    h2 null, "#{@props.service} - Reconfiguration"

Deployment = React.create-class do
  displayName: "DeploymentEvent"
  render: ->
    div className: "event row",
      div className: "type col-xs-2",
        h3 null,
          div null, "Deployment"
          small null, relative-time @props.created_at
      dl className: "dl-horizontal col-xs-5 left" id: "summary",
        div null,
          dt null, "Repo"
          dd null, @props.repo
          dt null, "Build"
          dd null,
            a href: @props.url, @props.message
            i className: "fa fa-github"
          dt null, "Branch"
          dd null, @props.branch
      dl className: "dl-horizontal col-xs-5 details",
          dt null, "Author"
          dd null, @props.author
          dt null, "Hosts"
          dd null, @props.hostname

HostRegistration = React.create-class do
  displayName: "HostRegistrationEvent"
  render: ->
    div null,
      register = @props.type is "host-register"
      h2 null, "#{@props.service} - Node \"#{@props.hosts}\" #{if register then "Registered" else "Deregistered"}"
      dl className: "dl-horizontal" id: "summary",
        dt null, "Hostname"
        dd null, @props.hosts
        dt null, "Environment"
        dd null, @props.environment
        dt null, "Status"
        dd null, "Healthy"
