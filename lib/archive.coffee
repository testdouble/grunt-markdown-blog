module.exports = class Archive
  constructor: ({@destPath, @layout}) ->

  writeHtml: (generatesHtml, writesFile) ->
    writesFile.write generatesHtml.generate(@layout), @destPath
