grunt = require('grunt')

module.exports = class Config
  constructor: (@raw) ->

  forArchive: ->
    htmlPath: @raw.paths.archive
    layoutPath: @raw.layouts.archive

  forFeed: ->
    rssPath: @raw.paths.rss
    postCount: @raw.rssCount

  forIndex: ->
    htmlPath: @raw.paths.index
    layoutPath: @raw.layouts.index

  forPages: ->
    # htmlDir: @raw.pathRoots.pages
    layoutPath: @raw.layouts.page
    # src: ensureCompactArray(@raw.paths.pages)
    files: grunt.task.normalizeMultiTaskFiles(@raw.paths.pages)

  forPosts: ->
    # src = @raw.paths.markdown || @raw.paths.posts
    # htmlDir: @raw.pathRoots.posts
    layoutPath: @raw.layouts.post
    dateFormat: @raw.dateFormat
    # src: ensureCompactArray(src)
    src: grunt.task.normalizeMultiTaskFiles(@raw.paths.posts)

ensureCompactArray = (val) ->
  [].concat(val).filter (v) -> v
