Index = require('../lib/index')

describe "Index", ->
  Given -> @latestPost = "latestPost"
  Given -> @htmlPath = "htmlPath"

  When -> @subject = new Index(@latestPost, htmlPath: @htmlPath)

  describe "#writeHtml", ->
    Given -> @html = "html"
    Given -> @generatesHtml = jasmine.createStubObj('generatesHtml', generate: @html)
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    When -> @subject.writeHtml(@generatesHtml, @writesFile)

    Then -> expect(@generatesHtml.generate).toHaveBeenCalledWith(@latestPost)
    Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @htmlPath)
