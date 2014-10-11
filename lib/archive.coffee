log = require('grunt').log
NullArchive = require('./null_archive')

module.exports = class Archive
  constructor: ({@htmlPath, @layout}) ->

  writeHtml: (generatesHtml, writesFile) ->
    writesFile.write generatesHtml.generate(@layout), @htmlPath

  @create: ({htmlPath, layout}) ->
    if htmlPath?
      new @({htmlPath, layout})
    else
      new NullArchive
