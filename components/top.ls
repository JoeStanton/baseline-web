React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM

module.exports = React.create-class do
  render: ->
    div id: "top",
      h1 null,
        a className: "active", "Lighthouse"
      ul id: "navigation",
        li null,
          a href: "/", "Dashboard"
        li null,
          a href: "/incidents", "Incidents"
        li null,
          a href: "/", "Events"
        #li null,
          #a href: "/", "Metrics"
        #li null,
          #a href: "/", "Logs"
        #li null,
          #a href: "/", "Settings"
