highlighter = require('highlight.js')
marked = require('marked')
MarkdownSplitter = require('./markdown_splitter')

module.exports = class Markdown
  constructor: (fullSource, compiler = marked, splitter = MarkdownSplitter) ->
    @compiler = compiler
    @splitter = new splitter()
    {@header, markdown: @source} = @splitter.split(fullSource)

  compile: ->
    @compiler(@source, {
      highlight: (code, lang) ->
        highlighted = if highlighter.listLanguages()[lang]?
          highlighter.highlight(lang, code, true)
        else
          highlighter.highlightAuto(code)
        highlighted.value
    })
