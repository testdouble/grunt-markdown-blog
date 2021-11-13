Page = require './page'

module.exports = class Pages
  constructor: (markdownFiles, {htmlDir, layout}) ->
    pages = markdownFiles.map (file) -> new Page(file, htmlDir)
    pages.layout = layout
    @pages = pages

  htmlFor: (site, page) ->
    @pages.layout.htmlFor {site, page}

  writeHtml: (generatesHtml, writesFile) ->
    for page in @pages
      html = generatesHtml.generate(@pages.layout, page)
      writesFile.write(html, page.htmlPath())
