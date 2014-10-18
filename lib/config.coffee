_ = require('underscore')
grunt = require('grunt')
Path = require('./path')


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
  _(grunt.task.normalizeMultiTaskFiles(mapping)).map (file) ->
    src: file.src[0]
    dest: new Path(file.dest)
