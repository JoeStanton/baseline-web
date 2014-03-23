React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM

api = require "./api.ls"
Graph = require "./graph.ls"

Layout = require "./layout.ls"

{map, concat-map, flatten} = require 'prelude-ls'

module.exports = React.create-class do
  getInitialState: ->
    nodes: []
    edges: []

  componentWillMount: -> @sync!

  sync: ->
    api.get '/services/', (error, services) ~>
      serviceLookup = {}
      services.forEach (s, index) -> serviceLookup[s.slug] = index
      edges = services
              |> map(({slug, dependencies}) -> map ((dep) -> source: serviceLookup[slug], target: serviceLookup[dep], weight: 1), dependencies)
              |> flatten

      @setState nodes: services, edges: edges

  addNode: (node) ->
    @state.nodes.push(name: node, status: "warning")
    @setState @state

  removeNode: (node) ->
    @state.nodes.push(name: node, status: "warning")
    @setState @state

  render: ->
    Layout null,
      h1 null, "Dashboard"
      Graph nodes: @state.nodes, edges: @state.edges
