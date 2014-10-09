Markdown = null
SandboxedModule = require('sandboxed-module')

describe "Markdown", ->
  Given -> Markdown = SandboxedModule.require '../lib/markdown',
    requires:
      './markdown_splitter': @splitter = jasmine.constructSpy('MarkdownSplitter', ['split'])
      'marked': @marked = jasmine.createSpy('marked')

  Given -> @header = "attributes"
  Given -> @markdown = "markdown"
  Given -> @splitter::split.andReturn({@header, @markdown})

  describe "#constructor", ->
    Given -> @inputSource = "source"

    When -> @subject = new Markdown(@inputSource)

    Then -> expect(@splitter::split).toHaveBeenCalledWith(@inputSource)
    Then -> @subject.header == @header
    Then -> @subject.source == @markdown

  describe "#compile", ->
    Given -> @subject = new Markdown()
    Given -> @marked.andReturn(@compiledHtml = "compiled html")

    When -> @html = @subject.compile()

    Then -> expect(@marked).toHaveBeenCalledWith(@subject.source, jasmine.any(Object))
    Then -> @html == @compiledHtml
