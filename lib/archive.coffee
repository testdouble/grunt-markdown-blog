module.exports = class Archive
  constructor: ({@htmlPath}) ->

  writeHtml: (generatesHtml, writesFile) ->
    writesFile.write generatesHtml.generate(), @htmlPath
