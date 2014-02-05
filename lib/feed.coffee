log = require('grunt').log
NullFeed = require('./null_feed')

module.exports = class Feed
  constructor: ({@rssPath, @postCount}) ->
    return new NullFeed unless @postCount

  writeRss: (generatesRss, writesFile) ->
    if @rssPath?
      writesFile.write generatesRss.generate(), @rssPath
    else
      log.error "RSS Feed not written because destination path is undefined"
