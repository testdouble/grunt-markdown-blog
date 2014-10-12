grunt = require('grunt')
Layout = require('./layout')
Feed = require('./feed')
NullFeed = require('./null_feed')
Archive = require('./archive')
NullArchive = require('./null_archive')

module.exports =
  feedFrom: ({rssPath, postCount}) ->
    if rssPath? and postCount
      new Feed arguments...
    else unless rssPath?
      grunt.log.writeln "RSS Feed skipped: destination path undefined"
      new NullFeed
    else unless postCount
      grunt.log.writeln "RSS Feed skipped: 0 posts"
      new NullFeed

  archiveFrom: ({htmlPath, layoutPath}) ->
    unless htmlPath?
      grunt.log.writeln "Archive skipped: destination path undefined"
      new NullArchive
    else unless layoutPath?
      grunt.log.error "Archive skipped: source template undefined"
      new NullArchive
    else unless grunt.file.exists(layoutPath)
      grunt.fail.warn "Archive skipped: unable to read '#{layoutPath}'"
      new NullArchive
    else
      new Archive
        htmlPath: htmlPath
        layout: new Layout(layoutPath)
