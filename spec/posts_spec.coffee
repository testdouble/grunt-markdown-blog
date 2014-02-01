spy = jasmine.createSpy
Post = null
Posts = null
SandboxedModule = require('sandboxed-module')

beforeEach ->
  Posts = SandboxedModule.require '../lib/posts',
    requires:
      './post': Post = jasmine.constructSpy("Post", ["fileName"])


describe "Posts", ->
  Given -> @config = jasmine.createSpyObj 'config', ['htmlDir', 'dateFormat', 'comparator']
  Given -> @markdownFiles = [ spy(), spy() ]

  When -> @subject = new Posts(@markdownFiles, @config)

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
