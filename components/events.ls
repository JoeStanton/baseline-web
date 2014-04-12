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
      table className: "list",
        thead null,
          th null, "Status"
          th null, "Event Type"
          th null, "Message"
          th null, "Created At"
          th null, "Service"
          th null, "Component"
          th null, "Host"
        tbody null,
          @props.events.map (event) ->
            tr className: "related-event host #{status-to-colour event.status}",
              td className: "number",
                span className: "status"
                  a null, event.status || "Unknown"
              td null, display-type(event.type)
              td null, event.message
              td null, format-date(event.created_at)
              td null, event.service?.name
              td null, event.component?.name
              td null, event.host?.hostname

#div null, @props.events.map (event) ->
  #switch event.type
    #| "CheckEvent" => CheckEvent event
    #| "deployment" => Deployment event
    #| "configuration" => Configuration event
    #| "host-register" => HostRegistration event
    #| "host-deregister" => HostRegistration event
    #| otherwise => Event event

Event = React.create-class do
  displayName: "Event"
  render: -> div null

CheckEvent = React.create-class do
  displayName: "CheckEvent"
  render: ->
    div className: "event",
      if @props.host
        strong null, "Host #{@props.host.hostname} changed state to: #{@props.status}"
      else if @props.component
        strong null, "#{@props.service.name} - #{@props.component.name} changed state to: #{@props.status}"
      else
        strong null, "#{@props.service.name} changed state to: #{@props.status}"

Configuration = React.create-class do
  displayName: "ConfigurationEvent"
  render: ->
    h2 null, "#{@props.service} - Reconfiguration"

Deployment = React.create-class do
  displayName: "DeploymentEvent"
  render: ->
    div null,
      h2 null, "#{@props.service} - #{@props.environment} Deployment"
      dl id: "summary",
        dt null, "Repo"
        dd null, "redbadger/fm-food-awards"
        dt null, "Branch"
        dd null, "master"
        dt null, "Author"
        dd null, "Joe Stanton"
        dt null, "Build"
        dd null,
          a href: "http://github.com",
            "Merge pull request #5 from redbadger/develop (6bffc68)"
        dt null, "Hosts"
        dd null, @props.hosts.join ", "

HostRegistration = React.create-class do
  displayName: "HostRegistrationEvent"
  render: ->
    div null,
      register = @props.type is "host-register"
      h2 null, "#{@props.service} - Node \"#{@props.hosts}\" #{if register then "Registered" else "Deregistered"}"
      dl id: "summary",
        dt null, "Hostname"
        dd null, @props.hosts
        dt null, "Environment"
        dd null, @props.environment
        dt null, "Components"
        dd null, @props.components.join ", "
        dt null, "Status"
        dd null, "Healthy"
