grunt = require('grunt')

module.exports = class Config
  constructor: (@raw) ->

  forArchive: ->
    destPath: @raw.paths.archive
    layoutPath: @raw.layouts.archive

  forFeed: ->
    destPath: @raw.paths.rss
    postCount: @raw.rssCount

  forIndex: ->
    destPath: @raw.paths.index
    layoutPath: @raw.layouts.index

  forPages: ->
    files: expandFilesMapping(@raw.paths.pages)
    layoutPath: @raw.layouts.page

  forPosts: ->
    files: expandFilesMapping(@raw.paths.posts)
    layoutPath: @raw.layouts.post
    dateFormat: @raw.dateFormat

expandFilesMapping = (mapping) ->
  grunt.task.normalizeMultiTaskFiles(mapping)
