React = window.React = require "react" # Expose for Chrome DevTools
{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM

api = require "./api.ls"

Top = require "./top.ls"
Service = require "./service.ls"

Left = React.create-class do
  render: ->
    div id: "left",
      div id: "search_box",
        input placeholder: "Search all..." type: "text"
      div className: "tab"
        ul id: "repos",
          @props.services.map (s) -> new Service service: s

module.exports = React.create-class do
  getInitialState: ->
    services: []

  sync: ->
    api.get "/services/", (error, services) ~>
      return console.error error if error
      @setState services: services

  componentWillMount: -> @sync!

  render: ->
    div className: "application",
      new Top
      Left services: @state.services
      @props.children
