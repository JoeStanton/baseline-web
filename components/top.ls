React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM

module.exports = React.create-class do
  displayName: "Top"
  render: ->
    div id: "top",
      h1 null,
        a className: "active", "Baseline"
      ul id: "navigation",
        li null,
          a href: "/", "Dashboard"
        @props.services.map (s) ->
          li null,
            a href: "/#{s.slug}", s.name
