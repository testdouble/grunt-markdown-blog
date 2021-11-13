Feed = require("../lib/feed")

describe "Feed", ->
  Given -> @rssPath = "some/path"
  Given -> @subject = new Feed({@rssPath, @postCount})

  describe "#writeRss", ->
    Given ->
      @rss = "rss"
      @generatesRss = td.object("generatesRss", ["generate"])
      td.when(@generatesRss.generate()).thenReturn(@rss)

    Given ->
      @writesFile = td.object("writesFile", ["write"])

    When -> @subject.writeRss(@generatesRss, @writesFile)
    Then -> td.verify(@writesFile.write(@rss, @rssPath))

