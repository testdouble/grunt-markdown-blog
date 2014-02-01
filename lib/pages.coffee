Page = require './page'

module.exports = class Pages
  @:: = new Array
  constructor: (markdownFiles, {htmlDir}) ->
    pages = markdownFiles.map (file) -> new Page(file, htmlDir)
    pages.__proto__ = Pages::
    return pages

  writeHtml: (generatesHtml, writesFile) ->
    for page in @
      html = generatesHtml.generate(page)
      writesFile.write(html, page.htmlPath())
