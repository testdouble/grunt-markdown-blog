spy = jasmine.createSpy
Post = null
Posts = null

beforeEach ->
  class (foo = {}).Post
    filename: ->
  Post = spyOnConstructor(foo, "Post", "fileName")

  Posts = require('sandboxed-module').require '../lib/posts',
    requires:
      './post': foo.Post


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

    Then -> expect(@subject).toEqual [jasmine.any(Post.constructor.fake)]
    Then -> expect(Post.constructor).toHaveBeenCalledWith(@post1, @config.htmlDir, @config.dateFormat)


  describe "is sorted automatically", ->
    Then -> expect(@config.comparator).toHaveBeenCalled()
