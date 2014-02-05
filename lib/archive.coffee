log = require('grunt').log

module.exports = class Archive
  constructor: ({@htmlPath, @layout}) ->

  writeHtml: (generatesHtml, writesFile) ->
    if @htmlPath?
      writesFile.write generatesHtml.generate(@layout), @htmlPath
    else
      log.error "Archive not written because destination path is undefined"
