React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM

api = require "./api.ls"
Graph = require "./graph.ls"

{map, concat-map, flatten} = require 'prelude-ls'

module.exports = React.create-class do
  render: ->
    services = @props.services
    serviceLookup = {}
    services.forEach (s, index) -> serviceLookup[s.slug] = index
    edges = services
            |> map(({slug, dependencies}) -> map ((dep) -> source: serviceLookup[slug], target: serviceLookup[dep], weight: 1), dependencies)
            |> flatten

    h1 null, "Dashboard"
    Graph nodes: services, edges: edges
