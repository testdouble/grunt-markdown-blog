_ = require('underscore')
grunt = require('grunt')
Markdown = require('./markdown')
Path = require('./path')

module.exports = class Page
  constructor: (@path, @htmlDirPath, @dateFormat, @reader = grunt.file) ->
    @markdown = new Markdown(@reader.read(@path))
    @attributes = @markdown.header

  content: ->
    @markdown.compile()

  get: (name) ->
    _(@attributes).result(name)

  title: ->
    @get('title') || titleFromFilename(@path) || @fileName()

  htmlPath: ->
    if @htmlDirPath
      "#{@htmlDirPath}/#{@fileName()}"
    else
      "#{@fileName()}"

  prettyPath: ->
    @htmlPath().replace(/\.html$/, '')

  fileName: ->
    new Path(@path).changeExtTo(".html").filename()

  date: ->
    undefined

titleFromFilename = (path) ->
  new Path(path).basename().match(/\d{4}-\d{2}-\d{2}-([^/]*)/)?[1]?.replace(/-/g, " ")
