Page = null
SandboxedModule = require('sandboxed-module')

describe "Page", ->
  Given -> @source = "source"
  Given -> @markdown = "markdown"
  Given -> @header = "attributes"
  Given -> Page = SandboxedModule.require '../lib/page',
    requires:
      'grunt': @grunt = file: read: jasmine.createSpy('grunt.file.read').andReturn(@source)
      'marked': @marked = jasmine.createSpyObj('marked', ['lexer', 'parser', 'setOptions'])
      './markdown_splitter': @splitter = jasmine.constructSpy('MarkdownSplitter', ['split'])
  Given -> @splitter::split.andReturn({@markdown, @header})

  describe "#constructor", ->
    Given -> @path = "path"
    Given -> @htmlDirPath = "htmlDirPath"
    Given -> @dateFormat = "dateFormat"

    When -> @subject = new Page(@htmlDirPath, @path, @dateFormat)

    Then -> expect(@grunt.file.read).toHaveBeenCalledWith(@path)
    When -> expect(@splitter::split).toHaveBeenCalledWith(@source)
    Then -> @subject.markdown == @markdown
    Then -> @subject.attributes == @header

  describe "#content", ->
    Given -> @subject = new Page()
    Given -> @marked.lexer.andReturn(@lexed = "lexed")
    Given -> @marked.parser.andReturn(@parsedMarkdown = "content")

    When -> @content = @subject.content()

    Then -> expect(@marked.lexer).toHaveBeenCalledWith(@markdown)
    Then -> expect(@marked.parser).toHaveBeenCalledWith(@lexed)
    Then -> @content == @parsedMarkdown

  describe "#get", ->
    Given -> @subject = new Page()
    When -> @myattr = @subject.get('myattr')

    context "undefined attribute", ->
      Given -> @subject.attributes = {}
      Then -> @myattr == undefined

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

  describe "#htmlPath", ->
    When -> @htmlPath = @subject.htmlPath()

    context "strips out htmlDir", ->
      Given -> @subject = new Page("generated", "generated/#{@path = "path/to/pages/page"}.md")
      Then -> @htmlPath == "#{@path}.html"

    context "removes index.html", ->
      Given -> @subject = new Page("", "#{@path = "path/to/slug/"}index.md")
      Then -> @htmlPath == @path

  describe "#fileName", ->
    Given -> @subject = new Page("", "/path/to/pages/mypage.md")
    Then -> @subject.fileName() == "mypage.html"

  describe "#date", ->
    Given -> @subject = new Page()
    Then -> @subject.date() == undefined
