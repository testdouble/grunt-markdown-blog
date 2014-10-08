Categories = null
Post = null
SandboxedModule = require('sandboxed-module')

describe "Categories", ->
  Given -> @extendedContext = jasmine.createSpy("extendedContext")
  Given -> @htmlPath = "htmlPath"
  Given ->
    Post = jasmine.constructSpy("Post", ["fileName", "attributes"])
    Categories = SandboxedModule.require '../lib/categories',
      requires:
        './post': Post
        'underscore': @_ = do =>
          _ = jasmine.createSpy("underscore")
          _.slugify = -> return "slug"
          _.isArray = -> return true
          _.mixin = ->
          _.extend = jasmine.createSpy("extend").andReturn(@extendedContext)
          _.andReturn(_)
        'path': @path =
          join: jasmine.createSpy("path").andReturn(@htmlPath)

  Given -> @markdownFiles = [ "md1", "md2" ]
  Given -> @config = jasmine.createSpyObj 'config', ['htmlDir', 'layout', 'dateFormat', 'comparator']
  Given -> Post::attributes.categories = ["cat1", "cat2"]
  Given -> @subject = new Categories(@markdownFiles, @config)

  describe "is array-like", ->

    When -> @subject = new Categories(@markdownFiles, @config)

    Then -> @subject instanceof Categories
    Then -> @subject instanceof Array
    Then -> @subject.length == 2


  describe "builds posts", ->
    Given -> @markdownFiles = [ @post1 = jasmine.createSpy('post1') ]

    Given -> @subject = new Categories(@markdownFiles, @config)

    Then -> typeof @subject[0] == "string"
    Then -> expect(Post).toHaveBeenCalledWith(@post1, @config.htmlDir, @config.dateFormat)


  describe "is sorted automatically", ->
    Then -> expect(@config.comparator).toHaveBeenCalled()


  describe "#writeHtml", ->
    Given -> @html = "html"
    Given -> @generatesHtml = jasmine.createStubObj('generatesHtml', generate: @html)
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    context "without categories", ->
      Given -> Post::attributes.categories = []
      Given -> @subject = new Categories(@markdownFiles, @config)

      When -> @subject.writeHtml(@generatesHtml, @writesFile)
      Then -> expect(@generatesHtml.generate).not.toHaveBeenCalled()
      Then -> expect(@writesFile.write).not.toHaveBeenCalled()

    context "with 3 posts", ->
      Given -> @post = jasmine.createStubObj('post', htmlPath: @htmlPath)
      When -> @subject.splice 0, @subject.length, @post, @post, @post
      When -> @subject.writeHtml(@generatesHtml, @writesFile)
      Then -> @generatesHtml.generate.callCount == 3
      Then -> expect(@generatesHtml.generate).toHaveBeenCalledWith(@config.layout, @post)
      Then -> @writesFile.write.callCount == 3
      Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @htmlPath)
