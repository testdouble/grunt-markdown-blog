spy = jasmine.createSpy
Posts = require('sandboxed-module').require '../lib/posts',
  requires:
    './post': Post = spy('Post')


describe "Posts", ->

  describe "is array-like", ->
    markdownFiles = [ spy(), spy() ]

    Given -> @subject = new Posts(markdownFiles)
    Then -> @subject instanceof Posts
    And -> @subject instanceof Array
    And -> @subject.length == 2


  describe "builds posts", ->
    markdownFiles = [ p1 = spy('p1') ]

    Given -> @subject = new Posts(markdownFiles)
    Then -> expect(Post).toHaveBeenCalledWith(p1)
