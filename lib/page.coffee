_ = require('underscore')
grunt = require('grunt')
Markdown = require('./markdown')

module.exports = class Page
  constructor: ({src, dest}) ->
    @path = dest
    @_markdown = new Markdown(grunt.file.read(src))
    @_attributes = @_markdown.header
    @markdown = @_markdown.source #back-compat

  content: ->
    @_markdown.compile()

  get: (name) ->
    _(@_attributes).result(name)

  title: ->
    @get('title') || titleFromPath(@path) || @path.basename()

titleFromPath = (path) ->
  path.basename().match(/\d{4}-\d{2}-\d{2}-([^/]*)/)?[1]?.replace(/-/g, " ")
