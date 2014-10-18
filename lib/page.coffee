_ = require('underscore')
grunt = require('grunt')
Markdown = require('./markdown')
Path = require('./path')

module.exports = class Page
  constructor: (@path, @htmlDirPath, @dateFormat) ->
    @_markdown = new Markdown(grunt.file.read(@path))
    @attributes = @_markdown.header
    @markdown = @_markdown.source #back-compat

  content: ->
    @_markdown.compile()

  get: (name) ->
    _(@attributes).result(name)

  title: ->
    @get('title') || titleFromFilename(@path) || @fileName()

  htmlPath: ->
    if @htmlDirPath.match(/\*/) #path contains wildcard use htmldirpath
      new Path(@path).changeExtTo(".html").toString()
    else
      "#{@htmlDirPath}/#{@fileName()}"

  fileName: ->
    new Path(@path).changeExtTo(".html").filename()

  date: ->
    undefined

titleFromFilename = (path) ->
  new Path(path).basename().match(/\d{4}-\d{2}-\d{2}-([^/]*)/)?[1]?.replace(/-/g, " ")
