Archive = require('../lib/archive')

describe "Archive", ->
  Given -> @destPath = "destPath"
  Given -> @layout = "layout"
  Given -> @subject = new Archive({@destPath, @layout})

  describe "#writeHtml", ->
    Given -> @generatesHtml = jasmine.createStubObj('generatesHtml', generate: @html = "html")
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    When -> @subject.writeHtml(@generatesHtml, @writesFile)

    Then -> expect(@generatesHtml.generate).toHaveBeenCalledWith(@layout)
    Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @destPath)
