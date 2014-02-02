spy = jasmine.createSpy
Post = null
Posts = null
SandboxedModule = require('sandboxed-module')

beforeEach ->
  Posts = SandboxedModule.require '../lib/posts',
    requires:
      './post': Post = jasmine.constructSpy("Post", ["fileName"])


describe "Posts", ->
  Given -> @markdownFiles = [ spy(), spy() ]
  Given -> @layout = jasmine.createSpyObj 'layout', ['htmlFor']
  Given -> @config = jasmine.createSpyObj 'config', ['htmlDir', 'dateFormat', 'comparator']

  When -> @subject = new Posts(@markdownFiles, @layout, @config)

  describe "is array-like", ->
    Then -> @subject instanceof Posts
    Then -> @subject instanceof Array
    Then -> @subject.length == 2


  describe "builds posts", ->
    Given -> @markdownFiles = [ @post1 = spy('post1') ]

    Then -> @subject[0] instanceof Post
    Then -> expect(Post).toHaveBeenCalledWith(@post1, @config.htmlDir, @config.dateFormat)


  describe "is sorted automatically", ->
    Then -> expect(@config.comparator).toHaveBeenCalled()


  describe "#htmlFor", ->
    Given -> @site = "site"
    Given -> @post = "post"
    Given -> @layout.htmlFor.andReturn(@html = "html")
    When -> @htmlFor = @subject.htmlFor(@site, @post)
    Then -> expect(@layout.htmlFor).toHaveBeenCalledWith(site: @site, post: @post)
    Then -> @htmlFor == @html

  describe "#latest", ->
    Given -> @mostRecentPost = "most recent post"
    When -> @subject.splice 0, @subject.length, "first", "second", @mostRecentPost
    When -> @latest = @subject.latest()
    Then -> @latest == @mostRecentPost

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
      Then -> @writesFile.write.callCount == 3
      Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @htmlPath)
