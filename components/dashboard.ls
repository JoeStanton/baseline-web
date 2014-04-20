React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM

api = require "./api.ls"
Graph = require "./graph.ls"

module.exports = React.create-class do
  render: ->
    service = @props.services.1
    h1 null, "Dashboard"
    Graph service: service
