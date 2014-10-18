pathlib = require('path')

module.exports = class Path
  constructor: (path) ->
    @path = pathlib.normalize(path)

  basename: ->
    pathlib.basename(@path, @extname())

  dirname: ->
    pathlib.dirname(@path)

  extname: ->
    pathlib.extname(@path)

  filename: ->
    pathlib.basename(@path)

  toString: ->
    @path
