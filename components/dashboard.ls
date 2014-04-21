React = require "react"

{div, span, p, a, img, ul, li} = React.DOM
{h1, h2, h3, h4}               = React.DOM
{form, label, input, textarea} = React.DOM
{small, em, pre} = React.DOM

api = require "./api.ls"
Graph = require "./graph.ls"

module.exports = React.create-class do
  render: ->
    div null,
      h1 null,
       span null, "Welcome to Baseline"
       small null, " follow the steps below to get started"
      h3 null, "Step 1 - Install"
      p null, "Install the management agent on your development workstation:"
      pre null, "curl -s #{process.env.API}/agent/install | bash"
      small null, "Baseline supports Mac OS X and Linux hosts, and bundles Ruby 2.0"
      h3 null, "Step 2 - Discover"
      p null, "Create a service definition, using auto-discovery:"
      pre null, "baseline-agent discover <service-name>"
      h3 null, "Step 3 - Push"
      p null, "Push the service definition to Baseline:"
      pre null, "baseline-agent push <service-name>.rb"
      h3 null, "Step 4 - Monitor"
      p null, "Start real-time, continuous monitoring:"
      pre null, "baseline-agent start <service-name>.rb"
      h3 null, "Step 5 - View"
      p null, "Select your service dashboard from the top navigation menu, and view real-time status checks and service architecture diagrams."
