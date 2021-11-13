Post = null
Posts = null

beforeEach ->
  Post  = td.replace("../lib/post", td.constructor(["fileName"]))
  Posts = require "../lib/posts"

afterEach ->
  td.reset()

describe "Posts", ->
  Given -> @config = td.object "config", ["htmlDir", "layout", "dateFormat", "comparator"]
  Given -> @markdownFiles = [ "post1", "post2" ]
  When  -> @subject = new Posts(@markdownFiles, @config)

  describe "has posts", ->
    Then -> @subject.posts.length == 2

  describe "builds posts", ->
    Given -> @markdownFiles = [ "post1" ]
    Then -> @subject.posts[0] instanceof Post
    Then -> td.verify(Post("post1", @config.htmlDir, @config.dateFormat))

  describe "is sorted automatically", ->
    Then -> td.verify(@config.comparator(td.matchers.isA(Post), td.matchers.isA(Post)))

  describe "#htmlFor", ->
    Given -> @site = "site"
    Given -> @post = "post"
    Given -> @html = "html"
    Given ->
      @config.layout.htmlFor = td.function("layout.htmlFor")
      td.when(@config.layout.htmlFor(site: @site, post: @post)).thenReturn(@html)
    When -> @htmlFor = @subject.htmlFor(@site, @post)
    Then -> @htmlFor == @html

  describe "#writeHtml", ->
    Given -> @html = "html"
    Given -> @generatesHtml = td.object("generatesHtml", ["generate"])
    Given -> @writesFile = td.object("writesFile", ["write"])

    context "without pages", ->
      Given -> @markdownFiles = []
      When -> @subject.writeHtml(@generatesHtml, @writesFile)
      Then -> td.verify(@generatesHtml.generate(), {times: 0, ignoreExtraArgs: true })
      Then -> td.verify(@writesFile.write(), {times: 0, ignoreExtraArgs: true })

    context "with 3 posts", ->
      Given -> @htmlPath = "htmlPath"
      Given ->
        @post = td.object("post", ["htmlPath"])
        td.when(@post.htmlPath()).thenReturn(@htmlPath)
      When ->
        @subject.posts = [@post, @post, @post]
        @subject.posts.layout = @config.layout
      When ->
        td.when(@generatesHtml.generate(@config.layout, @post)).thenReturn(@html)
      When -> @subject.writeHtml(@generatesHtml, @writesFile)
      Then -> td.verify(@writesFile.write(@html, @htmlPath), { times: 3})

  describe "", ->
    Given -> [@post1, @post2, @post3] = ["oldest", "middle", "newest"]
    When -> @subject.posts = [@post1, @post2, @post3]

    describe "#oldest", ->
      When -> @oldest = @subject.oldest()
      Then -> @oldest == @post1

    describe "#newest", ->
      When -> @newest = @subject.newest()
      Then -> @newest == @post3

    describe "#older", ->
      When -> @older = @subject.older(@post)

      context "given the oldest post", ->
        Given -> @post = @post1
        Then -> @older == undefined

      context "given a newer post", ->
        Given -> @post = @post2
        Then -> @older == @post1

    describe "#newer", ->
      When -> @newer = @subject.newer(@post)

      context "given the latest post", ->
        Given -> @post = @post3
        Then -> @newer == undefined

      context "given an older post", ->
        Given -> @post = @post2
        Then -> @newer == @post3
