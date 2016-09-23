highlight = require('highlight.js')
marked = require('marked')
MarkdownSplitter = require('./markdown_splitter')

options =
  highlight: (code, lang) ->
    highlighted = if highlight.listLanguages()[lang]?
      highlight.highlight(lang, code, true)
    else
      highlight.highlightAuto(code)
    highlighted.value

module.exports = class Markdown
  constructor: (fullSource) ->
    {@header, markdown: @source} = new MarkdownSplitter().split(fullSource)

  compile: ->
    marked(@source, options)
