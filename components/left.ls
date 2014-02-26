React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM

Service = require "./service.ls"

module.exports = React.create-class do
  render: ->
    div id: "left",
      div id: "search_box",
        input placeholder: "Search all..." type: "text"
      div className: "tab"
        ul id: "repos",
          @props.services.map (s) -> new Service key: s.id, service: s
