grunt = require('grunt')
pathlib = require('path')
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

  run: ->
    # copy pages
    pagesFiles = grunt.file.expandMapping('**/*.*', @_getPagesCwd(), { cwd: @config.sources.pages });
    for fileMeta in pagesFiles
      grunt.log.writeln("copying #{fileMeta.src} to #{fileMeta.dest}")
      grunt.file.copy fileMeta.src, fileMeta.dest

    # copy posts
    postsFiles = grunt.file.expandMapping('**/*.*', @_getPostsCwd(), { cwd: @config.sources.posts });
    for fileMeta in postsFiles
      grunt.log.writeln("copying #{fileMeta.src} to #{fileMeta.dest}")
      grunt.file.copy fileMeta.src, fileMeta.dest

    @posts = new Posts @_allMarkdownPosts(),
      htmlDir: @config.pathRoots.posts
      layout: new Layout @config.layouts.post
      dateFormat: @config.dateFormat
      cwd: @_getPostsCwd()
    @pages = new Pages @_allMarkdownPages(),
      htmlDir: @config.pathRoots.pages
      layout: new Layout @config.layouts.page
      cwd: @_getPagesCwd()
    @index = new Index @posts.newest(),
      htmlPath: @config.paths.index
      layout: new Layout @config.layouts.index
    @archive = new Archive
      htmlPath: @config.paths.archive
      layout: new Layout @config.layouts.archive
    @feed = new Feed
      rssPath: @config.paths.rss
      postCount: @config.rssCount
    @site = new Site(@config, @posts, @pages)

    writesFile = new WritesFile(@config.dest)
    wrapper = new Layout(@config.layouts.wrapper, @config.context)
    generatesHtml = new GeneratesHtml(@site, wrapper)

    @posts.writeHtml generatesHtml, writesFile
    @pages.writeHtml generatesHtml, writesFile
    @index.writeHtml generatesHtml, writesFile
    @archive.writeHtml generatesHtml, writesFile

    @feed.writeRss new GeneratesRss(@site), writesFile

  #private
  _getPostsCwd: ->
    pathlib.join(@config.dest, @config.destinations.posts)

  _getPagesCwd: ->
    pathlib.join(@config.dest, @config.destinations.pages)

  _allMarkdownPosts: ->
    if @config.destinations.posts || @config.destinations.posts == ""
      grunt.file.expand({ cwd: @_getPostsCwd() }, @config.process.posts)
    else if @config.paths.markdown? #backwards compatibility for lineman blog
      grunt.file.expand(@config.paths.markdown)
    else if @config.paths.posts?
      grunt.file.expand(@config.paths.posts)
    else
      []

  _allMarkdownPages: ->
    # check for empty string, because pages get dumped in the root
    if @config.destinations.pages || @config.destinations.pages == ""
      grunt.file.expand({ cwd: @_getPagesCwd() }, @config.process.pages)
    else if @config.paths.pages?
      grunt.file.expand(@config.paths.pages)
    else
      []
