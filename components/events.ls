React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{table, thead, tbody, th, td, tr} = React.DOM
{strong, dl, dt, dd, hr} = React.DOM

module.exports = React.create-class do
  displayName: "Events"
  getInitialState: ->
    events: [
    * type: "deployment"
      service: "Fortnum & Mason Awards Site"
      environment: "Staging"
      components: ["Application"]
      hosts: ["rb-staging-01"]

    * type: "configuration"
      service: "Fortnum & Mason Awards Site"
      components: ["Nginx"]
      hosts: ["rb-prod-01"]

    * type: "host-register"
      service: "Fortnum & Mason Awards Site"
      environment: "Production"
      hosts: ["rb-prod-01"]
      components: ["Redis"]
    ]

  sync: ->
    api.get '/events/', (error, events) ~>
      return console.error error if error
      @setState events: events

  render: ->
    h1 null, 'Recent Events'
    div null, @state.events.map (event) ->
      switch event.type
        | "deployment" => Deployment event
        | "configuration" => Configuration event
        | "host-register" => HostRegistration event
        | "host-deregister" => HostRegistration event
        | otherwise => Event event

Event = React.create-class do
  displayName: "Event"
  render: -> div null

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
