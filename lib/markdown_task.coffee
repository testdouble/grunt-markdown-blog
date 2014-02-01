_ = require('underscore')
grunt = require('grunt')
GeneratesHtml = require('./../lib/generates_html')
GeneratesRss = require('./../lib/generates_rss')
Layout = require('./../lib/layout')
Page = require('./../lib/page')
Posts = require('./../lib/posts')
Site = require('./../lib/site')
WritesFile = require('./../lib/writes_file')

module.exports = class MarkdownTask
  constructor: (@config) ->
    @writesFile = new WritesFile(@config.dest)
    @posts = new Posts @_allMarkdownPosts(),
      htmlDir: @config.pathRoots.posts
      dateFormat: @config.dateFormat
    @site = new Site(@config, @posts, new Layout(@config.layouts.post))
    @site.addPages(@buildPages(), new Layout(@config.layouts.page)) if @generatePages()
    @wrapper = new Layout(@config.layouts.wrapper, @config.context)

  run: ->
    @posts.writeHtml(new GeneratesHtml(@site, @wrapper, new Layout(@config.layouts.post)), @writesFile)
    if @generatePages()
      @createPages()
    @createIndex()
    @createArchive()
    @createRss()

  generatePages: ->
    @config.layouts.page? && grunt.file.exists(@config.layouts.page)

  createPages: ->
    generatesHtml = new GeneratesHtml(@site, @wrapper, new Layout(@config.layouts.page))
    _(@site.pages).each (page) =>
      html = generatesHtml.generate(page)
      @writesFile.write(html, page.htmlPath())

  createIndex: ->
    post = _(@site.posts).last()
    html = new GeneratesHtml(@site, @wrapper, new Layout(@config.layouts.index)).generate(post)
    @writesFile.write(html, @config.paths.index)

  createArchive: ->
    html = new GeneratesHtml(@site, @wrapper, new Layout(@config.layouts.archive)).generate()
    @writesFile.write(html, @config.paths.archive)

  createRss: ->
    return unless @site.paths.rss? && @site.rssCount
    rss = new GeneratesRss(@site).generate()
    @writesFile.write(rss, @site.paths.rss)

  buildPages: ->
    _(@_allMarkdownPages()).map (markdownPath) =>
      new Page(markdownPath, @config.pathRoots.pages)

  #private
  _allMarkdownPosts: ->
    if @config.paths.markdown? #backwards compatibility for lineman blog
      grunt.file.expand(@config.paths.markdown)
    else
      grunt.file.expand(@config.paths.posts)

  _allMarkdownPages: -> grunt.file.expand(@config.paths.pages)
