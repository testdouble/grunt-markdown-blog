Page = null
reader = null
Markdown = null

beforeEach ->
  Markdown = td.replace("../lib/markdown", td.constructor(["compile"]))
  @reader = td.object("reader", ["read"])
  Page = require("../lib/page")

afterEach ->
  td.reset()

describe "Page", ->
  Given ->
    @reader = td.object(["read"])

  describe "#constructor", ->
    Given -> @path = "path"
    Given -> td.when(@reader.read(@path)).thenReturn(@source = "source")
    When -> @subject = new Page(@path, "", "", @reader)
    Then -> td.verify(Markdown(@source))
    Then -> @subject.attributes == @header

  describe "#content", ->
    Given -> @subject = new Page("", "", "", @reader)
    When -> td.when(@subject.markdown.compile()).thenReturn(@parsedMarkdown = "content")
    Then -> @subject.content() == @parsedMarkdown

  describe "#get", ->
    Given -> @subject = new Page("", "", "", @reader)
    When -> @myattr = @subject.get("myattr")

    context "undefined attribute", ->
      Given -> @subject.attributes = {}
      Then -> @myattr == undefined

    context "null attribute", ->
      Given -> @subject.attributes = myattr: null
      Then -> @myattr == null

    context "false attribute", ->
      Given -> @subject.attributes = myattr: false
      Then -> @myattr == false

    context "value attribute", ->
      Given -> @subject.attributes = myattr: @value = 1
      Then -> @myattr == @value

    context "function attribute", ->
      Given -> @subject.attributes = myattr: @value = -> 1
      Then -> @myattr == @value()

  describe "#title", ->
    Given -> @subject = new Page("", "", "", @reader)
    When -> @title = @subject.title()

    context "from attribute", ->
      Given -> @subject.attributes = title: "attribute title"
      Then -> @title == "attribute title"

    context "from path", ->
      context "with date", ->
        Given -> @subject.path = "some/path/1999-12-21-path-title.md"
        Then -> @title == "path title"
      context "without date", ->
        Given -> @subject.path = "some/path/no-date-path-title.md"
        Then -> @title == "no-date-path-title.html"

    context "from filename", ->
      Given -> @subject.path = "some/weird/path.md"
      Then -> @title == "path.html"

  describe "#htmlPath", ->
    Given -> @subject = new Page("#{@path = "path/to/pages"}/#{@name = "page"}.md", "", "", @reader)
    When -> @htmlPath = @subject.htmlPath()

    context "without htmlDirPath (the root)", ->
      Given -> @subject.htmlDirPath = null
      Then -> @htmlPath == "#{@name}.html"

    context "with htmlDirPath", ->
      Given -> @subject.htmlDirPath = "some/path"
      Then -> @htmlPath == "#{@subject.htmlDirPath}/#{@name}.html"

  describe "#fileName", ->
    Given -> @subject = new Page("/path/to/pages/mypage.md", "", "", @reader)
    Then -> @subject.fileName() == "mypage.html"

  describe "#date", ->
    Given -> @subject = new Page("", "", "", @reader)
    Then -> @subject.date() == undefined
