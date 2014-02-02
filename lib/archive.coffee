module.exports = class Archive
  constructor: ({@htmlPath, @layout}) ->

  writeHtml: (generatesHtml, writesFile) ->
    writesFile.write generatesHtml.generate(@layout), @htmlPath
