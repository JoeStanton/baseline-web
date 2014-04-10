request = require "superagent"
merge = require "merge"

exports.base_url = process.env.API || "https://api.baseline.local"
exports.metrics_url = "http://monitoring.joestanton.co.uk:8000"

exports.get = (path, callback) ->
  throw new Error("The base_url has not yet been set" + path) unless exports.base_url
  throw new Error("The path specified was not valid: " + path) unless path

  url =  exports.base_url + path

  request.get url
         .set "Accept", "application/json"
         .end (error, response) ->
           callback error, response.body

exports.metrics-query = (query, callback) ->
  throw new Error("The metrics_url has not yet been set" + path) unless exports.metrics_url
  url = "#{exports.metrics_url}/render"

  defaults = format: "json"
  query = merge defaults, query

  request.get url
         .set "Accept", "application/json"
         .query query
         .end (error, response) ->
           callback error, response.body
