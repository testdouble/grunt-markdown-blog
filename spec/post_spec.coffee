Post = null
SandboxedModule = require('sandboxed-module')

describe "Post", ->
  Given -> Post = SandboxedModule.require '../lib/post',
    requires:
      './../lib/page': class

  Given -> @subject = new Post

  describe "#time", ->
    context "with date attribute", ->
      Given -> @subject.attributes = date: "2000-01-01"

      context "with filename date", ->
        Given -> @subject.path = "app/posts/1999-01-01-some-title"
        Then -> @subject.time() == @subject.attributes.date

      context "without filename date", ->
        Given -> @subject.path = "app/posts/some-title"
        Then -> @subject.time() == @subject.attributes.date

    context "without date attribute", ->
      Given -> @subject.attributes = {}

      context "with filename date", ->
        Given -> @subject.path = "app/posts/1999-01-01-some-title"
        Then -> @subject.time() == "1999-01-01"

      context "without filename date", ->
        Given -> @subject.path = "app/posts/some-title"
        Then -> @subject.time() typeof "function"
