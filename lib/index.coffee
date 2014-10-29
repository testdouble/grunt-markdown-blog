module.exports = class Index
  constructor: (@latestPost, {@destPath, @layout}) ->

  writeHtml: (generatesHtml, writesFile) ->
    writesFile.write generatesHtml.generate(@layout, @latestPost), @destPath
