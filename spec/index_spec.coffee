Index = require('../lib/index')

describe "Index", ->
  Given -> @latestPost = "latestPost"
  Given -> @config = jasmine.createSpyObj 'config', ['htmlPath', 'layout']

  When -> @subject = new Index(@latestPost, @config)

  describe "#writeHtml", ->
    Given -> @html = "html"
    Given -> @generatesHtml = jasmine.createStubObj('generatesHtml', generate: @html)
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    When -> @subject.writeHtml(@generatesHtml, @writesFile)

    Then -> expect(@generatesHtml.generate).toHaveBeenCalledWith(@config.layout, @latestPost)
    Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @config.htmlPath)
