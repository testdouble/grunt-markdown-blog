_ = require('underscore')
log = require('grunt').log

module.exports = class Config
  constructor: (@raw) ->

  forFeed: ->
    feedConfig = {}

    if @raw.paths.rss?
      feedConfig.rssPath = @raw.paths.rss
    else
      log.writeln "RSS Feed skipped: destination path is undefined"

    if @raw.rssCount
      feedConfig.postCount = @raw.rssCount
    else
      log.writeln "RSS Feed skipped: 0 posts"

    feedConfig

  forArchive: ->
    archiveConfig = {}

    if @raw.paths.archive?
      archiveConfig.htmlPath = @raw.paths.archive
    else
      log.writeln "Archive skipped: destination path is undefined"

    archiveConfig
