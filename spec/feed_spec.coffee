Feed = require('../lib/feed')

describe "Feed", ->

  When -> @subject = new Feed(rssPath: @rssPath, postCount: @postCount)

  describe "#writeRss", ->
    Given -> @rss = "rss"
    Given -> @generatesRss = jasmine.createStubObj('generatesRss', generate: @rss)
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    When -> @subject.writeRss(@generatesRss, @writesFile)

    context "without rss path", ->
      Given -> @rssPath = undefined

      context "for zero posts", ->
        Given -> @postCount = 0
        Then -> expect(@generatesRss.generate).not.toHaveBeenCalled()
        Then -> expect(@writesFile.write).not.toHaveBeenCalled()

      context "for at least one post", ->
        Given -> @postCount = 2
        Then -> expect(@generatesRss.generate).not.toHaveBeenCalled()
        Then -> expect(@writesFile.write).not.toHaveBeenCalled()

    context "with rss path", ->
      Given -> @rssPath = "rssPath"

      context "for zero posts", ->
        Given -> @postCount = 0
        Then -> expect(@generatesRss.generate).not.toHaveBeenCalled()
        Then -> expect(@writesFile.write).not.toHaveBeenCalled()

      context "for at least one post", ->
        Given -> @postCount = 2
        Then -> expect(@generatesRss.generate).toHaveBeenCalled()
        Then -> expect(@writesFile.write).toHaveBeenCalledWith(@rss, @rssPath)
