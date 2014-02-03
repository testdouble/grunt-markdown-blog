log = require('grunt').log

module.exports = class Index
  constructor: (@latestPost, {@htmlPath, @layout}) ->

  writeHtml: (generatesHtml, writesFile) ->
    if @htmlPath?
      writesFile.write generatesHtml.generate(@layout, @latestPost), @htmlPath
    else
      log.error "Index not written because destination path is undefined"
