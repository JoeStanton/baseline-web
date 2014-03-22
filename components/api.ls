$ = require "jquery"

exports.base_url = process.env.API || "https://api.lighthouse.local"

exports.get = (path, callback) ->
  throw new Error("The base_url has not yet been set" + path) unless exports.base_url
  throw new Error("The path specified was not valid: " + path) unless path

  url =  exports.base_url + path

  $.ajax do
    url: url
    dataType: "json"
    headers:
      accept: "application/json"

    success: (data, status, xhr) ->
      callback null, data

    error: callback
