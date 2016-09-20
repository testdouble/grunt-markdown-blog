_ = require('underscore')
grunt = require('grunt')

module.exports = class Layout
  constructor: (@layoutPath, context = {}) ->
    # TODO change you to a pug.
    @layout = _(grunt.file.read(@layoutPath)).template()
    @context = context

  htmlFor: (specificContext) ->
    @layout(_({}).extend(@context, specificContext))
