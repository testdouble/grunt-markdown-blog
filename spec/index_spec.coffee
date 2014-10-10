SandboxedModule = require('sandboxed-module')
Index = null
NullIndex = require('../lib/null_index')
grunt = null

beforeEach ->
  Index = SandboxedModule.require '../lib/index',
    requires:
      'grunt': grunt = log: writeln: jasmine.createSpy('grunt-log')
      './null_index': NullIndex


describe "Index", ->
  Given -> @latestPost = "latestPost"

  describe "::create", ->
    When -> @index = Index.create(@latestPost, {@htmlPath, @layout})

    context "with htmlPath", ->
      Given -> @htmlPath = "htmlPath"
      Then -> @index instanceof Index
      And -> expect(grunt.log.writeln).not.toHaveBeenCalled()

    context "without htmlPath", ->
      Given -> @htmlPath = undefined
      Then -> @index instanceof NullIndex
      And -> expect(grunt.log.writeln).toHaveBeenCalled()


  Given -> @htmlPath = "htmlPath"
  Given -> @layout = "layout"
  Given -> @subject = new Index(@latestPost, {@htmlPath, @layout})

  describe "#writeHtml", ->
    Given -> @generatesHtml = jasmine.createStubObj('generatesHtml', generate: @html = "html")
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    When -> @subject.writeHtml(@generatesHtml, @writesFile)

    Then -> expect(@generatesHtml.generate).toHaveBeenCalledWith(@layout, @latestPost)
    Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @htmlPath)
