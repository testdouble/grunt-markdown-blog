spy = jasmine.createSpy
M = (classNameToFake, methodsToSpy = []) ->
  spies = class extends jasmine.createSpy(classNameToFake)
  methodsToSpy.forEach (methodName) ->
    spies::[methodName] = jasmine.createSpy("#{classNameToFake}##{methodName}")
  spies

SandboxedModule = require('sandboxed-module')
Post = null
Posts = null

beforeEach ->
  Posts = SandboxedModule.require '../lib/posts',
    requires:
      './post': Post = M("Post", ["fileName"])


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

    Then -> expect(@subject).toEqual [jasmine.any(Post)]
    Then -> expect(Post).toHaveBeenCalledWith(@post1, @config.htmlDir, @config.dateFormat)


  describe "is sorted automatically", ->
    Then -> expect(@config.comparator).toHaveBeenCalled()
