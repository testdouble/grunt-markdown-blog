SandboxedModule = require('sandboxed-module')
Feed = null
NullFeed = require('../lib/null_feed')
grunt = null

beforeEach ->
  Feed = SandboxedModule.require '../lib/feed',
    requires:
      'grunt': grunt = log: writeln: jasmine.createSpy('grunt-log')
      './null_feed': NullFeed

describe "Feed", ->

  describe "::create", ->
    When -> @feed = Feed.create({@rssPath, @postCount})

    context "with rss path", ->
      Given -> @rssPath = "some/path"
      context "with posts", ->
        Given -> @postCount = 2
        Then -> @feed instanceof Feed
        And -> expect(grunt.log.writeln).not.toHaveBeenCalled()

      context "without posts", ->
        Given -> @postCount = 0
        Then -> @feed instanceof NullFeed
        And -> expect(grunt.log.writeln).toHaveBeenCalled()

    context "without rss path", ->
      Given -> @rssPath = undefined
      Then -> @feed instanceof NullFeed
      And -> expect(grunt.log.writeln).toHaveBeenCalled()

  describe "#writeRss", ->
    Given -> @rssPath = "some/path"
    Given -> @subject = new Feed({@rssPath, @postCount})
    Given -> @generatesRss = jasmine.createStubObj('generatesRss', generate: @rss = "rss")
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    When -> @subject.writeRss(@generatesRss, @writesFile)

    Then -> expect(@generatesRss.generate).toHaveBeenCalled()
    Then -> expect(@writesFile.write).toHaveBeenCalledWith(@rss, @rssPath)
