module.exports = class Index
  constructor: (@latestPost, {@htmlPath}) ->

  writeHtml: (generatesHtml, writesFile) ->
    writesFile.write generatesHtml.generate(@latestPost), @htmlPath
