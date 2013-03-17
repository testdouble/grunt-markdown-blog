###
Task: markdown
Description: generates HTML files from markdown files for static deployment
Dependencies: grunt, marked
Contributor: @searls
###

marked = require('marked')
_ = require('underscore')
fs = require('fs')
highlight = require('highlight.js')
grunt = require('grunt')

marked.setOptions
  highlight: (code, lang) ->
    highlighted = if highlight.LANGUAGES[lang]?
      highlight.highlight(lang, code, true)
    else
      highlight.highlightAuto(code)
    highlighted.value


module.exports = (grunt) ->
  grunt.registerMultiTask "markdown", "generates HTML from markdown", ->
    config = _(
      title: "my blog"
      layouts:
        wrapper: "app/templates/wrapper.us"
        index: "app/templates/index.us"
        post: "app/templates/post.us"
        archive: "app/templates/archive.us"
      paths:
        markdown: "app/posts/*.md"
        posts: "posts"
        index: "index.html"
        archive: "archive.html"
      dest: "dist"
      context:
        js: "app.js"
        css: "app.css"
    ).extend(@options(@data))
    new MarkdownTask(config).run()

class MarkdownTask
  constructor: (@config) ->
    @wrapper = new Layout(@config.layouts.wrapper, @config.context)
    @writesHtml = new WritesHtml(@config.dest)
    @posts = @buildPosts()

  run: ->
    @createPosts()
    @createIndex()
    @createArchive()

  createPosts: ->
    generatesHtml = new GeneratesPostHtml(@wrapper, new Layout(@config.layouts.post), @config.title)
    _(@posts).each (post) =>
      html = generatesHtml.generate(post)
      @writesHtml.write(html, post.htmlPath())

  createIndex: ->
    html = new GeneratesPostsHtml(@wrapper, new Layout(@config.layouts.index), @config.title).
      generate(@posts)
    @writesHtml.write(html, @config.paths.index)

  createArchive: ->
    html = new GeneratesPostsHtml(@wrapper, new Layout(@config.layouts.archive), @config.title).
      generate(@posts)
    @writesHtml.write(html, @config.paths.archive)

  buildPosts: ->
    markdownPaths = @allMarkdownPosts() #if @anyLayoutsChanged() then @allMarkdownPosts() else @workingFiles()
    _(markdownPaths).chain().
      reject((p) -> p.match(/\.us$/) != null). #<--sometimes the underscore layouts are in .changed
      map (markdownPath) =>
        new Post(markdownPath, @config.paths.posts)

  #private

  # workingFiles: -> @_workingFiles ||= grunt.file.expand(grunt.file.watchFiles?.changed || @config.paths.markdown)

  allMarkdownPosts: -> grunt.file.expand(@config.paths.markdown)

  # anyLayoutsChanged: -> _(@workingFiles()).any((p) -> p.match(/\.us$/) != null)


class GeneratesPostHtml
  constructor: (@wrapper, @post, @title) ->

  generate: (post) ->
    @wrapper.htmlFor
      title: "#{@title} - #{post.title()}"
      content: @post.htmlFor({post})

class GeneratesPostsHtml
  constructor: (@wrapper, @index, @title) ->

  generate: (posts) ->
    @wrapper.htmlFor
      title: @title
      content: @index.htmlFor({posts})

class WritesHtml
  constructor: (@dest) ->

  write: (html, filePath) ->
    path = "#{@dest}/#{filePath}"
    grunt.log.writeln("Writing #{html.length} characters of html to #{path}")
    grunt.file.write(path, html)

class Layout
  constructor: (layoutPath, context = {}) ->
    @layout = _(grunt.file.read(layoutPath)).template()
    @context = context

  htmlFor: (title, content) ->
    @layout(_(@context).extend(title, content))

class Post
  constructor: (@path, @htmlDirPath) ->

  content: ->
    source = grunt.file.read(@path)
    markdown = _(source).template({})
    content = marked.parser(marked.lexer(markdown))

  title: ->
    dasherized = @path.match(/\/\d{4}-\d{2}-\d{2}-([^/]*).md/)?[1]
    title = dasherized?.replace(/-/g, " ")
    title || @fileName()

  htmlPath: ->
    "#{@htmlDirPath}/#{@fileName()}"

  fileName: ->
    name = @path.match(/\/([^/]*).md/)?[1]
    "#{name}.html"
