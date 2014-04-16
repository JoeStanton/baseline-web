exports.status-to-colour = (status) ->
  switch status
    case "ok" then "green"
    case "warning" then "yellow"
    case "error" then "red"
    default then "grey"

moment = require 'moment'
exports.format-date = (date) ->
  "#{moment(date).format 'Do MMMM YYYY - h:mmA'} (#{moment(date).from-now!})"

exports.relative-time = (date) -> moment(date).from-now!

exports.format-duration = (seconds) ->
  return "Unknown" unless seconds
  moment.duration(seconds, 'seconds').humanize!
