log = require('grunt').log
NullFeed = require('./null_feed')

module.exports = class Feed
  constructor: ({@rssPath, @postCount}) ->

  writeRss: (generatesRss, writesFile) ->
    writesFile.write generatesRss.generate(), @rssPath

  @create: ({rssPath, postCount}) ->
    if rssPath? and postCount
      new @({rssPath, postCount})
    else if !rssPath?
      log.writeln "RSS Feed skipped: destination path is undefined"
      new NullFeed
    else if !postCount
      log.writeln "RSS Feed skipped: 0 posts"
      new NullFeed
