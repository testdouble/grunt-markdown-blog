_ = require('underscore')
grunt = require('grunt')
pathlib = require('path')
Markdown = require('./markdown')

module.exports = class Page
  constructor: (@path, @htmlDirPath, @dateFormat) ->
    @_markdown = new Markdown(grunt.file.read(@path))
    @attributes = @_markdown.header

  content: ->
    @_markdown.compile()

  get: (name) ->
    attr = @attributes?[name]
    return unless attr?
    if _(attr).isFunction() then attr() else attr

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
