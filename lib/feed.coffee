NullFeed = require('./null_feed')

module.exports = class Feed
  constructor: ({@rssPath, @postCount}) ->

  writeRss: (generatesRss, writesFile) ->
    writesFile.write generatesRss.generate(), @rssPath

  @create: ({rssPath, postCount}) ->
    if rssPath? and postCount
      new @(arguments...)
    else
      new NullFeed
