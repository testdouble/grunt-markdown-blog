Page = require './page'

module.exports = class Pages
  constructor: (markdownFiles, {htmlDir, layout}) ->
    pages = markdownFiles.map (file) -> new Page(file, htmlDir)
    pages.layout = layout
    @pages = pages

  htmlFor: (site, page) ->
    # knowingly set as 'post' for backcompat
    # TODO: deprecate page-as-post in context object
    @pages.layout.htmlFor {site, post: page}

  writeHtml: (generatesHtml, writesFile) ->
    for page in @pages
      html = generatesHtml.generate(@pages.layout, page)
      writesFile.write(html, page.htmlPath())
