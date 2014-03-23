React = window.React = require "react/addons" # Expose for Chrome DevTools
{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM

api = require "./api.ls"

Top = require "./top.ls"
Left = require "./left.ls"

{TransitionGroup} = React.addons

module.exports = React.create-class do
  displayName: "Layout"
  getInitialState: ->
    services: []

  sync: ->
    api.get "/services/", (error, services) ~>
      return console.error error if error
      @setState services: services

    return unless @props.children
    new Array(@props.children).forEach (c) -> c.sync? && c.sync!

  componentWillMount: -> @sync!

  render: ->
    div className: "application",
      Top null
      Left services: @state.services
      div id: "main",
        TransitionGroup transition-name: "page-transition",
          @props.children
