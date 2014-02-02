NullFeed = require('./null_feed')

module.exports = class Feed
  constructor: ({@rssPath, @postCount}) ->
    return new NullFeed unless @rssPath? and @postCount

  writeRss: (generatesRss, writesFile) ->
    writesFile.write generatesRss.generate(), @rssPath
