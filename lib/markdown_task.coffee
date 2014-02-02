grunt = require('grunt')
Archive = require('../lib/archive')
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
    @posts = new Posts @_allMarkdownPosts(),
      htmlDir: @config.pathRoots.posts
      dateFormat: @config.dateFormat
    @pages = new Pages @_allMarkdownPages(),
      htmlDir: @config.pathRoots.pages
    @index = new Index @posts.latest(),
      htmlPath: @config.paths.index
    @archive = new Archive
      htmlPath: @config.paths.archive
    @feed = new Feed
      rssPath: @config.paths.rss
      postCount: @config.rssCount
    @site = new Site(@config, @posts, new Layout(@config.layouts.post))
    @site.addPages @pages

  run: ->
    writesFile = new WritesFile(@config.dest)
    wrapper = new Layout(@config.layouts.wrapper, @config.context)
    generatesHtml = (layout) => new GeneratesHtml @site, wrapper, new Layout(layout)

    @posts.writeHtml generatesHtml(@config.layouts.post), writesFile
    @pages.writeHtml generatesHtml(@config.layouts.page), writesFile
    @index.writeHtml generatesHtml(@config.layouts.index), writesFile
    @archive.writeHtml generatesHtml(@config.layouts.archive), writesFile

    @feed.writeRss new GeneratesRss(@site), writesFile

  #private
  _allMarkdownPosts: ->
    if @config.paths.markdown? #backwards compatibility for lineman blog
      grunt.file.expand(@config.paths.markdown)
    else
      grunt.file.expand(@config.paths.posts)

  _allMarkdownPages: -> grunt.file.expand(@config.paths.pages)
