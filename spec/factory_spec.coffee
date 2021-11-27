Factory = null
grunt = null
Archive  = null
Feed     = null
Index    = null
Layout   = null
NullFeed = null
NullHtml = null
Pages    = null
Posts    = null

beforeEach ->
  Archive  = td.constructor("Archive")
  Feed     = td.constructor("Feed")
  Index    = td.constructor("Index")
  Layout   = td.constructor("Layout")
  NullFeed = td.constructor("NullFeed")
  NullHtml = td.constructor("NullHtml")
  Pages    = td.constructor("Pages")
  Posts    = td.constructor("Posts")

  Factory  = require("../lib/factory")

afterEach ->
  td.reset()

Given -> grunt =
  log:
    error: td.func("log-error")
    writeln: td.func("log-writeln")
  warn: td.func("warn")
  file:
    exists: td.func("file-exists")
    expand: td.func("file-expand")

describe "Factory", ->
  Given -> @subject = Factory(grunt, { Archive, Feed, Index, Pages, Posts, NullFeed, NullHtml, Layout })

  describe "::archiveFrom", ->
    When -> @archive = @subject.archiveFrom({@htmlPath, @layoutPath})

    context "without htmlPath", ->
      Given -> @htmlPath = undefined
      Then -> @archive instanceof NullHtml

    context "with htmlPath", ->
      Given -> @htmlPath = "htmlPath"

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> @archive instanceof NullHtml

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(false)
          Then -> @archive instanceof NullHtml

        context "valid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(true)
          Then -> td.verify(Archive({@htmlPath, layout: td.matchers.isA(Layout)}))
          Then -> td.verify(Layout(@layoutPath))
          Then -> @archive instanceof Archive

  describe "::feedFrom", ->
    When -> @feed = @subject.feedFrom({@rssPath, @jsonPath, @postCount})

    context "without rss path", ->
      Given -> @rssPath = undefined
      Then -> @feed instanceof NullFeed

    context "with rss path", ->
      Given -> @rssPath = "some/path.xml"

      context "without posts", ->
        Given -> @postCount = 0
        Then -> @feed instanceof NullFeed

      context "with posts", ->
        Given -> @postCount = 2
        Then -> td.verify(Feed({@rssPath, @jsonPath, @postCount}))
        Then -> @feed instanceof Feed

    context "without json path", ->
      Given -> @jsonPath = undefined
      Then -> @feed instanceof NullFeed

    context "with rss path", ->
      Given -> @jsonPath = "some/path.json"

      context "without posts", ->
        Given -> @postCount = 0
        Then -> @feed instanceof NullFeed

      context "with posts", ->
        Given -> @postCount = 2
        Then -> td.verify(Feed({@rssPath, @jsonPath, @postCount}))
        Then -> @feed instanceof Feed

  describe "::indexFrom", ->
    Given -> @latestPost = "latestPost"
    When -> @index = @subject.indexFrom(@latestPost, {@htmlPath, @layoutPath})

    context "without htmlPath", ->
      Given -> @htmlPath = undefined
      Then -> @index instanceof NullHtml

    context "with htmlPath", ->
      Given -> @htmlPath = "htmlPath"

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> @index instanceof NullHtml

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(false)
          Then -> @index instanceof NullHtml

        context "valid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(true)
          Then -> td.verify(Index(@latestPost, {@htmlPath, layout: td.matchers.isA(Layout)}))
          Then -> td.verify(Layout(@layoutPath))
          Then -> @index instanceof Index

  describe "::pagesFrom", ->
    Given -> @src = []
    Given -> @htmlDir = "htmlDir"
    When -> @pages = @subject.pagesFrom({@src, @htmlDir, @layoutPath})

    context "without pages", ->
      Given -> td.when(grunt.file.expand(@src)).thenReturn(@expandedSrc = [])
      Then -> td.verify(Pages([], {}))

    context "with pages", ->
      Given -> td.when(grunt.file.expand(@src)).thenReturn(@expandedSrc = ["some/page"])

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> td.verify(Pages([], {}))

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(false)
          Then -> td.verify(Pages([], {}))

        context "valid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(true)
          Then -> td.verify(Pages(@expandedSrc, {@htmlDir, layout: td.matchers.isA(Layout)}))
          Then -> td.verify(Layout(@layoutPath))

  describe "::postsFrom", ->
    Given -> @src = ["path/to/posts/**/*"]
    Given -> @htmlDir = "htmlDir"
    Given -> @dateFormat = "dateFormat"

    When -> @posts = @subject.postsFrom({@src, @htmlDir, @layoutPath, @dateFormat})

    context "without posts", ->
      Given -> td.when(grunt.file.expand(@src)).thenReturn(@expandedSrc = [])
      Then -> td.verify(Posts([], {}))

    context "with posts", ->
      Given -> td.when(grunt.file.expand(@src)).thenReturn(@expandedSrc = ["some/post"])

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> td.verify(Posts([], {}))

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(false)
          Then -> td.verify(Posts([], {}))

        context "valid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(true)
          Then -> td.verify(Posts(@expandedSrc, {@htmlDir, layout: td.matchers.isA(Layout), @dateFormat}))
          Then -> td.verify(Layout(@layoutPath))

  describe "::siteWrapperFrom", ->
    Given -> @context = "context"
    When -> @siteWrapper = @subject.siteWrapperFrom({@layoutPath, @context})

    context "without layout path", ->
      Given -> @layoutPath = undefined
      Then -> expect(@siteWrapper.htmlFor).toBeDefined()

    context "with layout path", ->
      Given -> @layoutPath = "layoutPath"

      context "invalid", ->
        Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(false)
        Then -> expect(@siteWrapper.htmlFor).toBeDefined()

      context "valid", ->
        Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(true)
        Then -> td.verify(Layout(@layoutPath, @context))
