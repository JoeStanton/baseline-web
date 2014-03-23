request = require "superagent"

exports.base_url = process.env.API || "https://api.lighthouse.local"

exports.get = (path, callback) ->
  throw new Error("The base_url has not yet been set" + path) unless exports.base_url
  throw new Error("The path specified was not valid: " + path) unless path

  url =  exports.base_url + path

  request.get url
         .set "Accept", "application/json"
         .end (error, response) ->
           callback error, response.body
