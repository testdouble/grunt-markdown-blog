_ = require('underscore')
_.mixin(require('underscore.string').exports())
grunt = require('grunt')
NullLayout = require('./null_layout')

module.exports = class Layout
  constructor: (@layoutPath, context = {}) ->
    return new NullLayout(@layoutPath) unless @_templateExists()
    @layout = _(grunt.file.read(@layoutPath)).template()
    @context = context

  htmlFor: (specificContext) ->
    @layout(_(@context).extend(specificContext))

  _templateExists: ->
    @layoutPath? and grunt.file.exists(@layoutPath)
