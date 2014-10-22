_ = require('underscore')
_.mixin(require('underscore.string').exports())
grunt = require('grunt')

module.exports = class Layout
  constructor: (@layoutPath, context = {}) ->
    @layout = _(grunt.file.read(@layoutPath)).template()
    @context = context

  htmlFor: (specificContext) ->
    @layout(_({}).extend(@context, specificContext))
