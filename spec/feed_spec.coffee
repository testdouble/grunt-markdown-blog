SandboxedModule = require('sandboxed-module')
Feed = null
grunt = null

beforeEach ->
  Feed = SandboxedModule.require '../lib/feed',
    requires:
      'grunt': grunt = log: error: jasmine.createSpy('grunt-log')

describe "Feed", ->

  When -> @subject = new Feed(rssPath: @rssPath, postCount: @postCount)

  describe "#writeRss", ->
    Given -> @rss = "rss"
    Given -> @generatesRss = jasmine.createStubObj('generatesRss', generate: @rss)
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    When -> @subject.writeRss(@generatesRss, @writesFile)

    context "without rss path", ->
      Given -> @postCount = 2
      Given -> @rssPath = undefined

      Then -> expect(@generatesRss.generate).not.toHaveBeenCalled()
      Then -> expect(@writesFile.write).not.toHaveBeenCalled()
      Then -> expect(grunt.log.error).toHaveBeenCalled()

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
