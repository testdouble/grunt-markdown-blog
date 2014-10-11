log = require('grunt').log

module.exports = class Config
  constructor: (@raw) ->

  forFeed: ->
    rssPath: @raw.paths.rss
    postCount: @raw.rssCount

  forArchive: ->
    archiveConfig = {}

    if @raw.paths.archive?
      archiveConfig.htmlPath = @raw.paths.archive
    else
      log.writeln "Archive skipped: destination path is undefined"

    archiveConfig
