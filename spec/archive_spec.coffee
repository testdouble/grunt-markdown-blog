SandboxedModule = require('sandboxed-module')
Archive = null
NullArchive = require('../lib/null_archive')
grunt = null

beforeEach ->
  Archive = SandboxedModule.require '../lib/archive',
    requires:
      'grunt': grunt = log: writeln: jasmine.createSpy('grunt-log')
      './null_archive': NullArchive

describe "Archive", ->

  describe "::create", ->
    When -> @archive = Archive.create({@htmlPath, @layout})

    context "with htmlPath", ->
      Given -> @htmlPath = "htmlPath"
      Then -> @archive instanceof Archive
      And -> expect(grunt.log.writeln).not.toHaveBeenCalled()

    context "without htmlPath", ->
      Given -> @htmlPath = undefined
      Then -> @archive instanceof NullArchive
      And -> expect(grunt.log.writeln).toHaveBeenCalled()


  describe "#writeHtml", ->
    Given -> @htmlPath = "htmlPath"
    Given -> @layout = "layout"
    Given -> @generatesHtml = jasmine.createStubObj('generatesHtml', generate: @html = "html")
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])
    Given -> @subject = new Archive({@htmlPath, @layout})

    When -> @subject.writeHtml(@generatesHtml, @writesFile)

    Then -> expect(@generatesHtml.generate).toHaveBeenCalledWith(@layout)
    Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @htmlPath)
