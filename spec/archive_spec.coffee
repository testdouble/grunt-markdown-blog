Archive = require('../lib/archive')

describe "Archive", ->
  Given -> @htmlPath = "htmlPath"
  Given -> @layout = "layout"
  Given -> @subject = new Archive({@htmlPath, @layout})

  describe "#writeHtml", ->
    Given -> @generatesHtml = jasmine.createStubObj('generatesHtml', generate: @html = "html")
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    When -> @subject.writeHtml(@generatesHtml, @writesFile)

    Then -> expect(@generatesHtml.generate).toHaveBeenCalledWith(@layout)
    Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @htmlPath)
