Archive = require('../lib/archive')

describe "Archive", ->
  Given -> @htmlPath = "htmlPath"
  Given -> @layout = "layout"
  Given -> @subject = new Archive({@htmlPath, @layout})

  describe "#writeHtml", ->
    Given -> @html = "html"
    Given ->
      @generatesHtml = td.object('generatesHtml', ['generate'])
      td.when(@generatesHtml.generate(@layout)).thenReturn(@html)
    Given -> @writesFile = td.object('writesFile', ['write'])

    When -> @subject.writeHtml(@generatesHtml, @writesFile)

    Then -> td.verify(@writesFile.write(@html, @htmlPath))
