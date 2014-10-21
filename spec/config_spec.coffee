Config = require('../lib/config')

describe "Config", ->
  Given -> @options = layouts: {}, paths: {}, pathRoots: {}
  When -> @subject = new Config(@options)

  describe "#constructor", ->
    describe "has defaults", ->
      When -> @subject = new Config()
      Then -> expect(@subject.raw).toEqual
        author: "Full Name"
        title: "my blog"
        description: "the blog where I write things"
        url: "http://www.myblog.com"
        rssCount: 10
        dateFormat: 'MMMM Do YYYY'
        layouts:
          wrapper: "app/templates/wrapper.us"
          index: "app/templates/index.us"
          post: "app/templates/post.us"
          page: "app/templates/page.us"
          archive: "app/templates/archive.us"
        paths:
          posts: "app/posts/*.md"
          pages: "app/pages/**/*.md"
          index: "index.html"
          archive: "archive.html"
          rss: "index.xml"
        pathRoots:
          posts: "posts"
          pages: "pages"
        dest: "dist"
        context:
          js: "app.js"
          css: "app.css"

  describe "#forArchive", ->
    Given -> @options.paths.archive = @htmlPath = "htmlPath"
    Given -> @options.layouts.archive = @layoutPath = "layoutPath"
    When -> @archiveConfig = @subject.forArchive()
    Then -> expect(@archiveConfig).toEqual {@htmlPath, @layoutPath}

  describe "#forFeed", ->
    Given -> @options.paths.rss = @rssPath = "some/path"
    Given -> @options.rssCount = @postCount = 2
    When -> @feedConfig = @subject.forFeed()
    Then -> expect(@feedConfig).toEqual {@rssPath, @postCount}

  describe "#forIndex", ->
    Given -> @options.paths.index = @htmlPath = "htmlPath"
    Given -> @options.layouts.index = @layoutPath = "layoutPath"
    When -> @indexConfig = @subject.forIndex()
    Then -> expect(@indexConfig).toEqual {@htmlPath, @layoutPath}

  describe "#forPages", ->
    Given -> @options.pathRoots.pages = @htmlDir = "htmlDir"
    Given -> @options.layouts.page = @layoutPath = "layoutPath"
    When -> @pagesConfig = @subject.forPages()

    context "with single page source", ->
      Given -> @options.paths.pages = @path = "some/path/**/*"
      Then -> expect(@pagesConfig).toEqual {
        @htmlDir
        @layoutPath
        src: [@path]
      }

    context "with multiple page sources", ->
      Given -> @options.paths.pages = ["a", null, undefined, "", "b"]
      Then -> expect(@pagesConfig).toEqual {
        @htmlDir
        @layoutPath
        src: ["a", "b"]
      }

  describe "#forPosts", ->
    Given -> @options.pathRoots.posts = @htmlDir = "htmlDir"
    Given -> @options.layouts.post = @layoutPath = "layoutPath"
    Given -> @options.dateFormat = @dateFormat = "dateFormat"

    When -> @postsConfig = @subject.forPosts()

    context "with single post source", ->
      Given -> @options.paths.posts = @path = "some/path/**/*"
      Then -> expect(@postsConfig).toEqual {
        @htmlDir
        @layoutPath
        @dateFormat
        src: [@path]
      }

    context "with multiple post sources", ->
      Given -> @options.paths.posts = ["a", null, undefined, "", "b"]
      Then -> expect(@postsConfig).toEqual {
        @htmlDir
        @layoutPath
        @dateFormat
        src: ["a", "b"]
      }
