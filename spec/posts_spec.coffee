spy = jasmine.createSpy
Posts = require('sandboxed-module').require '../lib/posts'

describe "Posts", ->

  describe "is array-like", ->
    markdownFiles = [ spy(), spy() ]

    Given -> @subject = new Posts(markdownFiles)
    Then -> @subject instanceof Posts
    And -> @subject instanceof Array
    And -> @subject.length == 2
