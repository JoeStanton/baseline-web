React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{svg, g, circle, text} = React.DOM

d3 = require "d3"

{status-to-colour} = require './helpers.ls'

module.exports = React.create-class do
  render: ->
    svg width: 1100 height: 800

  shouldComponentUpdate: -> false

  componentDidMount: ->
    @force = d3.layout.force!
             .nodes @props.nodes
             .links @props.edges
             .size [1100, 700]
             .linkDistance 400
             .charge -150

    @root = d3.select @get-DOM-node!
    @paint!

    @force.on "tick", (e) ~>
      @root.selectAll("g")
           .attr "transform", (d) -> "translate(#{[d.x, d.y]})"

      @root.selectAll(".link")
           .attr "d", (d) ->
              deltaX = d.target.x - d.source.x
              deltaY = d.target.y - d.source.y
              dist = Math.sqrt(deltaX * deltaX + deltaY * deltaY)
              normX = deltaX / dist
              normY = deltaY / dist
              sourcePadding = 12
              targetPadding = 14
              sourceX = d.source.x + (sourcePadding * normX)
              sourceY = d.source.y + (sourcePadding * normY)
              targetX = d.target.x - (targetPadding * normX)
              targetY = d.target.y - (targetPadding * normY)
              "M" + sourceX + "," + sourceY + "L" + targetX + "," + targetY

  paint: ->
    data = @root.selectAll "g"
                  .data @force.nodes!

    @root.append("svg:defs")
         .append("svg:marker")
         .attr("id", "arrow")
         .attr("viewBox", "0 -5 10 10")
         .attr("refX", 6)
         .attr("markerWidth", 10)
         .attr("markerHeight", 10)
         .attr("orient", "auto")
         .append("svg:path")
         .attr("d", "M0,-5L10,0L0,5")
         .attr "fill", "#000"

    links = @root.selectAll ".link"
                 .data @force.links!
                 .enter!
                 .append "svg:path"
                 .attr "class", "link"
                 .style "stroke", "#999"
                 .style "stroke-width", (d) -> Math.sqrt d.value
                 .style "marker-end", -> 'url(#arrow)'

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
