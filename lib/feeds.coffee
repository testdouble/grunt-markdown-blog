module.exports = class Feeds
  constructor: ({@rssPath, @jsonPath, @postCount}) ->

  writeFeeds: (generatesRss, writesFile) ->
    feeds = generatesRss.generate()
    writesFile.write feeds.rss, @rssPath
    writesFile.write feeds.json, @jsonPath

