SandboxedModule = require('sandboxed-module')
Archive = null
grunt = null

beforeEach ->
  Archive = SandboxedModule.require '../lib/archive',
    requires:
      'grunt': grunt = log: error: jasmine.createSpy('grunt-log')

describe "Archive", ->
  Given -> @config = jasmine.createSpyObj 'config', ['htmlPath', 'layout']

  When -> @subject = new Archive(@config)

  describe "#writeHtml", ->
    Given -> @html = "html"
    Given -> @generatesHtml = jasmine.createStubObj('generatesHtml', generate: @html)
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    When -> @subject.writeHtml(@generatesHtml, @writesFile)

    context "with destination path", ->
      Then -> expect(@generatesHtml.generate).toHaveBeenCalledWith(@config.layout)
      Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @config.htmlPath)

    context "without destination path", ->
      Given -> @config.htmlPath = undefined

      Then -> expect(@generatesHtml.generate).not.toHaveBeenCalled()
      Then -> expect(@writesFile.write).not.toHaveBeenCalled()
      Then -> expect(grunt.log.error).toHaveBeenCalled()
