React = window.React = require "react/addons" # Expose for Chrome DevTools
{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{nav, main, footer} = React.DOM

api = require "./api.ls"

Top = require "./top.ls"
Left = require "./left.ls"

async = require 'async'

{TransitionGroup} = React.addons

merge = ->
  obj = {}
  i = 0
  il = arguments.length
  key = undefined
  while i < il
    for key of arguments[i]
      obj[key] = arguments[i][key] if arguments[i].hasOwnProperty(key)
    i++
  obj

module.exports = React.create-class do
  displayName: "Layout"
  getDefaultProps: ->
    handler: null
    options: {}

  getInitialState: ->
    services: []
    incidents: []
    events: []
    loaded: false

  sync: ->
    async.parallel do
      services: (cb) -> api.get "/services/", cb
      incidents: (cb) -> api.get "/incidents/", cb
      events: (cb) -> api.get "/events/", cb
      , (error, state) ~>
        return console.error error if error
        @setState merge(state, loaded: true)

  componentWillMount: -> @sync!

  render: ->
    div className: "application",
      Top services: @state.services
      main className: "container",
        @props.handler merge(@state, @props.options) if @props.handler and @state.loaded
      Footer null

Footer = React.create-class do
  render: ->
    footer null,  "© Joe Stanton 2014"
