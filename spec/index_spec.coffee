Index = require('../lib/index')

describe "Index", ->
  Given -> @latestPost = "latestPost"
  Given -> @destPath = "destPath"
  Given -> @layout = "layout"
  Given -> @subject = new Index(@latestPost, {@destPath, @layout})

  describe "#writeHtml", ->
    Given -> @generatesHtml = jasmine.createStubObj('generatesHtml', generate: @html = "html")
    Given -> @writesFile = jasmine.createSpyObj('writesFile', ['write'])

    When -> @subject.writeHtml(@generatesHtml, @writesFile)

    Then -> expect(@generatesHtml.generate).toHaveBeenCalledWith(@layout, @latestPost)
    Then -> expect(@writesFile.write).toHaveBeenCalledWith(@html, @destPath)
