SandboxedModule = require('sandboxed-module')
{ Factory, grunt, Feed, NullFeed, Archive, NullArchive } = {}

beforeEach ->
  Factory = SandboxedModule.require '../lib/factory',
    requires:
      'grunt': grunt =
        log:
          error: jasmine.createSpy('log-error')
          writeln: jasmine.createSpy('log-writeln')
        fail:
          warn: jasmine.createSpy('fail-warn')
        file:
          exists: jasmine.createSpy('file-exists')
      './feed': Feed = jasmine.constructSpy('feed')
      './null_feed': NullFeed = jasmine.constructSpy('null_feed')
      './archive': Archive = jasmine.constructSpy('archive')
      './null_archive': NullArchive = jasmine.constructSpy('null_archive')

describe "Factory", ->

  describe "::feedFrom", ->
    When -> @feed = Factory.feedFrom({@rssPath, @postCount})

    context "with rss path", ->
      Given -> @rssPath = "some/path"

      context "with posts", ->
        Given -> @postCount = 2
        Then -> @feed instanceof Feed
        Then -> expect(grunt.log.writeln).not.toHaveBeenCalled()

      context "without posts", ->
        Given -> @postCount = 0
        Then -> @feed instanceof NullFeed
        Then -> expect(grunt.log.writeln).toHaveBeenCalled()

    context "without rss path", ->
      Given -> @rssPath = undefined
      Then -> @feed instanceof NullFeed
      Then -> expect(grunt.log.writeln).toHaveBeenCalled()

  describe "::archiveFrom", ->
    When -> @archive = Factory.archiveFrom({@htmlPath, @layoutPath})

    context "without htmlPath", ->
      Given -> @htmlPath = undefined
      Then -> @archive instanceof NullArchive
      Then -> expect(grunt.log.writeln).toHaveBeenCalled()

    context "with htmlPath", ->
      Given -> @htmlPath = "htmlPath"

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> @archive instanceof NullArchive
        Then -> expect(grunt.log.error).toHaveBeenCalled()

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> grunt.file.exists.andReturn(false)
          Then -> @archive instanceof NullArchive
          Then -> expect(grunt.fail.warn).toHaveBeenCalled()

        context "valid", ->
          Given -> grunt.file.exists.andReturn(true)
          Then -> @archive instanceof Archive
          Then -> expect(grunt.log.writeln).not.toHaveBeenCalled()
          Then -> expect(grunt.log.error).not.toHaveBeenCalled()
          Then -> expect(grunt.fail.warn).not.toHaveBeenCalled()
