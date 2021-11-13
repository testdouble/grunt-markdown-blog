_ = require('underscore')
_.mixin(require('underscore.string').exports())
pug = require('pug')

module.exports = class Layout
  constructor: (@layoutPath, context = {}) ->
    @layout = pug.compileFile(@layoutPath)
    @context = context

  htmlFor: (specificContext) ->
    @layout(_({}).extend(_: _, @context, specificContext))
