grunt = require('grunt')
Archive = require('../lib/archive')
Config = require('../lib/config')
Factory = require('../lib/factory')
Feed = require('../lib/feed')
GeneratesHtml = require('../lib/generates_html')
GeneratesRss = require('../lib/generates_rss')
Index = require('../lib/index')
Layout = require('../lib/layout')
Pages = require('../lib/pages')
Posts = require('../lib/posts')
Site = require('../lib/site')
WritesFile = require('../lib/writes_file')

module.exports = class MarkdownTask
  constructor: (@config) ->
    @cfg = new Config(@config)
    @posts = new Posts @_allMarkdownPosts(),
      htmlDir: @config.pathRoots.posts
      layout: new Layout @config.layouts.post
      dateFormat: @config.dateFormat
    @pages = new Pages @_allMarkdownPages(),
      htmlDir: @config.pathRoots.pages
      layout: new Layout @config.layouts.page
    @index = Index.create @posts.newest(),
      htmlPath: @config.paths.index
      layout: new Layout @config.layouts.index
    @archive = Factory.archiveFrom @cfg.forArchive()
    @feed = Factory.feedFrom @cfg.forFeed()
    @site = new Site(@config, @posts, @pages)

  run: ->
    writesFile = new WritesFile(@config.dest)
    wrapper = new Layout(@config.layouts.wrapper, @config.context)
    generatesHtml = new GeneratesHtml(@site, wrapper)

    @posts.writeHtml generatesHtml, writesFile
    @pages.writeHtml generatesHtml, writesFile
    @index.writeHtml generatesHtml, writesFile
    @archive.writeHtml generatesHtml, writesFile

    @feed.writeRss new GeneratesRss(@site), writesFile

  #private
  _allMarkdownPosts: ->
    if @config.paths.markdown? #backwards compatibility for lineman blog
      grunt.log.fail("Warning: config.paths.markdown is deprecated in favor of config.paths.posts")
      grunt.file.expand(@config.paths.markdown)
    else if @config.paths.posts?
      grunt.file.expand(@config.paths.posts)
    else
      []

  _allMarkdownPages: ->
    if @config.paths.pages?
      grunt.file.expand(@config.paths.pages)
    else
      []
