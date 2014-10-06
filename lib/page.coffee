_ = require('underscore')
grunt = require('grunt')
highlight = require('highlight.js')
marked = require('marked')
pathlib = require('path')
MarkdownSplitter = require('./markdown_splitter')

marked.setOptions
  highlight: (code, lang) ->
    highlighted = if highlight.LANGUAGES[lang]?
      highlight.highlight(lang, code, true)
    else
      highlight.highlightAuto(code)
    highlighted.value

module.exports = class Page
  constructor: (@htmlDir, @path, @dateFormat) ->
    source = grunt.file.read(@path)
    splitted = new MarkdownSplitter().split(source)
    @markdown = splitted.markdown
    @attributes = splitted.header

  content: ->
    marked.parser(marked.lexer(@markdown))

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
    # the path as far as html is concerned
    # 1. remove the @htmlDir
    # 2. Strip starting slash /
    # 3. Swap .md for .html
    # 4. Remove index.html if that's how it ends, we don't need that jazz
    @path.replace(new RegExp("^#{@htmlDir}"), "").replace(/^\//, "").replace(/\.md$/, ".html").replace(/index\.html$/, "")

  diskPath: ->
    # the path where the file is on disk
    @path.replace(/\.md$/, ".html")

  fileName: ->
    name = @path.match(/\/([^/]*).md/)?[1]
    "#{name}.html"

  date: ->
    undefined
