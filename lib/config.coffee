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
