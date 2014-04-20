React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM

api = require "./api.ls"
Graph = require "./graph.ls"

{map, concat-map, flatten} = require 'prelude-ls'

module.exports = React.create-class do
  render: ->
    service = @props.services.1
    nodes = flatten [service, service.components]

    lookup = {}
    nodes.forEach (c, index) -> lookup[c.slug] = index

    edges = nodes
            |> map(({slug, dependencies}) -> map ((dep) -> source: lookup[slug], target: lookup[dep], weight: 1), dependencies)
            |> flatten

    h1 null, "Dashboard"
    Graph nodes: nodes, edges: edges
