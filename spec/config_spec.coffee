SandboxedModule = require('sandboxed-module')
{ grunt, Config } = {}


beforeEach ->
  Config = SandboxedModule.require '../lib/config',
    requires:
      'grunt': grunt = log: error: jasmine.createSpy('log-error')

describe "Config", ->
  Given -> @raw = layouts: {}, paths: {}, pathRoots: {}
  Given -> @subject = new Config(@raw)

  Invariant -> @raw == @subject.raw

  describe "#forArchive", ->
    Given -> @raw.paths.archive = @htmlPath = "htmlPath"
    Given -> @raw.layouts.archive = @layoutPath = "layoutPath"
    When -> @archiveConfig = @subject.forArchive()
    Then -> expect(@archiveConfig).toEqual {@htmlPath, @layoutPath}

  describe "#forFeed", ->
    Given -> @raw.paths.rss = @rssPath = "some/path"
    Given -> @raw.rssCount = @postCount = 2
    When -> @feedConfig = @subject.forFeed()
    Then -> expect(@feedConfig).toEqual {@rssPath, @postCount}

  describe "#forIndex", ->
    Given -> @raw.paths.index = @htmlPath = "htmlPath"
    Given -> @raw.layouts.index = @layoutPath = "layoutPath"
    When -> @indexConfig = @subject.forIndex()
    Then -> expect(@indexConfig).toEqual {@htmlPath, @layoutPath}

  describe "#forPages", ->
    Given -> @raw.pathRoots.pages = @htmlDir = "htmlDir"
    Given -> @raw.layouts.page = @layoutPath = "layoutPath"
    When -> @pagesConfig = @subject.forPages()

    context "with single page source", ->
      Given -> @raw.paths.pages = @path = "some/path/**/*"
      Then -> expect(@pagesConfig).toEqual {
        @htmlDir
        @layoutPath
        src: [@path]
      }

    context "with multiple page sources", ->
      Given -> @raw.paths.pages = ["a", null, undefined, "", "b"]
      Then -> expect(@pagesConfig).toEqual {
        @htmlDir
        @layoutPath
        src: ["a", "b"]
      }

  describe "#forPosts", ->
    Given -> @raw.pathRoots.posts = @htmlDir = "htmlDir"
    Given -> @raw.layouts.post = @layoutPath = "layoutPath"
    Given -> @raw.dateFormat = @dateFormat = "dateFormat"

    When -> @postsConfig = @subject.forPosts()

    context "with single post source", ->
      Given -> @raw.paths.posts = @path = "some/path/**/*"
      Then -> expect(@postsConfig).toEqual {
        @htmlDir
        @layoutPath
        @dateFormat
        src: [@path]
      }

    context "with multiple post sources", ->
      Given -> @raw.paths.posts = ["a", null, undefined, "", "b"]
      Then -> expect(@postsConfig).toEqual {
        @htmlDir
        @layoutPath
        @dateFormat
        src: ["a", "b"]
      }
