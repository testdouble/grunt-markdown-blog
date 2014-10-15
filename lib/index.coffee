module.exports = class Index
  constructor: (@latestPost, {@htmlPath, @layout}) ->

  writeHtml: (generatesHtml, writesFile) ->
    writesFile.write generatesHtml.generate(@layout, @latestPost), @htmlPath
