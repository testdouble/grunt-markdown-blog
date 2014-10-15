_ = require('underscore')
grunt = require('grunt')
pathlib = require('path')
Markdown = require('./markdown')

module.exports = class Page
  constructor: (@path, @htmlDirPath, @dateFormat) ->
    @_markdown = new Markdown(grunt.file.read(@path))
    @attributes = @_markdown.header
    deprecateMarkdownProperty(@)

  content: ->
    @_markdown.compile()

  get: (name) ->
    _(@attributes).result(name)

  title: ->
    return @attributes?['title'] if @attributes?['title']?
    dasherized = @path.match(/\/\d{4}-\d{2}-\d{2}-([^/]*).md/)?[1]
    title = dasherized?.replace(/-/g, " ")
    title || @fileName()

  htmlPath: ->
    if @htmlDirPath.match(/\*/) #path contains wildcard use htmldirpath
      pathlib.join(@path.replace('.md', '.html'))
    else
      "#{@htmlDirPath}/#{@fileName()}"

  fileName: ->
    name = @path.match(/\/([^/]*).md/)?[1]
    "#{name}.html"

  date: ->
    undefined

deprecateMarkdownProperty = (page) ->
  Object.defineProperty page, 'markdown',
    get: ->
      grunt.log.error("Page#markdown has been deprecated")
      @_markdown.source
