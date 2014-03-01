React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{svg, g, circle, text} = React.DOM

d3 = require "d3"

{status-to-colour} = require './helpers.ls'

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
      @root.selectAll("g")
           .attr "transform", (d) -> "translate(#{[d.x, d.y]})"

      @root.selectAll(".link")
           .attr "x1", (d) -> d.source.x
           .attr "y1", (d) -> d.source.y
           .attr "x2", (d) -> d.target.x
           .attr "y2", (d) -> d.target.y

  paint: ->
    data = @root.selectAll "g"
                  .data @force.nodes!

    links = @root.selectAll ".link"
                 .data @force.links!
                 .enter!
                 .append "line"
                 .attr "class", "link"
                 .style "stroke", "#999"
                 .style "stroke-width", (d) -> Math.sqrt d.value

    groups = data.enter!
                 .append "g"

    groups.append "circle"
          .attr "r", 12
          .attr "class", "node"

    groups.append "text"
          .attr 'x', 20
          .text (d) -> d.name

    groups.call @force.drag

    data.attr "class", (d) -> status-to-colour d.status

    data.exit!.remove!

    @force.start!

  componentWillReceiveProps: (newProps) ->
    @force.nodes newProps.nodes
    @force.links newProps.edges
    @paint!
