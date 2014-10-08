grunt = require('grunt')
pathlib = require('path')
Archive = require('../lib/archive')
Categories = require('../lib/categories')
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
    pagesFiles = @_allPagesContentToCopy()
    @_copyFiles(pagesFiles)

    # copy posts
    postsFiles = @_allPostsContentToCopy()
    @_copyFiles(postsFiles)

    @posts = new Posts @_allMarkdownPosts(),
      htmlDir: @config.dest
      layout: new Layout @config.layouts.post
      dateFormat: @config.dateFormat
      cwd: @_getPostsCwd()
    @categories = new Categories @posts,
      htmlDir: @config.pathRoots.categories
      layout: new Layout @config.layouts.category
      dateFormat: @config.dateFormat
    @pages = new Pages @_allMarkdownPages(),
      htmlDir: @config.dest
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

    # Pages and posts already exist in the right location
    writesFileInPlace = new WritesFile()
    writesFile = new WritesFile(@config.dest)
    wrapper = new Layout(@config.layouts.wrapper, @config.context)
    generatesHtml = new GeneratesHtml(@site, wrapper)

    @posts.writeHtml generatesHtml, writesFileInPlace
    @pages.writeHtml generatesHtml, writesFileInPlace
    @index.writeHtml generatesHtml, writesFile
    @archive.writeHtml generatesHtml, writesFile
    @categories.writeHtml generatesHtml, writesFile

    @feed.writeRss new GeneratesRss(@site), writesFile

    @_deleteFilesIn(@_allMarkdownPosts(), @_getPostsCwd())
    @_deleteFilesIn(@_allMarkdownPages(), @_getPagesCwd())

  #private
  _copyFiles: (fileSet) ->
    for fileMeta in fileSet
      grunt.log.writeln("copying #{fileMeta.src} to #{fileMeta.dest}")
      grunt.file.copy fileMeta.src, fileMeta.dest

  _deleteFilesIn: (fileSet, cwd) ->
    for file in fileSet
      filePath = pathlib.join(cwd, file)
      grunt.log.writeln("Cleaning up #{filePath}")
      grunt.file.delete(filePath)

  _alwaysFlattenPostsBehaviour: ->
    typeof @config.paths.posts == 'string'

  _alwaysFlattenPagesBehaviour: ->
    typeof @config.paths.pages == 'string'

  _getPostsCwd: ->
    if @_alwaysFlattenPostsBehaviour()
      pathlib.join(@config.dest, @config.pathRoots.posts)
    else
      pathlib.join(@config.dest, @config.paths.posts.dest)

  _getPagesCwd: ->
    if @_alwaysFlattenPagesBehaviour()
      pathlib.join(@config.dest, @config.pathRoots.pages)
    else
      pathlib.join(@config.dest, @config.paths.pages.dest)

  _allPostsContentToCopy: ->
    if @_alwaysFlattenPostsBehaviour()
      grunt.file.expandMapping @config.paths.posts, @_getPostsCwd(),
        flatten: true
    else
      grunt.file.expandMapping @config.paths.posts.src, @_getPostsCwd(),
        cwd: @config.paths.posts.cwd
        flatten: @config.paths.posts.flatten

  _allPagesContentToCopy: ->
    if @_alwaysFlattenPagesBehaviour()
      grunt.file.expandMapping @config.paths.pages, @_getPagesCwd(),
        flatten: true
    else
      grunt.file.expandMapping @config.paths.pages.src, @_getPagesCwd(),
        cwd: @config.paths.pages.cwd
        flatten: @config.paths.pages.flatten

  _allMarkdownPosts: ->
    grunt.file.expand({ cwd: @_getPostsCwd() }, @config.process.posts)

  _allMarkdownPages: ->
    grunt.file.expand({ cwd: @_getPagesCwd() }, @config.process.pages)
