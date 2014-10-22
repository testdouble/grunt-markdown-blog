SandboxedModule = require('sandboxed-module')
{ Factory, grunt, Archive, Feed, Index, Pages, Posts, NullFeed, NullHtml, Layout } = {}

ThenExpectNoGruntLogging = ->
  Then -> expect(grunt.log.writeln).not.toHaveBeenCalled()
  Then -> expect(grunt.log.error).not.toHaveBeenCalled()
  Then -> expect(grunt.warn).not.toHaveBeenCalled()

beforeEach ->
  Factory = SandboxedModule.require '../lib/factory',
    requires:
      './archive': Archive = jasmine.createSpy('archive')
      './feed': Feed = jasmine.createSpy('feed')
      './index': Index = jasmine.createSpy('index')
      './pages': Pages = jasmine.createSpy('pages')
      './posts': Posts = jasmine.createSpy('posts')
      './null_feed': NullFeed = jasmine.createSpy('null_feed')
      './null_html': NullHtml = jasmine.createSpy('null_html')
      './layout': Layout = jasmine.createSpy('layout').andReturn(@layout = jasmine.createStub("layout"))

Given -> grunt =
  log:
    error: jasmine.createSpy('log-error')
    writeln: jasmine.createSpy('log-writeln')
  warn: jasmine.createSpy('warn')
  file:
    exists: jasmine.createSpy('file-exists')
    expand: jasmine.createSpy('file-expand')

describe "Factory", ->
  Given -> @subject = Factory(grunt)

  describe "::archiveFrom", ->
    When -> @archive = @subject.archiveFrom({@htmlPath, @layoutPath})

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
          Then -> expect(grunt.warn).toHaveBeenCalled()

        context "valid", ->
          Given -> grunt.file.exists.andReturn(true)
          Then -> @archive instanceof Archive
          Then -> expect(Archive).toHaveBeenCalledWith({@htmlPath, @layout})
          Then -> expect(Layout).toHaveBeenCalledWith(@layoutPath)
          ThenExpectNoGruntLogging()

  describe "::feedFrom", ->
    When -> @feed = @subject.feedFrom({@rssPath, @postCount})

    context "without rss path", ->
      Given -> @rssPath = undefined
      Then -> @feed instanceof NullFeed
      Then -> expect(grunt.log.writeln).toHaveBeenCalled()

    context "with rss path", ->
      Given -> @rssPath = "some/path"

      context "without posts", ->
        Given -> @postCount = 0
        Then -> @feed instanceof NullFeed
        Then -> expect(grunt.log.writeln).toHaveBeenCalled()

      context "with posts", ->
        Given -> @postCount = 2
        Then -> @feed instanceof Feed
        Then -> expect(Feed).toHaveBeenCalledWith({@rssPath, @postCount})
        ThenExpectNoGruntLogging()

  describe "::indexFrom", ->
    Given -> @latestPost = "latestPost"
    When -> @index = @subject.indexFrom(@latestPost, {@htmlPath, @layoutPath})

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
          Then -> expect(grunt.warn).toHaveBeenCalled()

        context "valid", ->
          Given -> grunt.file.exists.andReturn(true)
          Then -> @index instanceof Index
          Then -> expect(Index).toHaveBeenCalledWith(@latestPost, {@htmlPath, @layout})
          Then -> expect(Layout).toHaveBeenCalledWith(@layoutPath)
          ThenExpectNoGruntLogging()

  describe "::pagesFrom", ->
    Given -> @src = []
    Given -> @htmlDir = "htmlDir"

    When -> @pages = @subject.pagesFrom({@src, @htmlDir, @layoutPath})

    context "without pages", ->
      Given -> grunt.file.expand.andReturn(@expandedSrc = [])
      Then -> expect(grunt.file.expand).toHaveBeenCalledWith(@src)
      Then -> expect(Pages).toHaveBeenCalledWith([], {})
      Then -> expect(grunt.log.writeln).toHaveBeenCalled()

    context "with pages", ->
      Given -> grunt.file.expand.andReturn(@expandedSrc = ["some/page"])
      Then -> expect(grunt.file.expand).toHaveBeenCalledWith(@src)

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> expect(Pages).toHaveBeenCalledWith([], {})
        Then -> expect(grunt.log.error).toHaveBeenCalled()

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> grunt.file.exists.andReturn(false)
          Then -> expect(Pages).toHaveBeenCalledWith([], {})
          Then -> expect(grunt.warn).toHaveBeenCalled()

        context "valid", ->
          Given -> grunt.file.exists.andReturn(true)
          Then -> expect(Pages).toHaveBeenCalledWith(@expandedSrc, {@htmlDir, @layout})
          Then -> expect(Layout).toHaveBeenCalledWith(@layoutPath)
          ThenExpectNoGruntLogging()

  describe "::postsFrom", ->
    Given -> @src = ["path/to/posts/**/*"]
    Given -> @htmlDir = "htmlDir"
    Given -> @dateFormat = "dateFormat"

    When -> @posts = @subject.postsFrom({@src, @htmlDir, @layoutPath, @dateFormat})

    context "without posts", ->
      Given -> grunt.file.expand.andReturn(@expandedSrc = [])
      Then -> expect(grunt.file.expand).toHaveBeenCalledWith(@src)
      Then -> expect(Posts).toHaveBeenCalledWith([], {})
      Then -> expect(grunt.log.writeln).toHaveBeenCalled()

    context "with posts", ->
      Given -> grunt.file.expand.andReturn(@expandedSrc = ["some/post"])
      Then -> expect(grunt.file.expand).toHaveBeenCalledWith(@src)

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> expect(Posts).toHaveBeenCalledWith([], {})
        Then -> expect(grunt.log.error).toHaveBeenCalled()

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> grunt.file.exists.andReturn(false)
          Then -> expect(Posts).toHaveBeenCalledWith([], {})
          Then -> expect(grunt.warn).toHaveBeenCalled()

        context "valid", ->
          Given -> grunt.file.exists.andReturn(true)
          Then -> expect(Posts).toHaveBeenCalledWith(@expandedSrc, {@htmlDir, @layout, @dateFormat})
          Then -> expect(Layout).toHaveBeenCalledWith(@layoutPath)
          ThenExpectNoGruntLogging()

  describe "::siteWrapperFrom", ->
    Given -> @context = "context"
    When -> @siteWrapper = @subject.siteWrapperFrom({@layoutPath, @context})

    context "without layout path", ->
      Given -> @layoutPath = undefined
      Then -> expect(@siteWrapper.htmlFor).toBeDefined()
      Then -> expect(grunt.log.error).toHaveBeenCalled()

    context "with layout path", ->
      Given -> @layoutPath = "layoutPath"

      context "invalid", ->
        Given -> grunt.file.exists.andReturn(false)
        Then -> expect(@siteWrapper.htmlFor).toBeDefined()
        Then -> expect(grunt.warn).toHaveBeenCalled()

      context "valid", ->
        Given -> grunt.file.exists.andReturn(true)
        Then -> expect(Layout).toHaveBeenCalledWith(@layoutPath, @context)
        ThenExpectNoGruntLogging()
