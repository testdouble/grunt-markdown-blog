module.exports = class Feed
  constructor: ({@rssPath, @postCount}) ->

  writeRss: (generatesRss, writesFile) ->
    writesFile.write generatesRss.generate(), @rssPath
