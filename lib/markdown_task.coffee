_ = require('underscore')
grunt = require('grunt')
GeneratesHtml = require('./../lib/generates_html')
GeneratesRss = require('./../lib/generates_rss')
Layout = require('./../lib/layout')
Page = require('./../lib/page')
Post = require('./../lib/post')
Site = require('./../lib/site')
WritesFile = require('./../lib/writes_file')

module.exports = class MarkdownTask
  constructor: (@config) ->
    @writesFile = new WritesFile(@config.dest)
    @site = new Site(@config, @buildPosts(), new Layout(@config.layouts.post))
    @site.addPages(@buildPages(), new Layout(@config.layouts.page)) if @generatePages()
    @wrapper = new Layout(@config.layouts.wrapper, @config.context)

  run: ->
    @createPosts()
    if @generatePages()
      @createPages()
    @createIndex()
    @createArchive()
    @createRss()

  generatePages: ->
    @config.layouts.page? && grunt.file.exists(@config.layouts.page)

  createPosts: ->
    generatesHtml = new GeneratesHtml(@wrapper, new Layout(@config.layouts.post), @site)
    _(@site.posts).each (post) =>
      html = generatesHtml.generate(post)
      @writesFile.write(html, post.htmlPath())

  createPages: ->
    generatesHtml = new GeneratesHtml(@wrapper, new Layout(@config.layouts.page), @site)
    _(@site.pages).each (page) =>
      html = generatesHtml.generate(page)
      @writesFile.write(html, page.htmlPath())

  createIndex: ->
    post = _(@site.posts).last()
    html = new GeneratesHtml(@wrapper, new Layout(@config.layouts.index), @site).generate(post)
    @writesFile.write(html, @config.paths.index)

  createArchive: ->
    html = new GeneratesHtml(@wrapper, new Layout(@config.layouts.archive), @site).generate()
    @writesFile.write(html, @config.paths.archive)

  createRss: ->
    return unless @site.paths.rss? && @site.rssCount
    rss = new GeneratesRss(@site).generate()
    @writesFile.write(rss, @site.paths.rss)

  buildPosts: ->
    _(@allMarkdownPosts()).map (markdownPath) =>
      new Post(markdownPath, @config.pathRoots.posts, @config.dateFormat)

  buildPages: ->
    _(@allMarkdownPages()).map (markdownPath) =>
      new Page(markdownPath, @config.pathRoots.pages)

  #private
  allMarkdownPosts: ->
    if @config.paths.markdown? #backwards compatibility for lineman blog
      grunt.file.expand(@config.paths.markdown)
    else
      grunt.file.expand(@config.paths.posts)

  allMarkdownPages: -> grunt.file.expand(@config.paths.pages)
