React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{svg, g, circle, text} = React.DOM

d3 = require "d3"

module.exports = React.create-class do
  render: ->
    svg width: 1000 height: 600

  shouldComponentUpdate: -> false

  componentDidMount: ->
    @force = d3.layout.force!
             .nodes @props.nodes
             .links @props.edges
             .size [1000, 600]
             .linkDistance 400
             .charge -100

    @root = d3.select @get-DOM-node!
    @paint!

    @force.on "tick", (e) ~>
      @root.selectAll("g").attr "transform", (d) -> "translate(#{[d.x, d.y]})"

  paint: ->
    data = @root.selectAll "g"
                  .data @force.nodes!

    groups = data.enter!
                 .append "g"

    groups.append "circle"
          .attr "r", 12
          .attr "class", "node"

    groups.append "text"
          .attr 'x', 20
          .text (d) -> d.name

    groups.call @force.drag

    data.exit!
        .remove!

    @force.start!

  componentWillReceiveProps: (newProps) ->
    return if newProps.nodes.length === @props.nodes.length
    @force.nodes newProps.nodes
    @paint!
