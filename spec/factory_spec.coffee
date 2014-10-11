SandboxedModule = require('sandboxed-module')
Factory = null
grunt = null

Feed = require('../lib/feed')
NullFeed = require('../lib/null_feed')

beforeEach ->
  Factory = SandboxedModule.require '../lib/factory',
    requires:
      'grunt': grunt = log: writeln: jasmine.createSpy('grunt-log')
      './feed': Feed
      './null_feed': NullFeed

describe "Factory", ->

  describe "::feedFrom", ->
    When -> @feed = Factory.feedFrom({@rssPath, @postCount})

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
