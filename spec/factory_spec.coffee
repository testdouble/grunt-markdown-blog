td = require('testdouble')
{ Factory, grunt, Archive, Feed, Index, Pages, Posts, NullFeed, NullHtml, Layout } = {}

ThenExpectNoGruntLogging = ->
  Then -> expect(grunt.log.writeln).not.toHaveBeenCalled()
  Then -> expect(grunt.log.error).not.toHaveBeenCalled()
  Then -> expect(grunt.warn).not.toHaveBeenCalled()

beforeEach ->

  Archive  = td.replace('../lib/archive')
  Feed     = td.replace('../lib/feed')
  Index    = td.replace('../lib/index')
  Pages    = td.replace('../lib/pages')
  Posts    = td.replace('../lib/posts')
  NullFeed = td.replace('../lib/null_feed')
  NullHtml = td.replace('../lib/null_html')
  Layout   = td.replace('../lib/layout')
  Factory  = require('../lib/factory')

afterEach ->
  td.reset()

Given -> grunt =
  log:
    error: jasmine.createSpy('log-error')
    writeln: jasmine.createSpy('log-writeln')
  warn: jasmine.createSpy('warn')
  file:
    exists: jasmine.createSpy('file-exists')
    expand: jasmine.createSpy('file-expand')

describe.only "Factory", ->
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
          Then -> td.verify(Archive({@htmlPath, layout: td.matchers.isA(Layout)}))
          Then -> td.verify(Layout(@layoutPath))
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
        Then -> td.verify(Feed({@rssPath, @postCount}))
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
          Then -> td.verify(Index(@latestPost, {@htmlPath, layout: td.matchers.isA(Layout)}))
          Then -> td.verify(Layout(@layoutPath))
          ThenExpectNoGruntLogging()

  describe "::pagesFrom", ->
    Given -> @src = []
    Given -> @htmlDir = "htmlDir"

    When -> @pages = @subject.pagesFrom({@src, @htmlDir, @layoutPath})

    context "without pages", ->
      Given -> grunt.file.expand.andReturn(@expandedSrc = [])
      Then -> expect(grunt.file.expand).toHaveBeenCalledWith(@src)
      Then -> td.verify(Pages([], {}))
      Then -> expect(grunt.log.writeln).toHaveBeenCalled()

    context "with pages", ->
      Given -> grunt.file.expand.andReturn(@expandedSrc = ["some/page"])
      Then -> expect(grunt.file.expand).toHaveBeenCalledWith(@src)

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> td.verify(Pages([], {}))
        Then -> expect(grunt.log.error).toHaveBeenCalled()

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> grunt.file.exists.andReturn(false)
          Then -> td.verify(Pages([], {}))
          Then -> expect(grunt.warn).toHaveBeenCalled()

        context "valid", ->
          Given -> grunt.file.exists.andReturn(true)
          Then -> td.verify(Pages(@expandedSrc, {@htmlDir, layout: td.matchers.isA(Layout)}))
          Then -> td.verify(Layout(@layoutPath))
          ThenExpectNoGruntLogging()

  describe "::postsFrom", ->
    Given -> @src = ["path/to/posts/**/*"]
    Given -> @htmlDir = "htmlDir"
    Given -> @dateFormat = "dateFormat"

    When -> @posts = @subject.postsFrom({@src, @htmlDir, @layoutPath, @dateFormat})

    context "without posts", ->
      Given -> grunt.file.expand.andReturn(@expandedSrc = [])
      Then -> expect(grunt.file.expand).toHaveBeenCalledWith(@src)
      Then -> td.verify(Posts([], {}))
      Then -> expect(grunt.log.writeln).toHaveBeenCalled()

    context "with posts", ->
      Given -> grunt.file.expand.andReturn(@expandedSrc = ["some/post"])
      Then -> expect(grunt.file.expand).toHaveBeenCalledWith(@src)

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> td.verify(Posts([], {}))
        Then -> expect(grunt.log.error).toHaveBeenCalled()

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> grunt.file.exists.andReturn(false)
          Then -> td.verify(Posts([], {}))
          Then -> expect(grunt.warn).toHaveBeenCalled()

        context "valid", ->
          Given -> grunt.file.exists.andReturn(true)
          Then -> td.verify(Posts(@expandedSrc, {@htmlDir, layout: td.matchers.isA(Layout), @dateFormat}))
          Then -> td.verify(Layout(@layoutPath))
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
        Then -> td.verify(Layout(@layoutPath, @context))
        ThenExpectNoGruntLogging()
