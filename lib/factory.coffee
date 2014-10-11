log = require('grunt').log
Feed = require('./feed')
NullFeed = require('./null_feed')

module.exports =
  feedFrom: ({rssPath, postCount}) ->
    if rssPath? and postCount
      new Feed arguments...
    else unless rssPath?
      log.writeln "RSS Feed skipped: destination path undefined"
      new NullFeed
    else unless postCount
      log.writeln "RSS Feed skipped: 0 posts"
      new NullFeed
