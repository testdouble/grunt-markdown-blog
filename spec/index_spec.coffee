Index = require("../lib/index")

describe "Index", ->
  Given -> @latestPost = "latestPost"
  Given -> @htmlPath = "htmlPath"
  Given -> @layout = "layout"
  Given -> @subject = new Index(@latestPost, {@htmlPath, @layout})

  describe "#writeHtml", ->
    Given ->
      @html = "html"
      @generatesHtml = td.object("generatesHtml", ["generate"])
      td.when(@generatesHtml.generate(@layout, @latestPost)).thenReturn(@html)
    Given -> @writesFile = td.object("writesFile", ["write"])
    When -> @subject.writeHtml(@generatesHtml, @writesFile)
    Then -> td.verify(@writesFile.write(@html, @htmlPath))
