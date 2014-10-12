grunt = require('grunt')
Layout = require('./layout')
Feed = require('./feed')
NullFeed = require('./null_feed')
Archive = require('./archive')
Index = require('./index')
NullHtml = require('./null_html')
Pages = require('./pages')

module.exports =
  archiveFrom: ({htmlPath, layoutPath}) ->
    unless htmlPath?
      grunt.log.writeln "Archive skipped: destination path undefined"
      new NullHtml
    else unless layoutPath?
      grunt.log.error "Archive skipped: source template undefined"
      new NullHtml
    else unless grunt.file.exists(layoutPath)
      grunt.fail.warn "Archive skipped: unable to read '#{layoutPath}'"
      new NullHtml
    else
      new Archive
        htmlPath: htmlPath
        layout: new Layout(layoutPath)

  feedFrom: ({rssPath, postCount}) ->
    if rssPath? and postCount
      new Feed arguments...
    else unless rssPath?
      grunt.log.writeln "RSS Feed skipped: destination path undefined"
      new NullFeed
    else unless postCount
      grunt.log.writeln "RSS Feed skipped: 0 posts"
      new NullFeed

  indexFrom: (latestPost, {htmlPath, layoutPath}) ->
    unless htmlPath?
      grunt.log.writeln "Index skipped: destination path undefined"
      new NullHtml
    else unless layoutPath?
      grunt.log.error "Index skipped: source template undefined"
      new NullHtml
    else unless grunt.file.exists(layoutPath)
      grunt.fail.warn "Index skipped: unable to read '#{layoutPath}'"
      new NullHtml
    else
      new Index latestPost,
        htmlPath: htmlPath
        layout: new Layout(layoutPath)

  pagesFrom: ({src, htmlDir, layoutPath}) ->
    unless layoutPath?
      grunt.log.error "Pages skipped: source template undefined"
      new Pages([], {})
    else unless grunt.file.exists(layoutPath)
      grunt.fail.warn "Pages skipped: unable to read '#{layoutPath}'"
      new Pages([], {})
    else
      new Pages grunt.file.expand(src),
        htmlDir: htmlDir
        layout: new Layout(layoutPath)
