_ = require('underscore')
grunt = require('grunt')
GeneratesHtml = require('./../lib/generates_html')
GeneratesRss = require('./../lib/generates_rss')
Layout = require('./../lib/layout')
Pages = require('./../lib/pages')
Posts = require('./../lib/posts')
Site = require('./../lib/site')
WritesFile = require('./../lib/writes_file')

module.exports = class MarkdownTask
  constructor: (@config) ->
    @writesFile = new WritesFile(@config.dest)
    @posts = new Posts @_allMarkdownPosts(),
      htmlDir: @config.pathRoots.posts
      dateFormat: @config.dateFormat
    @pages = new Pages @_allMarkdownPages(),
      htmlDir: @config.pathRoots.pages
    @site = new Site(@config, @posts, new Layout(@config.layouts.post))
    @site.addPages @pages
    @wrapper = new Layout(@config.layouts.wrapper, @config.context)

  run: ->
    @posts.writeHtml(new GeneratesHtml(@site, @wrapper, new Layout(@config.layouts.post)), @writesFile)
    @pages.writeHtml(new GeneratesHtml(@site, @wrapper, new Layout(@config.layouts.page)), @writesFile)
    @createIndex()
    @createArchive()
    @createRss()

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

  #private
  _allMarkdownPosts: ->
    if @config.paths.markdown? #backwards compatibility for lineman blog
      grunt.file.expand(@config.paths.markdown)
    else
      grunt.file.expand(@config.paths.posts)

  _allMarkdownPages: -> grunt.file.expand(@config.paths.pages)
