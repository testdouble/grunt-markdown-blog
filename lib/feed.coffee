module.exports = class Feed
  constructor: ({@destPath, @postCount}) ->

  writeRss: (generatesRss, writesFile) ->
    writesFile.write generatesRss.generate(), @destPath
