log = require('grunt').log
Feed = require('./feed')
NullFeed = require('./null_feed')
Archive = require('./archive')
NullArchive = require('./null_archive')

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

  archiveFrom: ({htmlPath, layout}) ->
    if htmlPath?
      new Archive arguments...
    else
      log.writeln "Archive skipped: destination path undefined"
      new NullArchive
