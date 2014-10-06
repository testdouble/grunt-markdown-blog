pathlib = require('path')

module.exports =
  join: (one, two) ->
    if one? and two? and typeof one == 'string' and typeof two == 'string'
      pathlib.join(one, two)
    else
      one || two