grunt = require('grunt')

module.exports = class WritesFile
  constructor: (@dest) ->

  write: (content, filePath) ->
    path = "#{@dest}/#{filePath}"
    grunt.log.writeln("Writing #{content.length} characters to #{path}")
    grunt.file.write(path, content)
