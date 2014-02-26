React = window.React = require "react" # Expose for Chrome DevTools
{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM

Layout = require "./layout.ls"
api = require "./api.ls"

Top = require "./top.ls"
Left = require "./left.ls"

module.exports = React.create-class do
  getInitialState: ->
    service: null

  componentDidMount: -> @sync @props.slug
  componentWillReceiveProps: (next) -> @sync next.slug

  sync: (slug) ->
    api.get "/services/#{slug}", (error, service) ~>
      return console.error error if error
      @setState service: service

  render: ->
    return div null, "Loading..." unless @state.service
    h1 null, @state.service.name
