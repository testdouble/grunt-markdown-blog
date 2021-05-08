Page = null
td = require('testdouble')

describe "Page", ->
  Given ->
    @reader = td.object(['read'])
    @markdown = td.replace('../lib/markdown')
    Page = require '../lib/page'

  describe "#constructor", ->
    Given -> @path = "path"
    Given -> td.when(@reader.read(@path)).thenReturn(@source = "source")
    Given -> @markdown::header = @header = "attributes"
    When -> @subject = new Page(@path, '', '', @reader)
    Then -> td.verify(@markdown(@source))
    Then -> @subject.attributes == @header

  describe "#content", ->
    Given -> @subject = new Page('', '', '', @reader)
    When -> td.when(@markdown::compile()).thenReturn(@parsedMarkdown = "content")
    Then -> @subject.content() == @parsedMarkdown

  describe "#get", ->
    Given -> @subject = new Page('', '', '', @reader)
    When -> @myattr = @subject.get('myattr')

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
    Given -> @subject = new Page('', '', '', @reader)
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
    Given -> @subject = new Page("#{@path = "path/to/pages"}/#{@name = "page"}.md", '', '', @reader)
    When -> @htmlPath = @subject.htmlPath()

    context "with wildcards in htmlDirPath", ->
      Given -> @subject.htmlDirPath = "some/*/path"
      Then -> @htmlPath == "#{@path}/#{@name}.html"

    context "without wildcards in htmlDirPath", ->
      Given -> @subject.htmlDirPath = "some/path"
      Then -> @htmlPath == "#{@subject.htmlDirPath}/#{@name}.html"

  describe "#fileName", ->
    Given -> @subject = new Page("/path/to/pages/mypage.md", '', '', @reader)
    Then -> @subject.fileName() == "mypage.html"

  describe "#date", ->
    Given -> @subject = new Page('', '', '', @reader)
    Then -> @subject.date() == undefined
