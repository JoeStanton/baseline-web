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
        @props.services.map (s) ->
          a href: "/#{s.slug}/", li null, s.name
