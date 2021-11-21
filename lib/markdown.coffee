highlighter = require('highlight.js')
marked = require('marked')
MarkdownSplitter = require('./markdown_splitter')

marked.setOptions
  langPrefix: "hljs language-"
  smartypants: true
  highlight: (code, lang) ->
    if highlighter.listLanguages().includes(lang.toLowerCase())
      return highlighter.highlight(code, { language: lang }).value
    else
      return highlighter.highlightAuto(code).value

module.exports = class Markdown
  constructor: (fullSource, compiler = marked, splitter = MarkdownSplitter) ->
    @compiler = compiler
    @splitter = new splitter()
    {@header, markdown: @source} = @splitter.split(fullSource)

  compile: ->
    @compiler.parse(@source)
