Page = require './page'

module.exports = class Pages
  @:: = new Array
  constructor: (markdownFiles, {htmlDir, layout}) ->
    pages = markdownFiles.map (file) -> new Page(file, htmlDir)
    pages.__proto__ = Pages::
    pages.layout = layout
    return pages

  writeHtml: (generatesHtml, writesFile) ->
    for page in @
      html = generatesHtml.generate(@layout, page)
      writesFile.write(html, page.htmlPath())
