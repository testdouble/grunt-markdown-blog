module.exports = class Feed
  constructor: ({@rssPath, @jsonPath, @postCount}) ->

  writeRss: (generatesRss, writesFile) ->
    writesFile.write generatesRss.generate(), @rssPath

  writeJson: (generatesJsonFeed, writesFile) ->
    writesFile.write generatesJsonFeed.generate(), @jsonPath
