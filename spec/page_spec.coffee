Page = null
SandboxedModule = require('sandboxed-module')

describe "Page", ->
  Given -> @source = "source"
  Given -> @markdown = "markdown"
  Given -> @header = "attributes"
  Given -> Page = SandboxedModule.require '../lib/page',
    requires:
      'grunt': @grunt = file: read: jasmine.createSpy('grunt.file.read').andReturn(@source)
      './markdown_splitter': @splitter = jasmine.constructSpy('MarkdownSplitter', ['split'])
  Given -> @splitter::split.andReturn({@markdown, @header})

  describe "#constructor", ->
    Given -> @path = "path"
    Given -> @htmlDirPath = "htmlDirPath"
    Given -> @dateFormat = "dateFormat"

    When -> @subject = new Page(@path, @htmlDirPath, @dateFormat)

    Then -> expect(@grunt.file.read).toHaveBeenCalledWith(@path)
    When -> expect(@splitter::split).toHaveBeenCalledWith(@source)
    Then -> @subject.markdown == @markdown
    Then -> @subject.attributes == @header
