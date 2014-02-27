React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM

api = require "./api.ls"
Graph = require "./graph.ls"

module.exports = React.create-class do
  getInitialState: ->
    nodes: []
    edges: []

  componentWillMount: ->
    api.get '/services/', (error, services) ~>
      @setState nodes: services, edges: []

  render: ->
    h1 null, "Dashboard"
    Graph nodes: @state.nodes, edges: @state.edges
