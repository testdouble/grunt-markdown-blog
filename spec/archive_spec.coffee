Archive = require('../lib/archive')

describe "Archive", ->
  Given -> @htmlPath = "htmlPath"

  When -> @subject = new Archive(htmlPath: @htmlPath)

  describe "#writeHtml", ->
    Given -> @html = "html"
    Given -> @generatesHtml = jasmine.createStubObj('generatesHtml', generate: @html)
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    When -> @subject.writeHtml(@generatesHtml, @writesFile)

    Then -> expect(@generatesHtml.generate).toHaveBeenCalled()
    Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @htmlPath)

