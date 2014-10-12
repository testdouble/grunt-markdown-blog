SandboxedModule = require('sandboxed-module')
{ Factory, grunt, Feed, NullFeed, Archive, NullHtml, Index, Pages, Layout } = {}

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
          expand: jasmine.createSpy('file-expand')
      './feed': Feed = jasmine.constructSpy('feed')
      './null_feed': NullFeed = jasmine.constructSpy('null_feed')
      './archive': Archive = jasmine.constructSpy('archive')
      './index': Index = jasmine.constructSpy('index')
      './null_html': NullHtml = jasmine.constructSpy('null_html')
      './pages': Pages = jasmine.createSpy('pages')
      './layout': Layout = jasmine.createSpy('layout')

describe "Factory", ->

  describe "::archiveFrom", ->
    When -> @archive = Factory.archiveFrom({@htmlPath, @layoutPath})

    context "without htmlPath", ->
      Given -> @htmlPath = undefined
      Then -> @archive instanceof NullHtml
      Then -> expect(grunt.log.writeln).toHaveBeenCalled()

    context "with htmlPath", ->
      Given -> @htmlPath = "htmlPath"

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> @archive instanceof NullHtml
        Then -> expect(grunt.log.error).toHaveBeenCalled()

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> grunt.file.exists.andReturn(false)
          Then -> @archive instanceof NullHtml
          Then -> expect(grunt.fail.warn).toHaveBeenCalled()

        context "valid", ->
          Given -> grunt.file.exists.andReturn(true)
          Then -> @archive instanceof Archive
          Then -> expect(grunt.log.writeln).not.toHaveBeenCalled()
          Then -> expect(grunt.log.error).not.toHaveBeenCalled()
          Then -> expect(grunt.fail.warn).not.toHaveBeenCalled()

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

  describe "::indexFrom", ->
    Given -> @latestPost = "latestPost"
    When -> @index = Factory.indexFrom(@latestPost, {@htmlPath, @layoutPath})

    context "without htmlPath", ->
      Given -> @htmlPath = undefined
      Then -> @index instanceof NullHtml
      And -> expect(grunt.log.writeln).toHaveBeenCalled()

    context "with htmlPath", ->
      Given -> @htmlPath = "htmlPath"

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> @index instanceof NullHtml
        Then -> expect(grunt.log.error).toHaveBeenCalled()

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> grunt.file.exists.andReturn(false)
          Then -> @index instanceof NullHtml
          Then -> expect(grunt.fail.warn).toHaveBeenCalled()

        context "valid", ->
          Given -> grunt.file.exists.andReturn(true)
          Then -> @index instanceof Index
          Then -> expect(grunt.log.writeln).not.toHaveBeenCalled()
          Then -> expect(grunt.log.error).not.toHaveBeenCalled()
          Then -> expect(grunt.fail.warn).not.toHaveBeenCalled()

  describe "::pagesFrom", ->
    Given -> @src = []
    Given -> @htmlDir = "htmlDir"
    Given -> grunt.file.expand.andReturn(@expandedSrc = "expandedSrc")
    Given -> Layout.andReturn(@layout = jasmine.createStub("layout"))

    When -> @pages = Factory.pagesFrom({@src, @htmlDir, @layoutPath})

    context "without layout path", ->
      Given -> @layoutPath = undefined
      Then -> expect(Pages).toHaveBeenCalledWith([], {})
      Then -> expect(grunt.log.error).toHaveBeenCalled()

    context "with layout path", ->
      Given -> @layoutPath = "layoutPath"

      context "invalid", ->
        Given -> grunt.file.exists.andReturn(false)
        Then -> expect(Pages).toHaveBeenCalledWith([], {})
        Then -> expect(grunt.fail.warn).toHaveBeenCalled()

      context "valid", ->
        Given -> grunt.file.exists.andReturn(true)
        Then -> expect(Pages).toHaveBeenCalledWith(@expandedSrc, {@htmlDir, @layout})
        Then -> expect(grunt.log.writeln).not.toHaveBeenCalled()
        Then -> expect(grunt.log.error).not.toHaveBeenCalled()
        Then -> expect(grunt.fail.warn).not.toHaveBeenCalled()
