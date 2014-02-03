grunt = require('grunt')

module.exports = class NullLayout
  constructor: (@layoutPath) ->

  htmlFor: ->
    if @layoutPath?
      grunt.warn "Unable to read '#{@layoutPath}' file"
    else
      grunt.log.error "Destination not written because source template is undefined"
