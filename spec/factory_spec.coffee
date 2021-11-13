Factory = null
grunt = null

beforeEach ->
  @deps = {
    Archive : td.constructor("Archive")
    Feed    : td.constructor("Feed")
    Index   : td.constructor("Index")
    Pages   : td.constructor("Pages")
    Posts   : td.constructor("Posts")
    NullFeed: td.constructor("NullFeed")
    NullHtml: td.constructor("NullHtml")
    Layout  : td.constructor("Layout")
  }

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
  Given -> @subject = Factory(grunt, @deps)

  describe "::archiveFrom", ->
    When -> @archive = @subject.archiveFrom({@htmlPath, @layoutPath})

    context "without htmlPath", ->
      Given -> @htmlPath = undefined
      Then -> @archive instanceof @deps.NullHtml

    context "with htmlPath", ->
      Given -> @htmlPath = "htmlPath"

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> @archive instanceof @deps.NullHtml

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(false)
          Then -> @archive instanceof @deps.NullHtml

        context "valid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(true)
          Then -> td.verify(@deps.Archive({@htmlPath, layout: td.matchers.isA(@deps.Layout)}))
          Then -> td.verify(@deps.Layout(@layoutPath))
          Then -> @archive instanceof @deps.Archive

  describe "::feedFrom", ->
    When -> @feed = @subject.feedFrom({@rssPath, @postCount})

    context "without rss path", ->
      Given -> @rssPath = undefined
      Then -> @feed instanceof @deps.NullFeed

    context "with rss path", ->
      Given -> @rssPath = "some/path"

      context "without posts", ->
        Given -> @postCount = 0
        Then -> @feed instanceof @deps.NullFeed

      context "with posts", ->
        Given -> @postCount = 2
        Then -> td.verify(@deps.Feed({@rssPath, @postCount}))
        Then -> @feed instanceof @deps.Feed

  describe "::indexFrom", ->
    Given -> @latestPost = "latestPost"
    When -> @index = @subject.indexFrom(@latestPost, {@htmlPath, @layoutPath})

    context "without htmlPath", ->
      Given -> @htmlPath = undefined
      Then -> @index instanceof @deps.NullHtml

    context "with htmlPath", ->
      Given -> @htmlPath = "htmlPath"

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> @index instanceof @deps.NullHtml

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(false)
          Then -> @index instanceof @deps.NullHtml

        context "valid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(true)
          Then -> td.verify(@deps.Index(@latestPost, {@htmlPath, layout: td.matchers.isA(@deps.Layout)}))
          Then -> td.verify(@deps.Layout(@layoutPath))
          Then -> @index instanceof @deps.Index

  describe "::pagesFrom", ->
    Given -> @src = []
    Given -> @htmlDir = "htmlDir"
    When -> @pages = @subject.pagesFrom({@src, @htmlDir, @layoutPath})

    context "without pages", ->
      Given -> td.when(grunt.file.expand(@src)).thenReturn(@expandedSrc = [])
      Then -> td.verify(@deps.Pages([], {}))

    context "with pages", ->
      Given -> td.when(grunt.file.expand(@src)).thenReturn(@expandedSrc = ["some/page"])

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> td.verify(@deps.Pages([], {}))

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(false)
          Then -> td.verify(@deps.Pages([], {}))

        context "valid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(true)
          Then -> td.verify(@deps.Pages(@expandedSrc, {@htmlDir, layout: td.matchers.isA(@deps.Layout)}))
          Then -> td.verify(@deps.Layout(@layoutPath))

  describe "::postsFrom", ->
    Given -> @src = ["path/to/posts/**/*"]
    Given -> @htmlDir = "htmlDir"
    Given -> @dateFormat = "dateFormat"

    When -> @posts = @subject.postsFrom({@src, @htmlDir, @layoutPath, @dateFormat})

    context "without posts", ->
      Given -> td.when(grunt.file.expand(@src)).thenReturn(@expandedSrc = [])
      Then -> td.verify(@deps.Posts([], {}))

    context "with posts", ->
      Given -> td.when(grunt.file.expand(@src)).thenReturn(@expandedSrc = ["some/post"])

      context "without layout path", ->
        Given -> @layoutPath = undefined
        Then -> td.verify(@deps.Posts([], {}))

      context "with layout path", ->
        Given -> @layoutPath = "layoutPath"

        context "invalid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(false)
          Then -> td.verify(@deps.Posts([], {}))

        context "valid", ->
          Given -> td.when(grunt.file.exists(@layoutPath)).thenReturn(true)
          Then -> td.verify(@deps.Posts(@expandedSrc, {@htmlDir, layout: td.matchers.isA(@deps.Layout), @dateFormat}))
          Then -> td.verify(@deps.Layout(@layoutPath))

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
        Then -> td.verify(@deps.Layout(@layoutPath, @context))
