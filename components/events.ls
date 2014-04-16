React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{table, thead, tbody, th, td, tr} = React.DOM
{strong, dl, dt, dd, hr} = React.DOM

{status-to-colour, format-date} = require './helpers.ls'

display-type = (type) ->
  switch type
    | "CheckEvent" => "Health Check"

module.exports = React.create-class do
  displayName: "Events"
  render: ->
    div null,
      h1 null, 'Recent Events'
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
    div null,
      h2 null, "#{@props.service_name} - Deployment "
      span className: "big-text", format-date @props.created_at
      dl className: "dl-horizontal" id: "summary",
        div className: "left",
          dt null, "Repo"
          dd null, @props.repo
          dt null, "Branch"
          dd null, @props.branch
          dt null, "Build"
          dd null,
            a href: @props.url, @props.message
        div className: "right",
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
