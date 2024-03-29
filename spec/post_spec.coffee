Page = null
Post = null

beforeEach ->
  Page = td.replace("../lib/page")
  Post = require "../lib/post"

afterEach ->
  td.reset()

describe "Post", ->
  Given -> @subject = new Post

  describe "#time", ->
    Given -> @subject.get = td.function("get")

    context "with date attribute", ->
      Given -> td.when(@subject.get("date")).thenReturn(@time = "2000-01-01")

      context "with filename date", ->
        Given -> @subject.path = "app/posts/1999-01-01-some-title"
        Then -> @subject.time() == @time

      context "without filename date", ->
        Given -> @subject.path = "app/posts/some-title"
        Then -> @subject.time() == @time

    context "without date attribute", ->
      Given -> td.when(@subject.get("date")).thenReturn(undefined)

      context "with filename date", ->
        Given -> @subject.path = "app/posts/1999-01-01-some-title"
        Then -> @subject.time() == "1999-01-01"

      context "without filename date", ->
        Given -> @subject.path = "app/posts/some-title"
        Then -> @subject.time() typeof "function"
