_ = require('underscore')
log = require('grunt').log

module.exports = class Config
  constructor: (@raw) ->

  forFeed: ->
    _.tap
      rssPath: @raw.paths.rss
      postCount: @raw.rssCount
    , ({rssPath, postCount}) ->
      log.writeln "RSS Feed skipped: destination path is undefined" unless rssPath?
      log.writeln "RSS Feed skipped: 0 posts" unless postCount
