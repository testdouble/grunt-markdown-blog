grunt = require('grunt')
Archive = require('./../lib/archive')
GeneratesHtml = require('./../lib/generates_html')
GeneratesRss = require('./../lib/generates_rss')
Index = require('./../lib/index')
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
    @index = new Index @posts.latest(),
      htmlPath: @config.paths.index
    @archive = new Archive
      htmlPath: @config.paths.archive
    @site = new Site(@config, @posts, new Layout(@config.layouts.post))
    @site.addPages @pages

  run: ->
    wrapper = new Layout(@config.layouts.wrapper, @config.context)
    generator = (layout) => new GeneratesHtml @site, wrapper, new Layout(layout)

    @posts.writeHtml generator(@config.layouts.post), @writesFile
    @pages.writeHtml generator(@config.layouts.page), @writesFile
    @index.writeHtml generator(@config.layouts.index), @writesFile
    @archive.writeHtml generator(@config.layouts.archive), @writesFile
    @createRss()

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
