React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{svg, g, circle, text} = React.DOM

d3 = require "d3"
dagre = require "dagre-d3"

{status-to-colour} = require './helpers.ls'
{map, concat-map, flatten} = require 'prelude-ls'

module.exports = React.create-class do
  render: ->
    svg width: '100%' height: '100%'

  shouldComponentUpdate: -> false

  componentDidMount: ->
    root-svg = d3.select @get-DOM-node!
    {service} = @props

    g = new dagre.Digraph

    nodes = flatten [service, service.components]
    nodes.for-each (n) -> g.add-node n.slug, label: n.name, status: n.status
    nodes.for-each (source) ->
      source.dependencies.for-each (target) ->
        g.add-edge null, source.slug, target

    renderer = new dagre.Renderer()
    layout = dagre.layout!
                  .node-sep 80

    old-draw-nodes = renderer.draw-nodes!
    renderer.draw-nodes (graph, root) ->
      svg-nodes = old-draw-nodes graph, root
      svg-nodes.attr 'class', (d) -> "node #{status-to-colour g.node(d).status}"
      svg-nodes

    renderer.layout(layout).run g, root-svg

  componentWillReceiveProps: (newProps) ->
    @force.nodes newProps.nodes
    @force.links newProps.edges
    @paint!
