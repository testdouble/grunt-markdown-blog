Feed = require('../lib/feed')

describe "Feed", ->
  Given -> @rssPath = "some/path"
  Given -> @subject = new Feed({@rssPath, @postCount})

  describe "#writeRss", ->
    Given -> @generatesRss = jasmine.createStubObj('generatesRss', generate: @rss = "rss")
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    When -> @subject.writeRss(@generatesRss, @writesFile)

    Then -> expect(@generatesRss.generate).toHaveBeenCalled()
    Then -> expect(@writesFile.write).toHaveBeenCalledWith(@rss, @rssPath)
