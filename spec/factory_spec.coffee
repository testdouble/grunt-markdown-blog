SandboxedModule = require('sandboxed-module')
Factory = null
grunt = null

Feed = require('../lib/feed')
NullFeed = require('../lib/null_feed')
Archive = require('../lib/archive')
NullArchive = require('../lib/null_archive')

beforeEach ->
  Factory = SandboxedModule.require '../lib/factory',
    requires:
      'grunt': grunt = log: writeln: jasmine.createSpy('grunt-log')
      './feed': Feed
      './null_feed': NullFeed
      './archive': Archive
      './null_archive': NullArchive

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

  describe "::archiveFrom", ->
    When -> @archive = Factory.archiveFrom({@htmlPath, @layout})

    context "with htmlPath", ->
      Given -> @htmlPath = "htmlPath"
      Then -> @archive instanceof Archive
      And -> expect(grunt.log.writeln).not.toHaveBeenCalled()

    context "without htmlPath", ->
      Given -> @htmlPath = undefined
      Then -> @archive instanceof NullArchive
      And -> expect(grunt.log.writeln).toHaveBeenCalled()
