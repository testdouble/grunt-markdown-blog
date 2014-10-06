grunt = require('grunt')
pathlib = require('./maybe_path_lib.coffee')

module.exports = class WritesFile
  constructor: (@dest) ->

  write: (content, filePath) ->
    path = pathlib.join(@dest, filePath)
    grunt.log.writeln("Writing #{content.length} characters to #{path}")
    grunt.file.write(path, content)
