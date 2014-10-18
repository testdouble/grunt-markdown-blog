grunt = require('grunt')
Layout = require('./layout')
Feed = require('./feed')
NullFeed = require('./null_feed')
Archive = require('./archive')
Index = require('./index')
NullHtml = require('./null_html')
Pages = require('./pages')
Posts = require('./posts')

module.exports =
  archiveFrom: ({destPath, layoutPath}) ->
    unless destPath?
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
        destPath: destPath
        layout: new Layout(layoutPath)

  feedFrom: ({destPath, postCount}) ->
    if destPath? and postCount
      new Feed arguments...
    else unless destPath?
      grunt.log.writeln "RSS Feed skipped: destination path undefined"
      new NullFeed
    else unless postCount
      grunt.log.writeln "RSS Feed skipped: 0 posts"
      new NullFeed

  indexFrom: (latestPost, {destPath, layoutPath}) ->
    unless destPath?
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
        destPath: destPath
        layout: new Layout(layoutPath)

  pagesFrom: ({files, layoutPath}) ->
    unless files.length > 0
      grunt.log.writeln "Pages skipped: no page sources found"
      new Pages([], {})
    else unless layoutPath?
      grunt.log.error "Pages skipped: source template undefined"
      new Pages([], {})
    else unless grunt.file.exists(layoutPath)
      grunt.fail.warn "Pages skipped: unable to read '#{layoutPath}'"
      new Pages([], {})
    else
      new Pages files,
        layout: new Layout(layoutPath)

  postsFrom: ({files, layoutPath, dateFormat}) ->
    unless files.length > 0
      grunt.log.writeln "Posts skipped: no post sources found"
      new Posts([], {})
    else unless layoutPath?
      grunt.log.error "Posts skipped: source template undefined"
      new Posts([], {})
    else unless grunt.file.exists(layoutPath)
      grunt.fail.warn "Posts skipped: unable to read '#{layoutPath}'"
      new Posts([], {})
    else
      new Posts files,
        layout: new Layout(layoutPath)
        dateFormat: dateFormat
