_ = require('underscore')
grunt = require('grunt')

module.exports = class Layout
  constructor: (@layoutPath, context = {}) ->
    @layout = _(grunt.file.read(@layoutPath)).template()
    @context = context

  htmlFor: (specificContext) ->
    @layout(_(@context).extend(specificContext))
