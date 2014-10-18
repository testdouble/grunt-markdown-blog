_ = require('underscore')
grunt = require('grunt')
Markdown = require('./markdown')
Path = require('./path')

module.exports = class Page
  constructor: (srcPath, destPath) ->
    @path = new Path(destPath)
    @_markdown = new Markdown(grunt.file.read(srcPath))
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
