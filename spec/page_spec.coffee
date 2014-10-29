Page = null
SandboxedModule = require('sandboxed-module')

describe "Page", ->
  Given -> Page = SandboxedModule.require '../lib/page',
    requires:
      'grunt': @grunt = file: read: jasmine.createSpy('grunt.file.read')
      './markdown': @markdown = jasmine.constructSpy('Markdown', ['compile'])

  describe "#constructor", ->
    Given -> @path = "path"
    Given -> @grunt.file.read.andReturn(@source = "source")
    Given -> @markdown::header = @header = "attributes"

    When -> @subject = new Page(@path)

    Then -> expect(@grunt.file.read).toHaveBeenCalledWith(@path)
    Then -> expect(@markdown).toHaveBeenCalledWith(@source)
    Then -> @subject.attributes == @header

  describe "#content", ->
    Given -> @subject = new Page()
    Given -> @markdown::compile.andReturn(@parsedMarkdown = "content")

    When -> @content = @subject.content()

    Then -> expect(@markdown::compile).toHaveBeenCalled()
    Then -> @content == @parsedMarkdown

  describe "#get", ->
    Given -> @subject = new Page()
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
    Given -> @subject = new Page()
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

  describe "#destPath", ->
    Given -> @subject = new Page("#{@path = "path/to/pages"}/#{@name = "page"}.md")
    When -> @destPath = @subject.htmlPath()

    context "with wildcards in htmlDirPath", ->
      Given -> @subject.htmlDirPath = "some/*/path"
      Then -> @destPath == "#{@path}/#{@name}.html"

    context "without wildcards in htmlDirPath", ->
      Given -> @subject.htmlDirPath = "some/path"
      Then -> @destPath == "#{@subject.htmlDirPath}/#{@name}.html"

  describe "#fileName", ->
    Given -> @subject = new Page("/path/to/pages/mypage.md")
    Then -> @subject.fileName() == "mypage.html"

  describe "#date", ->
    Given -> @subject = new Page()
    Then -> @subject.date() == undefined
