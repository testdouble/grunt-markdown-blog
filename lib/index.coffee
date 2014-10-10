log = require('grunt').log
NullIndex = require('./null_index')

module.exports = class Index
  constructor: (@latestPost, {@htmlPath, @layout}) ->

  writeHtml: (generatesHtml, writesFile) ->
    writesFile.write generatesHtml.generate(@layout, @latestPost), @htmlPath

  @create: (latestPost, {htmlPath, layout}) ->
    if htmlPath?
      new @(latestPost, {htmlPath, layout})
    else
      log.writeln "Index skipped: destination path is undefined"
      new NullIndex
