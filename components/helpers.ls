exports.status-to-colour = (status) ->
  switch status
    case "ok" then "green"
    case "warning" then "yellow"
    case "error" then "red"
    default then "grey"
