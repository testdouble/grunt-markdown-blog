Post = null
Posts = null
SandboxedModule = require('sandboxed-module')

beforeEach ->
  Posts = SandboxedModule.require '../lib/posts',
    requires:
      './post': Post = jasmine.constructSpy("Post", ["fileName"])


describe "Posts", ->
  Given -> @markdownFiles = [ "md1", "md2" ]
  Given -> @config = jasmine.createSpyObj 'config', ['htmlDir', 'layout', 'dateFormat', 'comparator']

  When -> @subject = new Posts(@markdownFiles, @config)

  describe "is array-like", ->
    Then -> @subject instanceof Posts
    Then -> @subject instanceof Array
    Then -> @subject.length == 2


  describe "builds posts", ->
    Given -> @markdownFiles = [ @post1 = jasmine.createSpy('post1') ]

    Then -> @subject[0] instanceof Post
#    Then -> expect(Post).toHaveBeenCalledWith(@post1, @config.htmlDir, @config.dateFormat)


  describe "is sorted automatically", ->
    Then -> expect(@config.comparator).toHaveBeenCalled()


  describe "#htmlFor", ->
    Given -> @site = "site"
    Given -> @post = "post"
    Given -> @html = "html"
    Given -> @config.layout.htmlFor = jasmine.createSpy('layout.htmlFor').andReturn(@html)
    When -> @htmlFor = @subject.htmlFor(@site, @post)
    Then -> expect(@config.layout.htmlFor).toHaveBeenCalledWith(site: @site, post: @post)
    Then -> @htmlFor == @html

  describe "#writeHtml", ->
    Given -> @html = "html"
    Given -> @generatesHtml = jasmine.createStubObj('generatesHtml', generate: @html)
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    context "without posts", ->
      Given -> @markdownFiles = []
      When -> @subject.writeHtml(@generatesHtml, @writesFile)
      Then -> expect(@generatesHtml.generate).not.toHaveBeenCalled()
      Then -> expect(@writesFile.write).not.toHaveBeenCalled()

    context "with 3 posts", ->
      Given -> @htmlPath = "htmlPath"
      Given -> @post = jasmine.createStubObj('post', htmlPath: @htmlPath)
      When -> @subject.splice 0, @subject.length, @post, @post, @post
      When -> @subject.writeHtml(@generatesHtml, @writesFile)
      Then -> @generatesHtml.generate.callCount == 3
      Then -> expect(@generatesHtml.generate).toHaveBeenCalledWith(@config.layout, @post)
      Then -> @writesFile.write.callCount == 3
      Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @htmlPath)

  describe '', ->
    Given -> [@post1, @post2, @post3] = ["oldest", "middle", "newest"]
    When -> @subject.splice 0, @subject.length, @post1, @post2, @post3

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
        Then -> expect(@older).toBeUndefined()

      context "given a newer post", ->
        Given -> @post = @post2
        Then -> @older == @post1

    describe "#newer", ->
      When -> @newer = @subject.newer(@post)

      context "given the latest post", ->
        Given -> @post = @post3
        Then -> expect(@newer).toBeUndefined()

      context "given an older post", ->
        Given -> @post = @post2
        Then -> @newer == @post3
