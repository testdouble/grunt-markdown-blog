_ = require('underscore')
_.mixin(require('underscore.string').exports())
grunt = require('grunt')
NullLayout = require('./null_layout')

module.exports = class Layout
  constructor: (@layoutPath, context = {}) ->
    return new NullLayout unless @_templateExists()
    @layout = _(grunt.file.read(@layoutPath)).template()
    @context = context

  htmlFor: (specificContext) ->
    @layout(_(@context).extend(specificContext))

  _templateExists: ->
    _.tap grunt.file.exists(@layoutPath), (fileExists) =>
      grunt.warn("Unable to read '#{@layoutPath}' file") if @layoutPath? and !fileExists
